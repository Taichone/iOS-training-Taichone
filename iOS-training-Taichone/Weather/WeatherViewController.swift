//
//  WeatherViewController.swift
//  iOS-training-Taichone
//
//  Created by 三木 太智 on 2024/09/18.
//

import UIKit
import YumemiWeather

final class WeatherViewController: UIViewController {
    @IBOutlet weak var weatherImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchWeatherForecast()
    }
    
    @IBAction func onTapReloadButton(_ sender: Any) {
        fetchWeatherForecast()
    }
    
    private func fetchWeatherForecast() {
        let weatherForecast = try? YumemiWeatherAPIClient.getWeatherForecast()
        print(weatherForecast ?? "nil")
    }
    
    private func setWeatherImage() {
        do {
            if let weather = try WeatherCondition(rawValue: YumemiWeather.fetchWeatherCondition(at: "")),
               let image = UIImage(named: weather.imageName) {
                weatherImageView.image = image.withRenderingMode(.alwaysTemplate)
                weatherImageView.tintColor = weather.tintColor
            }
        } catch {
            let alertMessage = weatherErrorAlertMessage(from: error)
            showWeatherErrorAlert(alertMessage: alertMessage)
        }
    }
    
    private func weatherErrorAlertMessage(from error: Error) -> String {
        let yumemiWeatherAPIError = error as? YumemiWeatherAPIError
        
        switch yumemiWeatherAPIError {
        case .apiInvalidParameterError, .invalidRequestError:
            return "要求にエラーが発生し、天気予報を取得できませんでした。"
        case .invalidResponseError:
            return "応答にエラーが発生し、天気予報を取得できませんでした。"
        case .apiUnknownError, nil:
            return "不明なエラーが発生し、天気予報を取得できませんでした。"
        }
    }
    
    private func showWeatherErrorAlert(alertMessage: String) {
        let alertController = UIAlertController(title: "天気の取得に失敗", message: alertMessage, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { _ in }
        let retryAction = UIAlertAction(title: "再取得", style: .default) { _ in
            self.setWeatherImage()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(retryAction)
        present(alertController, animated: true, completion: nil)
    }
}

private extension WeatherCondition {
    var imageName: String {
        rawValue
    }
    
    var tintColor: UIColor {
        switch self {
        case .cloudy:
                .gray
        case .rainy:
                .blue
        case .sunny:
                .red
        }
    }
}
