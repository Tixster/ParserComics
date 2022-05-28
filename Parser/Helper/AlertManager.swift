//
//  AlertManager.swift
//  Parser
//
//  Created by Кирилл Тила on 28.10.2021.
//

import Foundation
import UIKit

class AlertManager {
    
    static func errorAlert(
        with error: Error,
        okHandler: ((UIAlertAction) -> Void)? = nil,
        secondButton: UIAlertAction? = nil
    ) {
        DispatchQueue.main.async {
            let alert = createAlert(title: "Error",
                                    message: error.localizedDescription,
                                    okButton: "Обновить",
                                    okHandler: okHandler,
                                    secondButton: secondButton)
            alert.show()
        }
    }
    
    static func editLinkAlert(updateHandler: @escaping () -> Void) {
        let alert: UIAlertController = .init(title: "Редактирование URL",
                                             message: "Введите новый URL",
                                             preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = "Введите URL"
            field.text = Constants.SiteLinks.siteMainPageURL
        }
        
        let action: UIAlertAction = .init(title: "Готово", style: .default) { _ in
            guard let fileds = alert.textFields else { return }
            guard let text = fileds[0].text else { return }
            print("🟡 ulr from textfield", text)
            Constants.SiteLinks.siteMainPageURL = text
            updateHandler()
        }
        
        let cancelAction: UIAlertAction = .init(title: "Отмена", style: .cancel)
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        alert.show()
    }
    
    static func noInternetAlert() {
        DispatchQueue.main.async {
            let alert = createAlert(title: "Нет сети".localized(),
                                    message: "Пожалуйста, проверте подключение к сети.".localized())
            alert.show()
        }
    }
    
    private static func createAlert(
        title: String,
        message: String,
        okButton: String? = nil,
        okHandler: ((UIAlertAction) -> Void)? = nil,
        secondButton: UIAlertAction? = nil
    ) -> UIAlertController {
        let alertVC = UIAlertController(title: title,
                                        message: message,
                                        preferredStyle: .alert)
        let actionCanel = UIAlertAction(title: okButton ?? "OK", style: .cancel, handler: okHandler)
        alertVC.addAction(actionCanel)
        if let secondButton = secondButton {
            alertVC.addAction(secondButton)
        }
        return alertVC
    }
    
}

extension AlertManager {
    
    static func addChangeMangaLinkAction(_ handler: @escaping () -> Void) -> UIAlertAction {
        let action: UIAlertAction = .init(title: "Сменить ссылку", style: .default) { _ in
            handler()
        }
        return action
    }
    
}

public extension UIAlertController {
    func show() {
        UIApplication.topViewController()?.present(self, animated: true)
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.mainKeyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension UIApplication {
    var mainKeyWindow: UIWindow? {
        get {
            if #available(iOS 13, *) {
                return connectedScenes
                    .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                    .first { $0.isKeyWindow }
            } else {
                return keyWindow
            }
        }
    }
}
