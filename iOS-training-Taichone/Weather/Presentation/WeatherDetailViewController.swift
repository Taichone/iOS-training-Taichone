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
        setWeatherInfo(areaWeatherInfo.info)
    }
    
    deinit {
        print("WeatherDetailViewController - deinit")
    }
}

extension WeatherDetailViewController {
    private func setWeatherInfo(_ info: WeatherInfo) {
        setWeatherConditionImage(weatherCondition: info.weatherCondition)
        minTemperatureLabel.text = String(info.minTemperature)
        maxTemperatureLabel.text = String(info.maxTemperature)
    }
    
    private func setWeatherConditionImage(weatherCondition: WeatherCondition) {
        weatherConditionImageView.image = weatherCondition.image.withRenderingMode(.alwaysTemplate)
        weatherConditionImageView.tintColor = weatherCondition.tintColor
    }
}
