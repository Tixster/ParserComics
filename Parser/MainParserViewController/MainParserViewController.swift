//
//  MainParserViewController.swift
//  Parser
//
//  Created by Кирилл Тила on 05.09.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import SnapKit
import SwiftSoup
import Network
import Combine

protocol MainParserViewControllerDelegate: AnyObject {
    func sendMangaData(_ vc: UIViewController, data: [TitleModel])
}

protocol MainParserDisplayLogic: AnyObject {
    func displayData(viewModel: MainParser.Model.ViewModel.ViewModelData)
}

final class MainParserViewController: UIViewController, MainParserDisplayLogic {
    
    private var interactor: MainParserBusinessLogic?
    private var router: (NSObjectProtocol & MainParserRoutingLogic)?

    private var titles = [TitleModel]()
    private var currentIndex = 0
    public weak var delegate: MainParserViewControllerDelegate?
    private var store: Set<AnyCancellable> = []
    private var currentSortType: SortType {
        get {
            let key = UserDefaults.standard.string(forKey: "kCurrentSortType")
            return key != nil ? (.init(rawValue: key!) ?? .new) : .new
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "kCurrentSortType")
        }
    }
    private var collectionView: MainCollectionView? {
        didSet {
            if tableView == nil && collectionView == nil {
                tableView = MainListTableView(titles: titles, currentIndexPathRow: currentIndex, frame: .zero, style: .plain)
                setupTableView()
            }
        }
    }
    private var tableView: MainListTableView? {
        didSet {
            if collectionView == nil  && tableView == nil {
                collectionView = MainCollectionView(titles: titles, currentIndexPathItem: currentIndex)
                setupCollectionView()
            }
        }
    }
    @Published private var isMangaDataUpdate: Bool = false
    private let monitor = NWPathMonitor()
    private var indicator = UIActivityIndicatorView()
    private var isTableViewActive = false
    private var isCollectionViewActive = false
    private var isTitlesFetched = false
    private var isTableEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isTableEnabled")
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "isTableEnabled")
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    
    // MARK: - Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = MainParserInteractor()
        let presenter             = MainParserPresenter()
        let router                = MainParserRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: Routing
    
    func rout() {
        
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        
        title = currentSortType.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(changeList))
        let menu: UIMenu = .init(title: "Sort", image: nil, options: .displayInline, children: getMenuItems())
        navigationItem.leftBarButtonItem = .init(image: UIImage(systemName: "arrow.up.arrow.down.square"), menu: menu)
        setupIndicator()
        setup()
        Task { [weak self] in
            try? await self?.interactor?.makeRequest(request: currentSortType.requestType)
        }
        view.backgroundColor = .white
        $isMangaDataUpdate
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] isUpdate in
                if isUpdate {
                    collectionView?.isHidden = !isCollectionViewActive
                    tableView?.isHidden = !isTableViewActive
                    indicator.stopAnimating()
                } else {
                    collectionView?.isHidden = isCollectionViewActive
                    tableView?.isHidden = isTableViewActive
                    indicator.isHidden = false
                    indicator.startAnimating()
                }
                navigationItem.leftBarButtonItem?.isEnabled = isUpdate
                navigationItem.rightBarButtonItem?.isEnabled = isUpdate
                title = currentSortType.title
            }
            .store(in: &store)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }

    func displayData(viewModel: MainParser.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayMangaData(let mangaData):
            print(mangaData)
            DispatchQueue.main.async {
                self.isMangaDataUpdate = true
                if !self.isTitlesFetched {
                    self.titles = mangaData
                    if self.isTableEnabled {
                        self.tableView = MainListTableView(titles: self.titles, currentIndexPathRow: self.currentIndex, frame: .zero, style: .plain)
                        self.setupTableView()
                        self.tableView?.reloadData()
                    } else {
                        self.collectionView = MainCollectionView(titles: self.titles, currentIndexPathItem: self.currentIndex)
                        self.setupCollectionView()
                        self.collectionView?.reloadData()
                    }
                    self.isTitlesFetched = true
                    return
                }
                self.indicator.stopAnimating()
                self.titles = mangaData
                self.delegate?.sendMangaData(self, data: self.titles)
            }
        }
    }
    
    private func setupTableView() {
        guard !isTableViewActive else { return }
        guard let tableView = tableView else { return }
        navigationItem.rightBarButtonItem?.image = .init(systemName: "square.grid.2x2.fill")
        view.addSubview(tableView)
        delegate = tableView
        tableView.pushVc = { [unowned self] viewController in
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        tableView.fetchNextTitles = { [unowned self] in
            Task {
                try? await self.interactor?.makeRequest(request: .getNextMangaList)
            }
        }
        tableView.fetchMangaList = { [unowned self] in
            Task {
                try? await self.interactor?.makeRequest(request: currentSortType.requestType)
            }
        }
        tableView.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.snp.bottom)
        })
        isTableEnabled = true
        isTableViewActive = true
    }
    
    private func setupCollectionView() {
        guard !isCollectionViewActive else { return }
        guard let collectionView = collectionView else { return }
        view.addSubview(collectionView)
        delegate = collectionView
        navigationItem.rightBarButtonItem?.image = .init(systemName: "list.dash")
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
        }
        isCollectionViewActive = true
        isTableEnabled = false
        collectionView.pushVc = { [unowned self] viewController in
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        collectionView.fetchNextTitles = { [unowned self] in
            Task {
                try? await interactor?.makeRequest(request: .getNextMangaList)
            }
        }
        collectionView.fetchMangaList = { [unowned self] in
            Task {
                try? await interactor?.makeRequest(request: currentSortType.requestType)
            }
        }
    }
    
    private func setupIndicator() {
        view.addSubview(indicator)
        indicator.color = .black
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(30)
        }
        indicator.startAnimating()
    }
    
    @objc
    private func changeList() {
        if tableView != nil {
            self.currentIndex = tableView?.currentIndexPathRow ?? 0
            tableView?.removeFromSuperview()
            tableView = nil
            isTableViewActive = false
        } else {
            self.currentIndex = collectionView?.currentIndexPathItem ?? 0
            collectionView?.removeFromSuperview()
            collectionView = nil
            isCollectionViewActive = false
        }
    }
    
}

