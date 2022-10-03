//
//  RemoteFiveDaysWeatherForcast.swift
//  iOSCleanArchitectureWeatherApp
//
//  Created by Perfect Aduh on 02/10/2022.
//

import Foundation

// MARK: - Remote Five Days List

 struct RemoteFiveDaysWeatherForcast: Codable {
     let main: RemoteMain?
     let weather: [RemoteFiveDaysWeather]?
     let dtTxt: String?
     let dt: Int?

    enum CodingKeys: String, CodingKey {
        case main
        case weather
        case dt
        case dtTxt = "dt_txt"
    }

     init(
        main: RemoteMain?,
        weather: [RemoteFiveDaysWeather]?,
        dtTxt: String?,
        dt: Int?
    ) {
        self.main = main
        self.weather = weather
        self.dtTxt = dtTxt
        self.dt = dt
    }
}

// MARK: - Remote Five Days Weather

struct RemoteFiveDaysWeather: Codable {
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
