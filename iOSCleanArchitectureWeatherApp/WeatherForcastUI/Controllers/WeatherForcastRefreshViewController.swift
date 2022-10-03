//
//  WeatherForcastRefreshViewController.swift
//  iOSCleanArchitectureWeatherApp
//
//   Created by Perfect Aduh on 03/10/2022.
//  Copyright © 2022 Perfect Aduh. All rights reserved.
//

import UIKit

// MARK: - WeatherForcastRefreshViewController

final class WeatherForcastRefreshViewController: NSObject {
    private(set) lazy var view: UIActivityIndicatorView = binded(activityIndicator)
    private var viewModel: WeatherForcastFeedViewModelDelegate

    private var activityIndicator: UIActivityIndicatorView = {
        if #available(iOS 13.0, *) {
            return UIActivityIndicatorView(style: .medium)
        } else {
            return UIActivityIndicatorView(style: .gray)
        }
    }()

    // MARK: - LifeCycle

    init(
        viewModel: WeatherForcastFeedViewModelDelegate) {
        self.viewModel = viewModel
        viewModel.viewDidLoad()
    }

    func loadWeatherForcast(lat: Double, long: Double) {
        viewModel.loadWeatherForcast(lat: lat, long: long)
    }

    private func binded(_ view: UIActivityIndicatorView) -> UIActivityIndicatorView {
        viewModel.onLoadingStateChange = { [weak view] isLoading in
            isLoading ? view?.startAnimating() : view?.stopAnimating()
        }
        return view
    }
}
