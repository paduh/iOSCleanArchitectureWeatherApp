//
//  WeatherType.swift
//  iOSCleanArchitectureWeatherApp
//
//  Created by Perfect Aduh on 30/09/2022.
//

import Foundation

public enum WeatherType: String, Codable {
    case rain = "Rain"
    case clear = "Clear"
    case clouds = "Clouds"

    var title: String {
        switch self {
        case .rain: return "RAINY"
        case .clear: return "SUNNY"
        case .clouds: return "CLOUDY"
        }
    }
}
