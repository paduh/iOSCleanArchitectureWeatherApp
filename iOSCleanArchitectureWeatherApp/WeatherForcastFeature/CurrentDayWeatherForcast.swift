//
//  CurrentDayWeatherForcast.swift
//  iOSCleanArchitectureWeatherApp
//
//  Created by Perfect Aduh on 30/09/2022.
//

import Foundation

// MARK: - CurrentDayWeatherForcast

public struct CurrentDayWeatherForcast {
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
}

// MARK: - CurrentDayWeather

public struct CurrentDayWeather: Codable {
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
