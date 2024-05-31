//
//  LaunchScreenViewController.swift
//  news-ios
//
//  Created by User on 30/5/2567 BE.
//

import UIKit
import Core

class LaunchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.routeToMain()
    }

    func routeToMain() {
        
        guard
            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        else {
            return
        }

        let mainViewController = NewsListViewController()

        let navigationController = UINavigationController()
        navigationController.viewControllers = [mainViewController]
        
        sceneDelegate.window?.rootViewController = navigationController
        sceneDelegate.window?.makeKeyAndVisible()
        sceneDelegate.window?.animateTransition()
        
    }


}

