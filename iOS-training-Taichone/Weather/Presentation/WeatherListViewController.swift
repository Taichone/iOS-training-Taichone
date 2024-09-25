//
//  WeatherListViewController.swift
//  iOS-training-Taichone
//
//  Created by 三木 太智 on 2024/09/25.
//

import UIKit
import Combine

protocol WeatherForecastProvider {
    func fetchWeatherForecast() async throws -> WeatherForecast // TODO: - 削除
    func fetchWeatherAreaWeatherForecastList() async throws -> [AreaWeatherForecast]
}

struct WeatherListSectionModel: Hashable {
    let title: String
}

struct WeatherListItemModel: Hashable {
    let areaWeatherForecast: AreaWeatherForecast
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(areaWeatherForecast)
    }
    
    static func == (lhs: WeatherListItemModel, rhs: WeatherListItemModel) -> Bool {
        lhs.areaWeatherForecast == rhs.areaWeatherForecast
    }
}

final class WeatherListViewController: UIViewController {
    private typealias SnapShot = NSDiffableDataSourceSnapshot<WeatherListSectionModel, WeatherListItemModel>
    private typealias DataSource = UITableViewDiffableDataSource<WeatherListSectionModel, WeatherListItemModel>
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private let weatherForecastProvider: WeatherForecastProvider
    private var dataSource: DataSource!
    
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
        
        Task {
            await fetchAreaWeatherForecastList()
            
        }
    }
    
    func setTableView() {
//        dataSource = .init(
//            tableView: tableView,
//            cellProvider: { tableView, indexPath, item in
//                let cell = 
//            }
//        )
    }
    
    @IBAction private func onTapReloadButton(_ sender: Any) {
        Task {
            await fetchAreaWeatherForecastList()
        }
    }
    
    @IBAction private func onTapCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func handleDidEnterForeground() {
        Task {
            await fetchAreaWeatherForecastList()
        }
    }
    
    deinit {
        print("WeatherViewController - deinit")
    }
}

extension WeatherListViewController {
    func fetchAreaWeatherForecastList() async {
        reloadButton.isEnabled = false
        loadingIndicator.startAnimating()
        
        do {
            // TODO: API からリストでもらい、反映する
            let areaWeatherForecastList = try await weatherForecastProvider.fetchWeatherAreaWeatherForecastList()
            print(areaWeatherForecastList)
        } catch {
            let alertMessage = self.weatherErrorAlertMessage(from: error)
            self.showWeatherErrorAlert(alertMessage: alertMessage)
        }
        
        self.loadingIndicator.stopAnimating()
        self.reloadButton.isEnabled = true
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
            Task {
                await self.fetchAreaWeatherForecastList()
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(retryAction)
        present(alertController, animated: true, completion: nil)
    }
}
