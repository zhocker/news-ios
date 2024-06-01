//
//  LaunchScreenViewController.swift
//  news-ios
//
//  Created by User on 30/5/2567 BE.
//

import UIKit
import Core
import Lottie

class LaunchScreenViewController: UIViewController {
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search news"
        return searchBar
    }()
    
    private let loadingView: LottieAnimationView = {
        let loadingView = LottieAnimationView(asset: "loading")
        loadingView.animationSpeed = 4
        loadingView.loopMode = .loop
        return loadingView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLottieView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.25) { [weak self] in
            guard let self = self else { return }
            self.dimissLottieView()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.routeToMain()
            }
        }
    }
    func setupLottieView() {
        self.view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(300)
        }
        loadingView.play()
    }
    
    private func dimissLottieView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.loadingView.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            self.loadingView.alpha = 0
        }) { _ in
            self.loadingView.removeFromSuperview()
        }
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

