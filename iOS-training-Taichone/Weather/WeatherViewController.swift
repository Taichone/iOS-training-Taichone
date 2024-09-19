//
//  WeatherViewController.swift
//  iOS-training-Taichone
//
//  Created by 三木 太智 on 2024/09/18.
//

import UIKit
import YumemiWeather

final class WeatherViewController: UIViewController {
    @IBOutlet weak var weatherImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setWeatherImage()
    }
    
    func setWeatherImage() {
        let weathertypeName = YumemiWeather.fetchWeatherCondition()
        // TODO: ここで Weather に直せば、weatherImage() はいらない
        
        if let image = weatherImage(typeName: weathertypeName) {
            weatherImageView.image = image.withRenderingMode(.alwaysTemplate)
            weatherImageView.tintColor = .red
        }
    }
    
    private func weatherImage(typeName: String) -> UIImage? {
        switch typeName {
        case "sunny", "cloudy", "rainy": UIImage(named: typeName)
        default: nil
        }
    }
}
