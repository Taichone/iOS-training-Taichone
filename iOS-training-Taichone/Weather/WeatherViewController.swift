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
    
    @IBAction func onTapReloadButton(_ sender: Any) {
        setWeatherImage()
    }
    
    private func setWeatherImage() {
        if let weather = Weather(rawValue: YumemiWeather.fetchWeatherCondition()),
           let image = UIImage(named: weather.imageName) {
            weatherImageView.image = image.withRenderingMode(.alwaysTemplate)
            weatherImageView.tintColor = weather.tintColor
        }
    }
}
