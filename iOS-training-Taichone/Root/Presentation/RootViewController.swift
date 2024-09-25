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
        view.backgroundColor = .gray // NOTE: Session6 の遷移の視認性のために指定
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let apiClient = YumemiWeatherAPIClient()
        let storyboard = UIStoryboard(name: "WeatherList", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController(creator: { coder in
            WeatherListViewController(coder: coder, weatherForecastProvider: apiClient)
        }) else {
            fatalError("WeatherListViewController could not be instantiated from Storyboard")
        }
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
    }
}
