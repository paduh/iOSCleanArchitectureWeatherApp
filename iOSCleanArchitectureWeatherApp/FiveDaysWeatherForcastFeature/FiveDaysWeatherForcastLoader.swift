//
//  FiveDaysWeatherForcastLoader.swift
//  iOSCleanArchitectureWeatherApp
//
//  Created by Perfect Aduh on 02/10/2022.
//

import Foundation

// MARK: - LoadCurrentDayWeatherForcastResult

public enum LoadFiveDaysWeatherForcastResult {
    case success([FiveDaysWeatherForcast])
    case failure(Error)
}

// MARK: - CurrentDayWeatherForcastLoader

public protocol FiveDaysWeatherForcastLoader {
    func load(completion: @escaping (LoadFiveDaysWeatherForcastResult) -> Void)
}
