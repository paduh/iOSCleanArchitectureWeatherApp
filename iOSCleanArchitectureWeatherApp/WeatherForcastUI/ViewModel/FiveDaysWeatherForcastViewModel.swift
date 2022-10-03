//
//  FiveDaysWeatherForcastViewModel.swift
//  iOSCleanArchitectureWeatherApp
//
//  Created by Perfect Aduh on 03/10/2022.
//

import Foundation

// MARK: - CurrentDayWeatherForcastViewModelDelegate

protocol FiveDaysWeatherForcastViewModelDelegate: AnyObject {
    var forcastDayTitle: String? { get set }
    var temperatureTitle: String? { get set }
    var weatherType: WeatherType? { get set }
}

// MARK: - FeedImageViewModel

final class FiveDaysWeatherForcastViewModel: FiveDaysWeatherForcastViewModelDelegate {
    var forcastDayTitle: String? = ""
    var temperatureTitle: String?  = ""
    var weatherType: WeatherType?

    private let fiveDaysWeatherForcast: FiveDaysWeatherForcast
    private let dateFormatter: DateFormatter

    init(
        fiveDaysWeatherForcast: FiveDaysWeatherForcast,
        dateFormatter: DateFormatter = DateFormatter()) {
        self.fiveDaysWeatherForcast = fiveDaysWeatherForcast
        self.dateFormatter = dateFormatter

        handleSetup()
    }

    private func handleSetup() {
        weatherType =  fiveDaysWeatherForcast.weatherType
        temperatureTitle = fiveDaysWeatherForcast.currentTemp

        let dateTxt = fiveDaysWeatherForcast.dtTxt ?? ""
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let formatedDate = dateFormatter.date(from: dateTxt) {
            let dayOfWeekDateFormatter = DateFormatter()
            dayOfWeekDateFormatter.setLocalizedDateFormatFromTemplate("EEEE")

            forcastDayTitle = dayOfWeekDateFormatter.string(from: formatedDate)
        }
    }
}
