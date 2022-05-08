//
//  ReaderCollectionViewController.swift
//  Parser
//
//  Created by Кирилл Тила on 04.05.2022.
//

import UIKit
import SDWebImage
import Combine
import Zoomy

final class PageCell: UICollectionViewCell {
    
    static let resuseID: String = String(describing: PageCell.self)
    
    private let imageView: UIImageView = {
        let view: UIImageView = .init()
        view.contentMode = .scaleAspectFit
        view.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
        return view
    }()
    
    public var image: UIImageView {
        return self.imageView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
    
    final func configure(imageURL: URL?) {
        imageView.sd_setImage(with: imageURL, placeholderImage: nil,
                              options: [.continueInBackground, .highPriority, .retryFailed, .preloadAllFrames])
    }

}

final class ReaderCollectionViewController: UIViewController {

    // MARK: - Variables
    @Published private var pageText = "1"
    private var store: Set<AnyCancellable> = []

    private let link: URL
    private let titleManga: String
    private var isPageSet: Bool = false
    private var imageURLs: [URL]? {
        didSet {
            updatePageData()
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    private var numberPage: Int {
        get {
            UserDefaults.standard.integer(forKey: titleManga)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: titleManga)
        }
    }
    
    //MARK: - Views
    private let indicator: UIActivityIndicatorView = {
        let indicator: UIActivityIndicatorView = .init(style: .medium)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        return indicator
    }()
    private var pagingView: UIView = .init(frame: .zero)
    private var vStack: UIStackView = {
        let vStack: UIStackView = .init(frame: .zero)
        vStack.alignment = .center
        vStack.axis = .vertical
        vStack.distribution = .fill
        vStack.spacing = .zero
        return vStack
    }()
    private let pageLable: UILabel = {
        let label: UILabel = .init(frame: .zero)
        label.isHidden = true
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    private let pageControl: UIPageControl = .init(frame: .zero)
    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = .init()
        layout.scrollDirection = .horizontal
        layout.itemSize = view.bounds.size
        layout.minimumLineSpacing = .zero
        layout.sectionInset = .zero
        let collection: UICollectionView = .init(frame: .zero, collectionViewLayout: layout)
        collection.dataSource = self
        collection.delegate = self
        collection.isPagingEnabled = true
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .black
        collection.register(PageCell.self, forCellWithReuseIdentifier: PageCell.resuseID)
        return collection
    }()
    
    init(link: URL, title: String) {
        self.link = link
        self.titleManga = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addSubviews()
        setupTargetPageControl()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.global(qos: .userInteractive).async {
            self.imageURLs = ParsingService.fetchMangaPagesLink(url: self.link)
        }
        setupNavBar()
        binding()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }

}

private extension ReaderCollectionViewController {
    
    /// call in viewDidAppear
    func setupNavBar() {
        overrideUserInterfaceStyle = .dark
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
    }
    
    func addSubviews() {
        view.addSubview(collectionView)
        view.addSubview(indicator)
        view.addSubview(pagingView)
        pagingView.addSubview(vStack)
        vStack.addArrangedSubview(pageLable)
        vStack.addArrangedSubview(pageControl)
    }
    
    func setupLayout() {
        collectionView.frame = view.bounds
        pagingView.frame = .init(x: .zero, y: view.bounds.height - 60 - view.safeAreaInsets.bottom,
                                 width: view.bounds.width,
                                 height: 50)
        vStack.frame = pagingView.bounds
        indicator.center = view.center
    }
    
    func binding() {
        $pageText
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] text in
                self.pageLable.text = text + "\\" + "\(self.imageURLs?.count ?? 0)"
            }
            .store(in: &store)
    }
    
    func updatePageData() {
        DispatchQueue.main.async { [unowned self] in
            collectionView.reloadData()
            pageControl.numberOfPages = imageURLs?.count ?? 0
            pageControl.currentPage = numberPage
            pageLable.text = pageText + "\\" + "\(self.imageURLs?.count ?? 0)"
            selectItem(at: .init(item: numberPage, section: 0))
            pageLable.isHidden = false
            indicator.stopAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.isPageSet = true
            }
            print(numberPage)
        }
    }
    
    func setupTargetPageControl() {
        pageControl.addTarget(self, action: #selector(valueChangePageControl), for: .valueChanged)
    }
    
    @objc func valueChangePageControl(_ sender: UIPageControl) {
        selectItem(at: .init(item: sender.currentPage, section: 0))
    }
    
    func selectItem(at index: IndexPath) {
        DispatchQueue.main.async {
            self.collectionView.isPagingEnabled = false
            self.collectionView.selectItem(at: index,
                                           animated: false, scrollPosition: .centeredHorizontally)
            self.collectionView.isPagingEnabled = true
        }
    }

}

extension ReaderCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        pageText = "\(Int(pageIndex) + 1)"
        if isPageSet {
            numberPage = Int(pageIndex)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageCell.resuseID, for: indexPath) as? PageCell,
              let imageURLs = imageURLs
        else {
            return PageCell()
        }
        let imageURL = imageURLs[indexPath.item]
        cell.configure(imageURL: imageURL)
        addZoombehavior(for: cell.image, below: pagingView)
        return cell
    }
    
    
}
