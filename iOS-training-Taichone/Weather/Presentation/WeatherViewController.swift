//
//  WeatherViewController.swift
//  iOS-training-Taichone
//
//  Created by 三木 太智 on 2024/09/18.
//

import UIKit

final class WeatherViewController: UIViewController {
    @IBOutlet weak var weatherConditionImageView: UIImageView!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDidEnterForeground),
            name: .didEnterForeground,
            object: nil
        )
        
        fetchWeatherForecast()
    }
    
    @IBAction private func onTapReloadButton(_ sender: Any) {
        fetchWeatherForecast()
    }
    
    @IBAction private func onTapCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func handleDidEnterForeground() {
        fetchWeatherForecast()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .didEnterForeground, object: nil)
    }
}

extension WeatherViewController {
    private func fetchWeatherForecast() {
        do {
            let weatherForecast = try YumemiWeatherAPIClient.getWeatherForecast()
            setWeatherConditionImage(weatherCondition: weatherForecast.weatherCondition)
            if let minTemperatureLabel = minTemperatureLabel {
                minTemperatureLabel.text = String(weatherForecast.minTemperature)
            } else {
                print("minTempratureLabel が nil")
            }
            if let maxTemperatureLabel = maxTemperatureLabel {
                maxTemperatureLabel.text = String(weatherForecast.maxTemperature)
            } else {
                print("maxTempratureLabel が nil")
            }
        } catch {
            let alertMessage = weatherErrorAlertMessage(from: error)
            showWeatherErrorAlert(alertMessage: alertMessage)
        }
    }
    
    private func setWeatherConditionImage(weatherCondition: WeatherCondition) {
        guard let image = UIImage(named: weatherCondition.imageName) else { return }
        if let weatherConditionImageView = self.weatherConditionImageView {
            weatherConditionImageView.image = image.withRenderingMode(.alwaysTemplate)
            weatherConditionImageView.tintColor = weatherCondition.tintColor
        } else {
            print("weatherConditionImageView が nil")
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
        let alertController = UIAlertController(title: "天気予報の取得に失敗", message: alertMessage, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { _ in }
        let retryAction = UIAlertAction(title: "再取得", style: .default) { _ in
            self.fetchWeatherForecast()
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
