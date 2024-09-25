//
//  YumemiWeatherAPIClient.swift
//  iOS-training-Taichone
//
//  Created by 三木 太智 on 2024/09/19.
//

import YumemiWeather
import Foundation

final class YumemiWeatherAPIClient {}

extension YumemiWeatherAPIClient: WeatherForecastProvider {
    func fetchWeatherForecast() async throws -> WeatherForecast {
        let request = GetWeatherForecastRequest(
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
            // 時間のかかる処理を async に対応させる
            let responseJSON = try await withCheckedThrowingContinuation { continuation in
                do {
                    let responseJSON = try YumemiWeather.syncFetchWeather(requestJSON)
                    continuation.resume(returning: responseJSON)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
            
            let responseData = Data(responseJSON.utf8)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601
            let response = try decoder.decode(GetWeatherForecastResponse.self, from: responseData)
            
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
    
    private struct GetWeatherForecastRequest: Encodable {
        let area: String
        let date: Date
    }
    
    private struct GetWeatherForecastResponse: Decodable {
        let weatherCondition: String
        let maxTemperature: Int
        let minTemperature: Int
        let date: Date
        
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
