//
//  AppCoordinator.swift
//  FlickrKit-iOS-App
//
//  Created by Perfect Aduh on 29/08/2022.
//  Copyright © 2022 Perfect Aduh. All rights reserved.
//

import UIKit

// MARK: - AppCoordinator

final class AppCoordinator: CoordinatorProtocol {

    var rootNavigationController: UINavigationController!
    let window: UIWindow?
    var childCoordinator: CoordinatorProtocol?

    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()

    private lazy var currentDayWeatherForcastLoader: CurrentDayWeatherForcastLoader = {
        let loader = RemoteCurrentDayWeatherForcastUseCase(url: URL(string: "https://api.openweathermap.org/data/2.5/weather")!, client: httpClient)
        return MainQueueDispatchDecorator(decoratee: loader)
    }()

    private lazy var fiveDaysWeatherForcastLoader: FiveDaysWeatherForcastLoader = {
        let loader = RemoteFiveDaysWeatherForcastUseCase(url: URL(string: "https://api.openweathermap.org/data/2.5/forecast")!, client: httpClient)
        return MainQueueDispatchDecorator(decoratee: loader)
    }()

    init(window: UIWindow?) {
        self.window = window
    }

    func start() {
        let feedViewController = FeedUIComposer.feedComposeWith(currentWeatherLoader: currentDayWeatherForcastLoader, fiveDaysWeatherLoader: fiveDaysWeatherForcastLoader)

        feedViewController.onError = { error in
            self.showAlert(with: error)
        }

        rootNavigationController = UINavigationController(rootViewController: feedViewController)
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()
    }

    func end() {}

    private func showAlert(with error: String) {
        let alertController = UIAlertController(title: "Text.error.rawValue", message: error, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Text.ok.rawValue", style: .default)
        alertController.addAction(okAction)
        window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
