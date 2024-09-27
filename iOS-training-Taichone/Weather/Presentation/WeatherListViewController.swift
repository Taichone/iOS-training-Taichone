//
//  WeatherListViewController.swift
//  iOS-training-Taichone
//
//  Created by 三木 太智 on 2024/09/25.
//

import UIKit
import Combine

protocol WeatherProvider {
    func fetchWeatherInfo() async throws -> WeatherInfo // TODO: - 削除
    func fetchAreaWeatherInfoList() async throws -> [AreaWeatherInfo]
}

struct WeatherListSectionModel: Hashable {
    let title: String
}

struct WeatherListItemModel: Hashable {
    let areaWeatherInfo: AreaWeatherInfo
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(areaWeatherInfo)
    }
    
    static func == (lhs: WeatherListItemModel, rhs: WeatherListItemModel) -> Bool {
        lhs.areaWeatherInfo == rhs.areaWeatherInfo
    }
}

final class WeatherListViewController: UIViewController {
    private typealias SnapShot = NSDiffableDataSourceSnapshot<WeatherListSectionModel, WeatherListItemModel>
    private typealias DataSource = UITableViewDiffableDataSource<WeatherListSectionModel, WeatherListItemModel>
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private let weatherProvider: WeatherProvider
    private var dataSource: DataSource!
    
    init?(coder: NSCoder, weatherProvider: WeatherProvider) {
        self.weatherProvider = weatherProvider
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
        
        setTableView()
        fetchList()
    }
    
    private func setTableView() {
        dataSource = .init(
            tableView: tableView,
            cellProvider: { tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: WeatherListViewCell.reuseIdentifier,
                    for: indexPath
                ) as! WeatherListViewCell
                
                cell.apply(itemModel: item)
                cell.separatorInset = .zero
                return cell
            }
        )
        
        tableView.register(
            UINib(nibName: "WeatherListViewCell", bundle: nil),
            forCellReuseIdentifier: WeatherListViewCell.reuseIdentifier
        )
        tableView.dataSource = dataSource
        tableView.delegate = self
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(fetchList), for: .valueChanged)
    }
    
    @IBAction func onTapReloadButton(_ sender: Any) {
        fetchList()
    }
    
    @IBAction private func onTapCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func handleDidEnterForeground() {
        fetchList()
    }
    
    deinit {
        print("WeatherDetailViewController - deinit")
    }
}

extension WeatherListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }

        let storyboard = UIStoryboard(name: "WeatherDetail", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController(creator: { coder in
            WeatherDetailViewController(coder: coder, areaWeatherInfo: item.areaWeatherInfo)
        }) else {
            fatalError("WeatherDetailViewController could not be instantiated from Storyboard")
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension WeatherListViewController {
    @objc func fetchList() {
        Task {
            await fetchAreaWeatherInfoList()
        }
    }
    
    func fetchAreaWeatherInfoList() async {
        reloadButton.isEnabled = false
        loadingIndicator.startAnimating()
        
        do {
            let areaWeatherInfoList = try await weatherProvider.fetchAreaWeatherInfoList()
            bind(areaWeatherInfos: areaWeatherInfoList)
        } catch {
            self.showWeatherErrorAlert(from: error)
        }
        
        self.tableView.refreshControl?.endRefreshing()
        self.loadingIndicator.stopAnimating()
        self.reloadButton.isEnabled = true
    }
    
    private func bind(areaWeatherInfos: [AreaWeatherInfo]) {
        var snapShot = SnapShot()
        
        // NOTE: 現時点では複数 section は考慮していない
        let section = WeatherListSectionModel(title: "地域別")
        let items: [WeatherListItemModel] = areaWeatherInfos.compactMap {
            .init(areaWeatherInfo: $0)
        }
        
        snapShot.appendSections([section])
        snapShot.appendItems(items, toSection: section)
        dataSource.apply(snapShot)
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
    
    private func showWeatherErrorAlert(from error: Error) {
        let alertMessage = weatherErrorAlertMessage(from: error)
        let alertController = UIAlertController(title: "天気予報の取得に失敗", message: alertMessage, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { _ in }
        let retryAction = UIAlertAction(title: "再取得", style: .default) { _ in
            Task {
                await self.fetchAreaWeatherInfoList()
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(retryAction)
        present(alertController, animated: true, completion: nil)
    }
}
