//
//  WeatherInfo.swift
//  iOS-training-Taichone
//
//  Created by 三木 太智 on 2024/09/19.
//

import Foundation

struct WeatherInfo: Hashable {
    let weatherCondition: WeatherCondition
    let maxTemperature: Int
    let minTemperature: Int
    let date: Date
}
