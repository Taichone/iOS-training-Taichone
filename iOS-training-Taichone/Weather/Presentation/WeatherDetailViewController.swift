//
//  WeatherDetailViewController.swift
//  iOS-training-Taichone
//
//  Created by 三木 太智 on 2024/09/18.
//

import UIKit

final class WeatherDetailViewController: UIViewController {
    @IBOutlet weak var weatherConditionImageView: UIImageView!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    private let areaWeatherInfo: AreaWeatherInfo
    
    init?(coder: NSCoder, areaWeatherInfo: AreaWeatherInfo) {
        self.areaWeatherInfo = areaWeatherInfo
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = areaWeatherInfo.area
        navigationItem.largeTitleDisplayMode = .never
        setWeatherInfo(areaWeatherInfo.forecast)
    }
    
    deinit {
        print("WeatherDetailViewController - deinit")
    }
}

extension WeatherDetailViewController {
    private func setWeatherInfo(_ forecast: WeatherInfo) {
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
