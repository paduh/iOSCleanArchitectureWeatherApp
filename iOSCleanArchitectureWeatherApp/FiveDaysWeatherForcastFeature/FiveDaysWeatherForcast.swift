//
//  FiveDaysWeatherForcast.swift
//  iOSCleanArchitectureWeatherApp
//
//  Created by Perfect Aduh on 02/10/2022.
//

import Foundation

// MARK: Five Days Weather Forcast

public struct FiveDaysWeatherForcast: Equatable {
    public let main: Main?
    public let weather: [FiveDaysWeather]?
    public let dtTxt: String?

    private enum CodingKeys: String, CodingKey {
        case main
        case weather
        case dtTxt = "dt_txt"
    }

    public init(
        main: Main?,
        weather: [FiveDaysWeather]?,
        dtTxt: String?
    ) {
        self.main = main
        self.weather = weather
        self.dtTxt = dtTxt
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

// MARK: Five Days Weather

public struct FiveDaysWeather: Equatable {
    public let id: Int?
    public let main: String?

    public init(
        id: Int?,
        main: String?
    ) {
        self.id = id
        self.main = main
    }
}
