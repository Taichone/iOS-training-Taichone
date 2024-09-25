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
    
}
