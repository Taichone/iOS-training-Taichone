//
//  WeatherViewController.swift
//  iOS-training-Taichone
//
//  Created by 三木 太智 on 2024/09/18.
//

import UIKit

final class WeatherViewController: UIViewController {
    @IBOutlet weak var weatherConditionImageView: UIImageView!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    private let areaWeatherForecast: AreaWeatherForecast
    
    init?(coder: NSCoder, areaWeatherForecast: AreaWeatherForecast) {
        self.areaWeatherForecast = areaWeatherForecast
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.title = areaWeatherForecast.area
        setWeatherForecast(areaWeatherForecast.forecast)
    }
    
    deinit {
        print("WeatherViewController - deinit")
    }
}

extension WeatherViewController {
    private func setWeatherForecast(_ forecast: WeatherForecast) {
        setWeatherConditionImage(weatherCondition: forecast.weatherCondition)
        minTemperatureLabel.text = String(forecast.minTemperature)
        maxTemperatureLabel.text = String(forecast.maxTemperature)
    }
    
    private func setWeatherConditionImage(weatherCondition: WeatherCondition) {
        guard let image = UIImage(named: weatherCondition.imageName) else { return }
        weatherConditionImageView.image = image.withRenderingMode(.alwaysTemplate)
        weatherConditionImageView.tintColor = weatherCondition.tintColor
    }
}
