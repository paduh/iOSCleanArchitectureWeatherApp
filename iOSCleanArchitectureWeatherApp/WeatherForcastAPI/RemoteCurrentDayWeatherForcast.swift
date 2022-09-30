//
//  RemoteCurrentDayWeatherForcast.swift
//  iOSCleanArchitectureWeatherApp
//
//  Created by Perfect Aduh on 30/09/2022.
//

import Foundation

// MARK: - RemoteCurrentDayWeatherForcast

struct RemoteCurrentDayWeatherForcast: Codable {
     let id: Int?
     let weather: [RemoteWeather]?
     let main: RemoteMain?

     init(
        id: Int?,
        weather: [RemoteWeather]?,
        main: RemoteMain?
    ) {
        self.id = id
        self.weather = weather
        self.main = main
    }
}

// MARK: - RemoteWeather

 struct RemoteWeather: Codable {
     let id: Int?
     var main: String?

     init(
        id: Int?,
        main: String?
    ) {
        self.id = id
        self.main = main
    }
}
