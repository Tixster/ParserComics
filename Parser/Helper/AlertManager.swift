//
//  AlertManager.swift
//  Parser
//
//  Created by Кирилл Тила on 28.10.2021.
//

import Foundation
import UIKit

class AlertManager {
    
    static func errorAlert(with error: Error, okHandler: ((UIAlertAction) -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = createAlert(title: "Error",
                                    message: error.localizedDescription,
                                    okButton: "Обновить",
                                    okHandler: okHandler)
            alert.show()
        }
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
        okHandler: ((UIAlertAction) -> Void)? = nil
    ) -> UIAlertController {
        let alertVC = UIAlertController(title: title,
                                        message: message,
                                        preferredStyle: .alert)
        let actionCanel = UIAlertAction(title: okButton ?? "OK", style: .cancel, handler: okHandler)
        alertVC.addAction(actionCanel)
        return alertVC
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
