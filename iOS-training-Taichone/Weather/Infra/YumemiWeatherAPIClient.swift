//
//  YumemiWeatherAPIClient.swift
//  iOS-training-Taichone
//
//  Created by 三木 太智 on 2024/09/19.
//

import YumemiWeather
import Foundation

final class YumemiWeatherAPIClient {}

extension YumemiWeatherAPIClient: WeatherProvider {
    func fetchWeatherInfo() async throws -> WeatherInfo {
        let request = GetWeatherInfoRequest(
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
            let responseJSON = try await YumemiWeather.asyncFetchWeather(requestJSON)
            
            let responseData = Data(responseJSON.utf8)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601
            let response = try decoder.decode(GetWeatherInfoResponse.self, from: responseData)
            
            return try response.convertToWeatherInfo()
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
    
    func fetchAreaWeatherInfoList() async throws -> [AreaWeatherInfo] {
        // NOTE: 現時点では指定されていないためハードコード
        let request = FetchWeatherListRequest(
            areas: [
                Area.sapporo.rawValue,
                Area.sendai.rawValue,
                Area.tokyo.rawValue,
                Area.nagoya.rawValue,
                Area.osaka.rawValue,
                Area.fukuoka.rawValue
            ],
            date: Date()
        )
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        guard let requestData = try? encoder.encode(request),
              let requestJSON = String(data: requestData, encoding: .utf8) else {
            throw YumemiWeatherAPIError.invalidRequestError
        }
        
        do {
            let responseJSON = try await YumemiWeather.asyncFetchWeatherList(requestJSON)
            
            let responseData = Data(responseJSON.utf8)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601
            let response = try decoder.decode([FetchWeatherListResponse].self, from: responseData)
            
            return try response.map {
                try $0.convertToAreaWeatherInfo()
            }
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
    
    private struct FetchWeatherListRequest: Encodable {
        let areas: [String]
        let date: Date
    }
    
    struct FetchWeatherListResponse: Decodable {
        let area: String
        let info: Info

        func convertToAreaWeatherInfo() throws -> AreaWeatherInfo {
            .init(
                area: area,
                forecast: try info.convertToWeatherInfo()
            )
        }

        struct Info: Decodable {
            let weatherCondition: String
            let maxTemperature: Int
            let minTemperature: Int
            let date: Date

            func convertToWeatherInfo() throws -> WeatherInfo {
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
    
    private struct GetWeatherInfoRequest: Encodable {
        let area: String
        let date: Date
    }
    
    private struct GetWeatherInfoResponse: Decodable {
        let weatherCondition: String
        let maxTemperature: Int
        let minTemperature: Int
        let date: Date
        
        func convertToWeatherInfo() throws -> WeatherInfo {
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
