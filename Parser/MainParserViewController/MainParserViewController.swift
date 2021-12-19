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

protocol MainParserViewControllerDelegate: AnyObject {
    func sendMangaData(_ vc: UIViewController, data: [TitleModel])
}

protocol MainParserDisplayLogic: AnyObject {
    func displayData(viewModel: MainParser.Model.ViewModel.ViewModelData)
}

class MainParserViewController: UIViewController, MainParserDisplayLogic {
    
    var interactor: MainParserBusinessLogic?
    var router: (NSObjectProtocol & MainParserRoutingLogic)?

    var titles = [TitleModel]()
    var currentIndex = 0
    weak var delegate: MainParserViewControllerDelegate?
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
        
        title = "Обновления"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "lineweight"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(changeList))
        
        setupIndicator()
        setup()
        self.interactor?.makeRequest(request: .getMangaList)
        view.backgroundColor = .white
    }

    func displayData(viewModel: MainParser.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayMangaData(let mangaData):
            print(mangaData)
            DispatchQueue.main.async {
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
                    self.indicator.stopAnimating()
                    self.isTitlesFetched = true
                    return
                }
                self.titles = mangaData
                self.delegate?.sendMangaData(self, data: self.titles)
            }
        }
    }
    
    private func setupTableView() {
        guard !isTableViewActive else { return }
        guard let tableView = tableView else { return }

        view.addSubview(tableView)
        delegate = tableView
        tableView.fetchNextTitles = { [weak self] in
            self?.interactor?.makeRequest(request: .getNextMangaList)
        }
        tableView.fetchMangaList = { [weak self] in
            self?.interactor?.makeRequest(request: .getMangaList)
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
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
        }
        isCollectionViewActive = true
        isTableEnabled = false
        collectionView.fetchNextTitles = { [weak self] in
            self?.interactor?.makeRequest(request: .getNextMangaList)
        }
        collectionView.fetchMangaList = { [weak self] in
            self?.interactor?.makeRequest(request: .getMangaList)
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
