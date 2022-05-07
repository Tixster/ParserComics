//
//  ReaderCollectionViewController.swift
//  Parser
//
//  Created by Кирилл Тила on 04.05.2022.
//

import UIKit
import SDWebImage
import Combine

class PageCell: UICollectionViewCell {
    
    static let resuseID: String = String(describing: PageCell.self)
    
    private let imageView: UIImageView = {
        let view: UIImageView = .init()
        view.contentMode = .scaleAspectFit
        view.enableZoom()
        view.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
        return view
    }()
    
    
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
    
    private let link: URL
    private let titleManga: String
    @Published private var pageText = "1"
    private var isPageSet: Bool = false
    
    private var numberPage: Int {
        get {
            UserDefaults.standard.integer(forKey: titleManga)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: titleManga)
        }
    }
    
    private var imageURLs: [URL]? {
        didSet {
            DispatchQueue.main.async { [unowned self] in
                collectionView.reloadData()
                pageControl.numberOfPages = imageURLs?.count ?? 0
                pageControl.currentPage = numberPage
                pageLable.text = pageText + "\\" + "\(self.imageURLs?.count ?? 0)"
                collectionView.isPagingEnabled = false
                collectionView.selectItem(at: .init(item: numberPage, section: 0), animated: false, scrollPosition: .centeredHorizontally)
                collectionView.isPagingEnabled = true
                pageLable.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                    self?.isPageSet = true
                }
                print(numberPage)
            }
        }
    }
    
    private var store: Set<AnyCancellable> = []
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
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
        overrideUserInterfaceStyle = .dark
        navigationController?.navigationBar.isHidden = true
        view.addSubview(collectionView)
        view.backgroundColor = .black
        view.addSubview(pageLable)
        setupPageControl()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.global(qos: .userInteractive).async {
            self.imageURLs = ParsingService.fetchMangaPagesLink(url: self.link)
        }
        $pageText
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] text in
                self.pageLable.text = text + "\\" + "\(self.imageURLs?.count ?? 0)"
            }
            .store(in: &store)
        pageControl.addTarget(self, action: #selector(valueChange), for: .valueChanged)
        navigationController?.navigationBar.barStyle = .black
        setNeedsStatusBarAppearanceUpdate()
    }
    
    @objc private func valueChange(_ sender: UIPageControl) {
        DispatchQueue.main.async {
            self.collectionView.isPagingEnabled = false
            self.collectionView.selectItem(at: .init(item: sender.currentPage, section: 0), animated: false, scrollPosition: .centeredHorizontally)
            self.collectionView.isPagingEnabled = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        pageControl.frame = CGRect(x: .zero,
                                   y: view.bounds.height - 60 - view.safeAreaInsets.bottom,
                                   width: view.bounds.width,
                                   height: 30)
        pageControl.center.x = view.center.x
        pageLable.frame = CGRect(x: .zero,
                                 y: pageControl.frame.minY - 20,
                                 width: view.bounds.width,
                                 height: 20)
        pageLable.center.x = view.center.x
    }
    
    func setupPageControl() {
        view.addSubview(pageControl)
        view.bringSubviewToFront(pageControl)
    }

}

extension ReaderCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
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
        return cell
    }
    
    
}

extension UIImageView {
  func enableZoom() {
    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
    isUserInteractionEnabled = true
    addGestureRecognizer(pinchGesture)
  }

  @objc
  private func startZooming(_ sender: UIPinchGestureRecognizer) {
    let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
    guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
    sender.view?.transform = scale
    sender.scale = 1
  }
}
