//
//  Area.swift
//  iOS-training-Taichone
//
//  Created by 三木 太智 on 2024/09/19.
//

import Foundation

enum Area: String, Decodable {
    case sapporo = "Sapporo"
    case sendai = "Sendai"
    case niigata = "Niigata"
    case kanazawa = "Kanazawa"
    case tokyo = "Tokyo"
    case nagoya = "Nagoya"
    case osaka = "Osaka"
    case hiroshima = "Hiroshima"
    case kochi = "Kochi"
    case fukuoka = "Fukuoka"
    case kagoshima = "Kagoshima"
    case naha = "Naha"
    
    var localized: String {
        switch self {
        case .sapporo:
            return String(localized: "sapporo")
        case .sendai:
            return String(localized: "sendai")
        case .niigata:
            return String(localized: "niigata")
        case .kanazawa:
            return String(localized: "kanazawa")
        case .tokyo:
            return String(localized: "tokyo")
        case .nagoya:
            return String(localized: "nagoya")
        case .osaka:
            return String(localized: "osaka")
        case .hiroshima:
            return String(localized: "hiroshima")
        case .kochi:
            return String(localized: "kochi")
        case .fukuoka:
            return String(localized: "fukuoka")
        case .kagoshima:
            return String(localized: "kagoshima")
        case .naha:
            return String(localized: "naha")
        }
    }
}
