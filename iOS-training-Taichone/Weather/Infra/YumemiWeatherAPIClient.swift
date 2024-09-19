//
//  YumemiWeatherAPIClient.swift
//  iOS-training-Taichone
//
//  Created by 三木 太智 on 2024/09/19.
//

import YumemiWeather
import Foundation

final class YumemiWeatherAPIClient {
    static func getWeatherForecast() throws -> WeatherForecast {
        let request = Request(
            area: Area.tokyo.rawValue, // NOTE: 現時点では指定されていないためハードコード
            date: Date()
        )
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        guard let requestData = try? encoder.encode(request),
              let requestJSON = String(data: requestData, encoding: .utf8) else {
            throw YumemiWeatherAPIError.invalidRequestError
        }
        
        do {
            let responseJSON = try YumemiWeather.fetchWeather(requestJSON)
            let responseData = Data(responseJSON.utf8)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let response = try decoder.decode(Response.self, from: responseData)
            
            return try response.convertToWeatherForecast()
        } catch {
            if let yumemiWeatherError = error as? YumemiWeatherError {
                switch yumemiWeatherError {
                case .invalidParameterError:
                    throw YumemiWeatherAPIError.apiInvalidParameterError
                case .unknownError:
                    throw YumemiWeatherAPIError.apiUnknownError
                }
            } else {
                throw YumemiWeatherAPIError.invalidResponseError
            }
        }
    }
}

extension YumemiWeatherAPIClient {
    private struct Request: Encodable {
        let area: String
        let date: Date
    }
    
    private struct Response: Codable, Equatable {
        let weatherCondition: String
        let maxTemperature: Int
        let minTemperature: Int
        let date: Date
        
        private enum CodingKeys: String, CodingKey {
            case weatherCondition = "weather_condition"
            case maxTemperature = "max_temperature"
            case minTemperature = "min_temperature"
            case date
        }
        
        func convertToWeatherForecast() throws -> WeatherForecast {
            guard let weatherCondition = WeatherCondition(rawValue: weatherCondition) else {
                throw YumemiWeatherAPIError.invalidResponseError
            }
            
            return .init(
                weatherCondition: weatherCondition,
                maxTemperature: maxTemperature,
                minTemperature: minTemperature,
                date: date
            )
        }
    }
}
