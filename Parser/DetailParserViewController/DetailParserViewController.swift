//
//  DetailParserViewController.swift
//  Parser
//
//  Created by Кирилл Тила on 19.12.2021.
//

import UIKit

protocol DetailParserDisplayLogic: AnyObject {
    func displayData(viewModel: DetailParser.Model.ViewModel.ViewModelData)
}

class DetailParserViewController: UIViewController, DetailParserDisplayLogic {
    
    var interactor: DetailParserInteractorLogic?
    var router: (DetailParserRouterLogic & NSObjectProtocol)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

    }
    
    func displayData(viewModel: DetailParser.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayDetailTitle(let data):
            return
        }
    }
    
    private func setup() {
        let viewController = self
        let interactor = DetailParserInteractor()
        let presenter = DetailParserPresenter()
        let router = DetailPareserRouter()
        viewController.router = router
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
    
    
}
