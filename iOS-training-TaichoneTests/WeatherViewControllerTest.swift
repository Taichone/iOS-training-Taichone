//
//  WeatherViewControllerTest.swift
//  iOS-training-TaichoneTests
//
//  Created by 三木 太智 on 2024/09/20.
//

import XCTest
import UIKit
@testable import iOS_training_Taichone

final class WeatherViewControllerTest: XCTestCase {
    private var vc: WeatherViewController!
    private var weatherForecastProvider = WeatherForecastProviderMock()
    
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Weather", bundle: nil)
        vc = storyboard.instantiateViewController(withIdentifier: "WeatherViewController") as? WeatherViewController
        vc.weatherForecastProvider = weatherForecastProvider
        
        vc.loadViewIfNeeded()
    }

    @MainActor
    func test_天気予報がsunnyなら画面に晴れ画像が表示されること() async throws {
        weatherForecastProvider.setWeatherCondition(.sunny)
        
        vc.fetchWeatherForecast() // Act
        
        guard let imageViewImage = vc.weatherConditionImageView.image?.pngData(),
              let sunnyImage = UIImage(named: "sunny")?.pngData() else {
            XCTFail("ImageView または Assets の　UIImage が取り出せない")
            return
        }
        
        XCTAssertEqual(imageViewImage, sunnyImage)
        XCTAssertEqual(vc.weatherConditionImageView.tintColor, UIColor.red)
    }
    
    @MainActor
    func test_天気予報がcloudyなら画面に曇り画像が表示されること() async throws {
        weatherForecastProvider.setWeatherCondition(.cloudy)
        
        vc.fetchWeatherForecast() // Act

        guard let imageViewImage = vc.weatherConditionImageView.image?.pngData(),
              let cloudyImage = UIImage(named: "cloudy")?.pngData() else {
            XCTFail("ImageView または Assets の　UIImage が取り出せない")
            return
        }
        XCTAssertEqual(imageViewImage, cloudyImage)
        XCTAssertEqual(vc.weatherConditionImageView.tintColor, UIColor.gray)
    }
    
    @MainActor
    func test_天気予報がrainyなら画面に雨画像が表示されること() async throws {
        weatherForecastProvider.setWeatherCondition(.rainy)
        
        vc.fetchWeatherForecast() // Act

        guard let imageViewImage = vc.weatherConditionImageView.image?.pngData(),
              let rainyImage = UIImage(named: "rainy")?.pngData() else {
            XCTFail("ImageView または Assets の　UIImage が取り出せない")
            return
        }
        XCTAssertEqual(imageViewImage, rainyImage)
        XCTAssertEqual(vc.weatherConditionImageView.tintColor, UIColor.blue)
    }
}

extension WeatherViewControllerTest {
    private final class WeatherForecastProviderMock: WeatherForecastProvider {
        private(set) var weatherForecast: WeatherForecast?
        
        func setWeatherForecast(_ weatherForecast: WeatherForecast) {
            self.weatherForecast = weatherForecast
        }
        
        func setWeatherCondition(_ weatherCondition: WeatherCondition) {
            self.weatherForecast = .init(
                weatherCondition: weatherCondition,
                maxTemperature: 0,
                minTemperature: 0,
                date: Date()
            )
        }
        
        // MARK: - WeatherForecastProvider Protocol
        
        func getWeatherForecast() throws -> iOS_training_Taichone.WeatherForecast {
            if let weatherForecast = weatherForecast {
                return weatherForecast
            } else {
                throw NSError()
            }
        }
    }
}
