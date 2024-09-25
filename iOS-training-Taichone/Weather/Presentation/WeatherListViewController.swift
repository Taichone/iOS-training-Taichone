//
//  WeatherListViewController.swift
//  iOS-training-Taichone
//
//  Created by 三木 太智 on 2024/09/25.
//

import UIKit

final class WeatherListViewController: UIViewController {
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = .cyan // TODO: 削除
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let apiClient = YumemiWeatherAPIClient()
        let storyboard = UIStoryboard(name: "Weather", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController(creator: { coder in
            WeatherViewController(
                coder: coder,
                weatherForecastProvider: apiClient
            )
        }) else {
            fatalError("WeatherViewController could not be instantiated from Storyboard")
        }
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
