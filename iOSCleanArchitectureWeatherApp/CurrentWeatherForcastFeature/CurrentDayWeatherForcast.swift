//
//  CurrentDayWeatherForcast.swift
//  iOSCleanArchitectureWeatherApp
//
//  Created by Perfect Aduh on 30/09/2022.
//

import Foundation

// MARK: - CurrentDayWeatherForcast

public struct CurrentDayWeatherForcast: Equatable {
    public let id: Int?
    public let weather: [CurrentDayWeather]?
    public let main: Main?

    public init(
        id: Int?,
        weather: [CurrentDayWeather]?,
        main: Main?
    ) {
        self.weather = weather
        self.main = main
        self.id = id
    }

    var maxTemp: String? {
        main?.tempMax?.celciusTemp
    }

    var minTemp: String? {
        main?.tempMin?.celciusTemp
    }

    var currentTemp: String? {
        main?.temp?.celciusTemp
    }

    var weatherType: WeatherType? {
        if let main = weather?.first?.main, let weatherType = WeatherType(rawValue: main) {
            return weatherType
        } else {
            return nil
        }
    }
}

// MARK: - CurrentDayWeather

public struct CurrentDayWeather: Equatable {
    public let id: Int?
    public var main: String?

    public init(
        id: Int?,
        main: String?
    ) {
        self.id = id
        self.main = main
    }
}
