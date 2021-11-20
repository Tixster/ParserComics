//
//  MainCollectionView.swift
//  Parser
//
//  Created by Кирилл Тила on 30.10.2021.
//

import UIKit

class MainCollectionView: UICollectionView {
    
    private var titles: [TitleModel]
    var currentIndexPathItem: Int
    var fetchNextTitles: (() -> Void)?
    var fetchMangaList: (() -> Void)?
    private var isLoading = false
    private let footerView = UIActivityIndicatorView(style: .white)
    private var collectionViewRefreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return control
    }()
    
    init(titles: [TitleModel], currentIndexPathItem: Int) {
        let myLayout = UICollectionViewFlowLayout()
        myLayout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
        let itemSpacing: CGFloat = 3
        let itemsInOneLine: CGFloat = 2
        let width = UIScreen.main.bounds.size.width - itemSpacing * CGFloat(itemsInOneLine - 1)
        myLayout.itemSize = CGSize(width: floor(width / itemsInOneLine) - 5, height: (width / itemsInOneLine) * 1.4)
        myLayout.minimumInteritemSpacing = 3
        myLayout.minimumLineSpacing = itemSpacing
        myLayout.scrollDirection = .vertical
        self.titles = titles
        self.currentIndexPathItem = currentIndexPathItem
        super.init(frame: .zero, collectionViewLayout: myLayout)
        delegate = self
        dataSource = self
        backgroundColor = .white
        register(TitileCollectionCell.self, forCellWithReuseIdentifier: TitileCollectionCell.resueID)
        register(CollectionViewFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Footer")
        (collectionViewLayout as? UICollectionViewFlowLayout)?.footerReferenceSize = CGSize(width: bounds.width, height: 50)
        refreshControl = collectionViewRefreshControl
        scrollToItem(at: IndexPath(item: currentIndexPathItem, section: 0), at: .top, animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func refresh() {
        fetchMangaList?()
    }
    
    deinit {
        print("deinit collection")
    }
    
}

extension MainCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitileCollectionCell.resueID, for: indexPath) as? TitileCollectionCell {
            currentIndexPathItem = indexPath.item
            cell.set(imageURL: titles[indexPath.item].cover, title: titles[indexPath.item].title)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath)
            footer.addSubview(footerView)
            footerView.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: 50)
            footerView.color = .black
            footerView.startAnimating()
            return footer
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

    }
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView
                        view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            if !isLoading {
                fetchNextTitles?()
            }
            isLoading.toggle()
        }
    }
}

extension MainCollectionView: MainParserViewControllerDelegate {
    func sendMangaData(_ vc: UIViewController, data: [TitleModel]) {
        titles = data
        isLoading = false
        DispatchQueue.main.async {
            self.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    
}

public class CollectionViewFooterView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
