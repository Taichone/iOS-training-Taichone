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
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    private let weatherForecastProvider: WeatherForecastProvider
    
    init?(coder: NSCoder, weatherForecastProvider: WeatherForecastProvider) {
        self.weatherForecastProvider = weatherForecastProvider
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
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
        print("WeatherViewController - deinit")
    }
}

extension WeatherViewController {
    func fetchWeatherForecast(completion: (() -> Void)? = nil) {
        reloadButton.isEnabled = false
        loadingIndicator.startAnimating()
        weatherForecastProvider.fetchWeatherForecast(completion: completion)
    }
    
    private func setWeatherForecast(_ forecast: WeatherForecast) {
        setWeatherConditionImage(weatherCondition: forecast.weatherCondition)
        minTemperatureLabel.text = String(forecast.minTemperature)
        maxTemperatureLabel.text = String(forecast.maxTemperature)
    }
    
    private func setWeatherConditionImage(weatherCondition: WeatherCondition) {
        guard let image = UIImage(named: weatherCondition.imageName) else { return }
        weatherConditionImageView.image = image.withRenderingMode(.alwaysTemplate)
        weatherConditionImageView.tintColor = weatherCondition.tintColor
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

extension WeatherViewController: YumemiWeatherAPIClientDelegate {
    func didGetWeatherForecast(_ forecast: WeatherForecast, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.setWeatherForecast(forecast)
            self.loadingIndicator.stopAnimating()
            self.reloadButton.isEnabled = true
            
            if let completion = completion {
                completion()
            }
        }
    }
    
    func didGetWeatherForecastWithError(_ error: any Error, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let alertMessage = self.weatherErrorAlertMessage(from: error)
            self.showWeatherErrorAlert(alertMessage: alertMessage)
            self.loadingIndicator.stopAnimating()
            self.reloadButton.isEnabled = true
            
            if let completion = completion {
                completion()
            }
        }
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

protocol WeatherForecastProvider {
    func fetchWeatherForecast(completion: (() -> Void)?)
}
