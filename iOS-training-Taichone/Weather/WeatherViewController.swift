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
        setWeatherImage()
    }
    
    @IBAction func onTapReloadButton(_ sender: Any) {
        setWeatherImageS3()
    }
    
    private func setWeatherImage() {
        guard let weather = Weather(rawValue: YumemiWeather.fetchWeatherCondition()),
              let image = UIImage(named: weather.imageName) else { return }
        
        weatherImageView.image = image.withRenderingMode(.alwaysTemplate)
        weatherImageView.tintColor = weather.tintColor
    }
}

private extension Weather {
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
    
    // TODO: rename（今は S2 の変更を rebase した際の conflict 対策）
    private func setWeatherImageS3() {
        do {
            if let weather = try Weather(rawValue: YumemiWeather.fetchWeatherCondition(at: "")),
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
        if let yumemiWeatherError = error as? YumemiWeatherError {
            switch yumemiWeatherError {
            case .invalidParameterError:
                "内部で無効なパラメータが渡されてエラーが発生し、天気を取得できませんでした。"
            case .unknownError:
                "不明なエラーが発生し、天気を取得できませんでした。"
            }
        } else {
            "不明なエラーが発生し、天気を取得できませんでした。"
        }
    }
    
    private func showWeatherErrorAlert(alertMessage: String) {
        let alertController = UIAlertController(title: "天気の取得に失敗", message: alertMessage, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { _ in }
        let retryAction = UIAlertAction(title: "再取得", style: .default) { _ in
            self.setWeatherImageS3()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(retryAction)
        present(alertController, animated: true, completion: nil)
    }
}
