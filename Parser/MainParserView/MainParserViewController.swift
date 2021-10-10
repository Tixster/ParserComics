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

protocol MainParserDisplayLogic: AnyObject {
    func displayData(viewModel: MainParser.Model.ViewModel.ViewModelData)
}

class MainParserViewController: UIViewController, MainParserDisplayLogic {
    
    var interactor: MainParserBusinessLogic?
    var router: (NSObjectProtocol & MainParserRoutingLogic)?
    var titles: [TitleModel]?
    private var indicator = UIActivityIndicatorView()
    private var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return control
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .white
        table.register(MangaTitleCell.self, forCellReuseIdentifier: MangaTitleCell.reuseID)
        table.register(LoadingCell.self, forCellReuseIdentifier: LoadingCell.reuseID)
        table.tableFooterView = UIView()
        return table
    }()
    
    private lazy var footerView = LoadingCell()
    private var isLoading = false
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
        interactor?.makeRequest(request: .getMangaList)
        view.backgroundColor = .white
    }
    
    
    
    func displayData(viewModel: MainParser.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayMangaData(let mangaData):
            print(mangaData)
            titles = mangaData
            DispatchQueue.main.async {
                self.setupTableView()
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                self.indicator.stopAnimating()
                self.isLoading = false
                self.footerView.stop()
            }
        case .displayFooterLoaerd:
            footerView.start()
        }
    }
    
    private func setupTableView() {
        guard !isTableViewActive else { return }
        view.addSubview(tableView)
        tableView.addSubview(refreshControl)
        tableView.snp.makeConstraints({
            $0.edges.equalToSuperview()
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
    
    @objc
    private func refresh() {
        interactor?.makeRequest(request: .getMangaList)
    }
    
}

extension MainParserViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
        if let titles = titles {
            return titles.count
        } else{
            return 0
        }
        case 1: return 1
        default: return 0
    }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: MangaTitleCell.reuseID, for: indexPath) as! MangaTitleCell
                return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadingCell.reuseID, for: indexPath) as! LoadingCell
            cell.start()
            return cell
        default:
            return UITableViewCell()
        }

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if let cell = cell as? MangaTitleCell {
                if let titles = titles {
                    let title = titles[indexPath.row]
                    cell.configure(mangaModel: title)
                    cell.setNeedsLayout()
                    cell.layoutIfNeeded()
                    cell.separatorInset = .zero
                }
            }
        default:
            DispatchQueue.main.async {
                self.interactor?.makeRequest(request: .getNextMangaList)
            }
            isLoading.toggle()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 140
        }
        
        return 50
    }

}