private extension MainParserViewController {
    
    func getMenuItems() -> [UIAction] {
        let sortNew: UIAction = .init(title: SortType.new.title) { action in
            Task { [weak self] in
                guard self?.currentSortType != .new else { return }
                self?.selectSort(.new)
                try? await self?.interactor?.makeRequest(request: .getNewMangaList)
                
            }
        }
        let sortPopular: UIAction = .init(title: SortType.popular.title) { action in
            Task { [weak self] in
                guard self?.currentSortType != .popular else { return }
                self?.selectSort(.popular)
                try? await self?.interactor?.makeRequest(request: .getPopularMangaList)
            }
        }
        let sortViews: UIAction = .init(title: SortType.views.title) { action in
            Task { [weak self] in
                guard self?.currentSortType != .views else { return }
                self?.selectSort(.views)
                try? await self?.interactor?.makeRequest(request: .getMostViewsMangaList)
            }
        }
        let sortDownload: UIAction = .init(title: SortType.download.title) { action in
            Task { [weak self] in
                guard self?.currentSortType != .download else { return }
                self?.selectSort(.download)
                try? await self?.interactor?.makeRequest(request: .getMostDownloadsMangaList)
            }
        }
        
        let menuItems: [UIAction] = [sortNew, sortPopular, sortViews, sortDownload]
        return menuItems
    }
    
    func selectSort(_ sort: SortType) {
        currentSortType = sort
        isMangaDataUpdate = false
        selectFirstIndex()
    }
    
    func selectFirstIndex() {
        collectionView?.selectItem(at: .init(item: 0, section: 0), animated: false, scrollPosition: .top)
        tableView?.selectRow(at: .init(row: 0, section: 0), animated: false, scrollPosition: .top)
    }
    
}
