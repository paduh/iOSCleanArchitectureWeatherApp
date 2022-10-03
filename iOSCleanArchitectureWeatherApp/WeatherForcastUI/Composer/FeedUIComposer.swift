//
//  FeedUIComposer.swift
//  iOSCleanArchitectureWeatherApp
//
//  Created by Perfect Aduh on 24/08/2022.
//  Copyright © 2022 Perfect Aduh. All rights reserved.
//

import Foundation
import UIKit

// MARK: - FeedUIComposer

final class FeedUIComposer {
    private enum Constant {
        static let initialPageNumber = 1
        static let itemPosition = 0
        static let eachDayOccurenceInArray = 8 // because there's array with 40 objects, for 5 days forcast, 5*8=40
    }

    private init() {}

    static func feedComposeWith(
        currentWeatherLoader: CurrentDayWeatherForcastLoader,
        fiveDaysWeatherLoader: FiveDaysWeatherForcastLoader
    ) -> WeatherForcastViewController {
        let feedViewModel = WeatherForcastFeedViewModel(
            currentDayWeatherForcastLoader: currentWeatherLoader,
            fiveDaysWeatherForcastLoader: fiveDaysWeatherLoader)

        let refreshController = WeatherForcastRefreshViewController(viewModel: feedViewModel)
        let weatherForcastViewController = WeatherForcastViewController(refreshController: refreshController)

        feedViewModel.onCurrentDayWeatherForcastLoad = { [weak weatherForcastViewController] currentDayWeatherForcast in
            let currentDayWeatherForcastViewModel = CurrentDayWeatherForcastViewModel(
                currentDayWeatherForcast: currentDayWeatherForcast)
            weatherForcastViewController?.viewModel = currentDayWeatherForcastViewModel
        }

        feedViewModel.onFiveDaysWeatherForcastLoad = adaptFeedToCellControllers(
            forwardingTo: weatherForcastViewController,
            feedViewModel: feedViewModel,
            currentDayWeatherForcastLoader: currentWeatherLoader,
            fiveDaysWeatherForcastLoader: fiveDaysWeatherLoader)
        feedViewModel.onError = { [weak weatherForcastViewController] error in
            weatherForcastViewController?.onError?(error)
        }

        return weatherForcastViewController
    }

    private static func adaptFeedToCellControllers(
        forwardingTo controller: WeatherForcastViewController,
        feedViewModel: WeatherForcastFeedViewModel,
        currentDayWeatherForcastLoader: CurrentDayWeatherForcastLoader,
        fiveDaysWeatherForcastLoader: FiveDaysWeatherForcastLoader
    ) -> ([FiveDaysWeatherForcast]) -> Void {
        return { [weak controller] weatherForcast in
            var fiveDaysWeatherForcasts = [FiveDaysWeatherForcast]()

            var itemPosition = Constant.itemPosition
            while itemPosition < weatherForcast.count {
                fiveDaysWeatherForcasts.append(weatherForcast[itemPosition])
                itemPosition += Constant.eachDayOccurenceInArray
            }

            let tableModel = fiveDaysWeatherForcasts.map { fiveDaysWeatherForcast in
                WeatherForcastCellController(
                    viewModel: FiveDaysWeatherForcastViewModel(fiveDaysWeatherForcast: fiveDaysWeatherForcast))
            }

            controller?.set(tableModel)
        }
    }
}
