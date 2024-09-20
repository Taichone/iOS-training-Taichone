//
//  YumemiWeatherAPIError.swift
//  iOS-training-Taichone
//
//  Created by 三木 太智 on 2024/09/20.
//

import Foundation

enum YumemiWeatherAPIError: Error {
    case apiUnknownError
    case apiInvalidParameterError
    case invalidRequestError
    case invalidResponseError
}
