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
    private(set) lazy var view: UIActivityIndicatorView = binded(UIActivityIndicatorView())
    private var viewModel: WeatherForcastFeedViewModelDelegate

    // MARK: - LifeCycle

    init(viewModel: WeatherForcastFeedViewModelDelegate) {
        self.viewModel = viewModel
        viewModel.viewDidLoad()
        viewModel.loadWeatherForcast(lat: 44.34, long: 10.99)
    }

    private func binded(_ view: UIActivityIndicatorView) -> UIActivityIndicatorView {
        viewModel.onLoadingStateChange = { [weak view] isLoading in
            isLoading ? view?.startAnimating() : view?.stopAnimating()
        }
        return view
    }
}
