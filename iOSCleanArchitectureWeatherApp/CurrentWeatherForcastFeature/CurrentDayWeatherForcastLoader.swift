//
//  CurrentDayWeatherForcastLoader.swift
//  iOSCleanArchitectureMoviesApp
//
//  Created by Perfect Aduh on 30/09/2022.
//

import Foundation

// MARK: - LoadCurrentDayWeatherForcastResult

public enum LoadCurrentDayWeatherForcastResult {
    case success(CurrentDayWeatherForcast)
    case failure(Error)
}

// MARK: - CurrentDayWeatherForcastLoader

public protocol CurrentDayWeatherForcastLoader {
    func load(lat: Double, long: Double, completion: @escaping (LoadCurrentDayWeatherForcastResult) -> Void)
}
