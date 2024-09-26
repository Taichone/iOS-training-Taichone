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
    private func viewController(areaWeatherInfo: AreaWeatherInfo) -> WeatherViewController {
        let storyboard = UIStoryboard(name: "Weather", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController(creator: { coder in
            WeatherViewController(coder: coder, areaWeatherInfo: areaWeatherInfo)
        }) else {
            fatalError("WeatherViewController could not be instantiated from Storyboard")
        }
        viewController.loadViewIfNeeded()
        
        return viewController
    }

    @MainActor
    func test_天気予報がsunnyなら画面に晴れ画像が表示されること() async {
        let condition = WeatherCondition.sunny
        
        let vc = viewController(areaWeatherInfo: .init(
            area: "",
            forecast: .init(
                weatherCondition: condition,
                maxTemperature: 0,
                minTemperature: 0,
                date: Date())
            )
        )

        guard let imageViewImage = vc.weatherConditionImageView.image?.pngData(),
              let sunnyImage = UIImage(named: "sunny")?.pngData()
        else {
            XCTFail("ImageView または Assets の　UIImage が取り出せない")
            return
        }
        XCTAssertEqual(imageViewImage, sunnyImage)
        XCTAssertEqual(vc.weatherConditionImageView.tintColor, UIColor.red)
    }
    
    @MainActor
    func test_天気予報がcloudyなら画面に曇り画像が表示されること() async {
        let condition = WeatherCondition.cloudy
        
        let vc = viewController(areaWeatherInfo: .init(
            area: "",
            forecast: .init(
                weatherCondition: condition,
                maxTemperature: 0,
                minTemperature: 0,
                date: Date())
            )
        )

        guard let imageViewImage = vc.weatherConditionImageView.image?.pngData(),
              let cloudyImage = UIImage(named: "cloudy")?.pngData()
        else {
            XCTFail("ImageView または Assets の UIImage が取り出せない")
            return
        }
        XCTAssertEqual(imageViewImage, cloudyImage)
        XCTAssertEqual(vc.weatherConditionImageView.tintColor, UIColor.gray)
    }
    
    @MainActor
    func test_天気予報がrainyなら画面に雨画像が表示されること() async {
        let condition = WeatherCondition.rainy
        
        let vc = viewController(areaWeatherInfo: .init(
            area: "",
            forecast: .init(
                weatherCondition: condition,
                maxTemperature: 0,
                minTemperature: 0,
                date: Date())
            )
        )
        
        guard let imageViewImage = vc.weatherConditionImageView.image?.pngData(),
              let rainyImage = UIImage(named: "rainy")?.pngData()
        else {
            XCTFail("ImageView または Assets の　UIImage が取り出せない")
            return
        }
        XCTAssertEqual(imageViewImage, rainyImage)
        XCTAssertEqual(vc.weatherConditionImageView.tintColor, UIColor.blue)
    }
    
    @MainActor
    func test_天気予報の最高気温がUILabelに反映されること() async {
        let expectedMaxTemperature = 100
        
        let vc = viewController(areaWeatherInfo: .init(
            area: "",
            forecast: .init(
                weatherCondition: .sunny,
                maxTemperature: expectedMaxTemperature,
                minTemperature: 0,
                date: Date())
            )
        )

        guard let labelTextValue = Int(vc.maxTemperatureLabel.text ?? "") else {
            XCTFail("maxTemperatureLabel.text が nil または Int に変換できない")
            return
        }
        XCTAssertEqual(labelTextValue, expectedMaxTemperature)
    }
    
    @MainActor
    func test_天気予報の最低気温がUILabelに反映されること() async {
        let expectedMinTemperature = -100

        let vc = viewController(areaWeatherInfo: .init(
            area: "",
            forecast: .init(
                weatherCondition: .sunny,
                maxTemperature: 0,
                minTemperature: expectedMinTemperature,
                date: Date())
            )
        )

        guard let labelTextValue = Int(vc.minTemperatureLabel.text ?? "") else {
            XCTFail("minTemperatureLabel.text が nil または Int に変換できない")
            return
        }
        XCTAssertEqual(labelTextValue, expectedMinTemperature)
    }
}
