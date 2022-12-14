//
//  RemoteMain.swift
//  iOSCleanArchitectureWeatherApp
//
//  Created by Perfect Aduh on 30/09/2022.
//

import Foundation

// MARK: - RemoteMain

 struct RemoteMain: Codable {
     let temp: Double?
     let tempMin: Double?
     let tempMax: Double?

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }

     init(
        temp: Double?,
        tempMin: Double?,
        tempMax: Double?
    ) {
        self.temp = temp
        self.tempMin = tempMin
        self.tempMax = tempMax
    }
}
