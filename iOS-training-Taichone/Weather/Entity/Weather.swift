//
//  Weather.swift
//  iOS-training-Taichone
//
//  Created by 三木 太智 on 2024/09/19.
//

import Foundation
import UIKit.UIColor

enum Weather: String {
    case cloudy
    case rainy
    case sunny
}

extension Weather {
    var imageName: String {
        switch self {
        case .cloudy, .rainy, .sunny: rawValue
        }
    }
    
    var tintColor: UIColor {
        switch self {
        case .cloudy: .gray
        case .rainy: .blue
        case .sunny: .red
        }
    }
}
