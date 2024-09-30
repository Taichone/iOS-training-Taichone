//
//  WeatherListViewCell.swift
//  iOS-training-Taichone
//
//  Created by 三木 太智 on 2024/09/26.
//

import UIKit

final class WeatherListViewCell: UITableViewCell {
    @IBOutlet weak var areaNameLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var weatherConditionImageView: UIImageView!

    func apply(itemModel: WeatherListItemModel) {
        areaNameLabel.text = itemModel.areaWeatherInfo.area
        minTemperatureLabel.text = "\(itemModel.areaWeatherInfo.info.minTemperature)℃"
        maxTemperatureLabel.text = "\(itemModel.areaWeatherInfo.info.maxTemperature)℃"
        setWeatherConditionImage(weatherCondition: itemModel.areaWeatherInfo.info.weatherCondition)
    }
    
    private func setWeatherConditionImage(weatherCondition: WeatherCondition) {
        weatherConditionImageView.image = weatherCondition.image.withRenderingMode(.alwaysTemplate)
        weatherConditionImageView.tintColor = weatherCondition.tintColor
    }
}

extension WeatherListViewCell {
    static let reuseIdentifier = "weatherListViewCell"
}
