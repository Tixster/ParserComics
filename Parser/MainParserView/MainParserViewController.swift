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
import Kingfisher
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
    weak var delegateTableView: MainParserViewControllerDelegate?
    private let monitor = NWPathMonitor()
    private var indicator = UIActivityIndicatorView()
    private lazy var tableView = MainListTableView(frame: .zero, style: .plain)
    private var isTableViewActive = false
    
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
    
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        
        title = "Обновления"
        
        setupIndicator()
        setup()
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [unowned self] path in
            if path.status == .satisfied {
                self.interactor?.makeRequest(request: .getMangaList)
            } else {
                DispatchQueue.main.async {
                    AlertManager.noInternetAlert()
                }
            }
        }
        view.backgroundColor = .white
    }

    func displayData(viewModel: MainParser.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayMangaData(let mangaData):
            print(mangaData)
            DispatchQueue.main.async {
                self.setupTableView()
                self.delegateTableView?.sendMangaData(self, data: mangaData)
                self.indicator.stopAnimating()
            }
        }
    }
    
    private func setupTableView() {
        guard !isTableViewActive else { return }
        view.addSubview(tableView)
        delegateTableView = tableView
        tableView.fetchNextTitles = { [weak self] in
            self?.interactor?.makeRequest(request: .getNextMangaList)
        }
        tableView.fetchMangaList = { [weak self] in
            self?.interactor?.makeRequest(request: .getMangaList)
        }
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.snp.makeConstraints({
            $0.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        })
        isTableViewActive = true
        
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
    
}
