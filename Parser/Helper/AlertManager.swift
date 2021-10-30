//
//  AlertManager.swift
//  Parser
//
//  Created by Кирилл Тила on 28.10.2021.
//

import Foundation
import UIKit

class AlertManager {
    
    static func noInternetAlert() {
        let alertVC = UIAlertController(title: "Нет сети",
                                        message: "Пожалуйста, проверте подключение к сети.",
                                        preferredStyle: .alert)
        let actionCanel = UIAlertAction(title: "ОК", style: .cancel, handler: nil)
        alertVC.addAction(actionCanel)
        alertVC.show()
    }
    
}

public extension UIAlertController {
    func show() {
        UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: true, completion: nil)
    }
}
