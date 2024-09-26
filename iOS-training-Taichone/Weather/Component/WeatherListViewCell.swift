//
//  WeatherListViewCell.swift
//  iOS-training-Taichone
//
//  Created by 三木 太智 on 2024/09/26.
//

import UIKit

class WeatherListViewCell: UITableViewCell {
    @IBOutlet weak var areaNameLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var weatherConditionImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func apply(itemModel: WeatherListItemModel) {
        areaNameLabel.text = itemModel.areaWeatherInfo.area
        minTemperatureLabel.text = "\(itemModel.areaWeatherInfo.forecast.minTemperature)℃"
        maxTemperatureLabel.text = "\(itemModel.areaWeatherInfo.forecast.maxTemperature)℃"
        setWeatherConditionImage(weatherCondition: itemModel.areaWeatherInfo.forecast.weatherCondition)
    }
    
    private func setWeatherConditionImage(weatherCondition: WeatherCondition) {
        guard let image = UIImage(named: weatherCondition.imageName) else { return }
        weatherConditionImageView.image = image.withRenderingMode(.alwaysTemplate)
        weatherConditionImageView.tintColor = weatherCondition.tintColor
    }
}

extension WeatherListViewCell {
    static let reuseIdentifier = "weatherListViewCell"
}
