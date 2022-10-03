//
//  WeatherForcastViewController.swift
//  iOSCleanArchitectureWeatherApp
//
//  Created by Perfect Aduh on 03/10/2022.
//  Copyright © 2019 Perfect Aduh. All rights reserved.
//

import UIKit

// MARK: - WeatherForcastViewController

final class WeatherForcastViewController: UIViewController {
    private enum Constant {
        static let tableViewNumberOfSections = 0
        static let tableViewCellHeight: CGFloat = 60
        static let headerViewHeightConstraint: CGFloat = 340
    }

    private var activityIndicator: UIActivityIndicatorView? = {
        if #available(iOS 13.0, *) {
            return UIActivityIndicatorView(style: .medium)
        } else {
            return UIActivityIndicatorView(style: .gray)
        }
    }()

    var viewModel: CurrentDayWeatherForcastViewModel? {
        didSet {
            if let viewModel = viewModel {
                headerView.setup(with: CurrentDayWeatherForcastViewModel(currentDayWeatherForcast: viewModel.currentDayWeatherForcast))
                switch viewModel.weatherType {
                case .rain:
                    tableView.backgroundColor = UIColor.init(named: "rainy-colour")
                case .clear:
                    tableView.backgroundColor = UIColor.init(named: "sunny-colour")
                case .clouds:
                    tableView.backgroundColor = UIColor.init(named: "cloudy-colour")
                default: break
                }
            }
        }
    }
    private var headerView = WeatherForcastHeaderView()
    private var tableView: UITableView!
    private var refreshController: WeatherForcastRefreshViewController?
    private var tableModel = [WeatherForcastCellController]()
    private lazy var dataSource: UITableViewDiffableDataSource<Int, WeatherForcastCellController> = {
        .init(tableView: tableView) { [weak self] _, indexPath, _ in
            return self?.cellController(forRowAt: indexPath).view()
        }
    }()

    var onError: ((String) -> Void)?

    // MARK: - LifeCycle

    convenience init(refreshController: WeatherForcastRefreshViewController) {
        self.init()
        initializeView()
        addConstraints()
        self.refreshController = refreshController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = refreshController?.view
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constant.tableViewCellHeight
    }

    func set(_ newItems: [WeatherForcastCellController]) {
        tableModel = newItems
        var snapshot = NSDiffableDataSourceSnapshot<Int, WeatherForcastCellController>()
        snapshot.appendSections([Constant.tableViewNumberOfSections])
        snapshot.appendItems(newItems, toSection: Constant.tableViewNumberOfSections)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func cellController(forRowAt indexPath: IndexPath) -> WeatherForcastCellController {
        return tableModel[indexPath.row]
    }
}

private extension WeatherForcastViewController {
    func initializeView() {
        view.backgroundColor = .white
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false

        tableView = UITableView()
        tableView.register(WeatherForcastCell.self, forCellReuseIdentifier: "WeatherForcastCell")
        tableView.dataSource = dataSource
        tableView.rowHeight = Constant.tableViewCellHeight
        tableView.separatorColor = .clear
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            headerView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            headerView.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: 100
            ),
            headerView.heightAnchor.constraint(equalToConstant: Constant.headerViewHeightConstraint)
        ])

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            tableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            tableView.topAnchor.constraint(
                equalTo: headerView.bottomAnchor,
                constant: 9
            ),
            tableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            )
        ])
    }
}
