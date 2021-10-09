//
//  AppDelegate.swift
//  Parser
//
//  Created by Кирилл Тила on 05.09.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let mainVc = MainParserViewController()
        let navVC = UINavigationController(rootViewController: mainVc)
        window = UIWindow(frame: UIScreen.main.bounds)
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        } 
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        
        return true
    }


}

