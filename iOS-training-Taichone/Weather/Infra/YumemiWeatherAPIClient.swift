//
//  YumemiWeatherAPIClient.swift
//  iOS-training-Taichone
//
//  Created by 三木 太智 on 2024/09/19.
//

import YumemiWeather
import Foundation

// TODO: ViewConrtoller が YumemiWeather に依存しないよう設計
// - ここで YumemiWeatherError はハンドリングし、新しいエラーを定義して投げる

final class YumemiWeatherAPIClient {
    static func getWeatherForecast() throws -> WeatherForecast {
        let request = Request(
            area: Area.tokyo.rawValue, // NOTE: 現時点では指定されていないためハードコード
            date: Date()
        )
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let requestData = try encoder.encode(request)
        guard let requestJSON = String(data: requestData, encoding: .utf8) else {
            throw YumemiWeatherError.invalidParameterError // TODO: - 定義した error にする
        }
        
        let responseJSON = try YumemiWeather.fetchWeather(requestJSON)
        
        let responseData = Data(responseJSON.utf8)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let response = try decoder.decode(Response.self, from: responseData)
        
        return try response.convertToWeatherForecast()
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
            guard let weather = WeatherCondition(rawValue: weatherCondition) else {
                throw YumemiWeatherError.invalidParameterError // TODO: - 定義した error にする
            }
            
            return .init(
                weather: weather,
                maxTemperature: maxTemperature,
                minTemperature: minTemperature,
                date: date
            )
        }
    }
}
