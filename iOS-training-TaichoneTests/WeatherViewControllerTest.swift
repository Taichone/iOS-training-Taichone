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
        guard let viewController = storyboard.instantiateInitialViewController(creator: { coder in
            WeatherViewController(
                coder: coder,
                weatherForecastProvider: self.weatherForecastProvider,
                schedulerObject: ImmediateScheduler()
            )
        }) else {
            fatalError("WeatherViewController could not be instantiated from Storyboard")
        }
        vc = viewController
        vc.loadViewIfNeeded()
    }

    @MainActor
    func test_天気予報がsunnyなら画面に晴れ画像が表示されること() {
        weatherForecastProvider.setWeatherCondition(.sunny)
        
        vc.fetchWeatherForecast()

        guard
            let imageViewImage = vc.weatherConditionImageView.image?.pngData(),
            let sunnyImage = UIImage(named: "sunny")?.pngData()
        else {
            XCTFail("ImageView または Assets の　UIImage が取り出せない")
            return
        }
        XCTAssertEqual(imageViewImage, sunnyImage)
        XCTAssertEqual(vc.weatherConditionImageView.tintColor, UIColor.red)
    }
    
    @MainActor
    func test_天気予報がcloudyなら画面に曇り画像が表示されること() {
        weatherForecastProvider.setWeatherCondition(.cloudy)
        
        vc.fetchWeatherForecast()

        guard
            let imageViewImage = vc.weatherConditionImageView.image?.pngData(),
            let cloudyImage = UIImage(named: "cloudy")?.pngData()
        else {
            XCTFail("ImageView または Assets の UIImage が取り出せない")
            return
        }
        XCTAssertEqual(imageViewImage, cloudyImage)
        XCTAssertEqual(vc.weatherConditionImageView.tintColor, UIColor.gray)
    }
    
    @MainActor
    func test_天気予報がrainyなら画面に雨画像が表示されること() {
        weatherForecastProvider.setWeatherCondition(.rainy)
        
        vc.fetchWeatherForecast()

        guard
            let imageViewImage = vc.weatherConditionImageView.image?.pngData(),
            let rainyImage = UIImage(named: "rainy")?.pngData()
        else {
            XCTFail("ImageView または Assets の　UIImage が取り出せない")
            return
        }
        XCTAssertEqual(imageViewImage, rainyImage)
        XCTAssertEqual(vc.weatherConditionImageView.tintColor, UIColor.blue)
    }
    
    @MainActor
    func test_天気予報の最高気温がUILabelに反映されること() {
        let expectedMaxTemperature = 100
        weatherForecastProvider.setWeatherForecast(
            .init(
                weatherCondition: .cloudy,
                maxTemperature: expectedMaxTemperature,
                minTemperature: 0,
                date: Date()
            ))
        
        vc.fetchWeatherForecast()
            
        guard let labelTextValue = Int(vc.maxTemperatureLabel.text ?? "") else {
            XCTFail("maxTemperatureLabel.text が nil または Int に変換できない")
            return
        }
        XCTAssertEqual(labelTextValue, expectedMaxTemperature)
    }
    
    @MainActor
    func test_天気予報の最低気温がUILabelに反映されること() {
        let expectedMinTemperature = -100
        weatherForecastProvider.setWeatherForecast(
            .init(
                weatherCondition: .cloudy,
                maxTemperature: 0,
                minTemperature: expectedMinTemperature,
                date: Date()
            ))

        vc.fetchWeatherForecast()

        guard let labelTextValue = Int(vc.minTemperatureLabel.text ?? "") else {
            XCTFail("minTemperatureLabel.text が nil または Int に変換できない")
            return
        }
        XCTAssertEqual(labelTextValue, expectedMinTemperature)
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
        func fetchWeatherForecast(completion: @escaping ((Result<WeatherForecast, Error>) -> Void)) {
            do {
                let forecast = try getWeatherForecast()
                completion(.success(forecast))
            } catch {
                completion(.failure(error))
            }
        }
        
        private func getWeatherForecast() throws -> iOS_training_Taichone.WeatherForecast {
            if let weatherForecast = weatherForecast {
                return weatherForecast
            } else {
                throw NSError()
            }
        }
    }
}

class ImmediateScheduler: SchedulerObject {
    func runOnMainThread(_ block: @escaping () -> Void) {
        block()
    }
}
