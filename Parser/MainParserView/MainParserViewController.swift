//
//  MainParserViewController.swift
//  Parser
//
//  Created by Кирилл Тила on 05.09.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import SnapKit

protocol MainParserDisplayLogic: AnyObject {
  func displayData(viewModel: MainParser.Model.ViewModel.ViewModelData)
}

class MainParserViewController: UIViewController, MainParserDisplayLogic {

  var interactor: MainParserBusinessLogic?
  var router: (NSObjectProtocol & MainParserRoutingLogic)?
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.tableFooterView = UIView()
        return table
    }()
  
  // MARK: Setup
  
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
    navigationController?.navigationBar.isHidden = true
    setuoTableView()
    setup()

  }
  
  func displayData(viewModel: MainParser.Model.ViewModel.ViewModelData) {

  }
    
    private func setuoTableView() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
  
}


extension MainParserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Index: \(indexPath.row)"
        cell.separatorInset = .zero
        return cell
    }
    
    
}
