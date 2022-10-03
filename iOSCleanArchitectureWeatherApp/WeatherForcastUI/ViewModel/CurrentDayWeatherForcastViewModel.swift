//
//  CurrentDayWeatherForcastViewModel.swift
//  FlickrKit-iOS-App
//
//  Created by Perfect Aduh on 25/08/2022.
//  Copyright © 2022 Perfect Aduh. All rights reserved.
//

import Foundation

// MARK: - CurrentDayWeatherForcastViewModelDelegate

protocol CurrentDayWeatherForcastViewModelDelegate: AnyObject {
    var forcastDateTitle: String? { get set }
    var temperatureTitle: String? { get set }
    var minTemperatureTitle: String? { get set }
    var maxTemperatureTitle: String? { get set }
    var weatherType: WeatherType? { get set }
    var weatherTitle: String? { get set }
}

// MARK: - FeedImageViewModel

final class CurrentDayWeatherForcastViewModel: CurrentDayWeatherForcastViewModelDelegate {
    var forcastDateTitle: String? = ""
    var temperatureTitle: String?  = ""
    var minTemperatureTitle: String? = ""
    var maxTemperatureTitle: String?  = ""
    var weatherType: WeatherType?
    var weatherTitle: String?  = ""

    let currentDayWeatherForcast: CurrentDayWeatherForcast
    private let dateFormatter: DateFormatter

    init(
        currentDayWeatherForcast: CurrentDayWeatherForcast,
        dateFormatter: DateFormatter = DateFormatter()) {
        self.currentDayWeatherForcast = currentDayWeatherForcast
        self.dateFormatter = dateFormatter

        handleSetup()
    }

    private func handleSetup() {
        weatherType =  currentDayWeatherForcast.weatherType

        minTemperatureTitle = currentDayWeatherForcast.minTemp
        maxTemperatureTitle = currentDayWeatherForcast.maxTemp
        temperatureTitle = currentDayWeatherForcast.currentTemp
        weatherTitle = weatherType?.title
    }
}
