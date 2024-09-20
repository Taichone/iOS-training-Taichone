//
//  RootViewController.swift
//  iOS-training-Taichone
//
//  Created by 三木 太智 on 2024/09/20.
//

import UIKit

final class RootViewController: UIViewController {
    override func viewDidLoad(){
        super.viewDidLoad()
        print("viewDidLoad")
        view.backgroundColor = .gray // NOTE: Session6 の遷移の視認性のために指定
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("viewWillAppear")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("viewWillLayoutSubviews")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("viewDidLayoutSubviews")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("viewDidAppear")
        
        let storyboard = UIStoryboard(name: "Weather", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(
            withIdentifier: "WeatherViewController"
        ) as? WeatherViewController else {
            fatalError("WeatherViewController could not be instantiated from Storyboard")
        }

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        print("viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        print("viewDidDisappear")
    }
}
