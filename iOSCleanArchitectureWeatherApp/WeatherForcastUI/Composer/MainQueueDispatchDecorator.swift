//
//  MainQueueDispatchDecorator.swift
//  iOSCleanArchitectureWeatherApp
//
//  Created by Perfect Aduh on 03/10/2022.
//  Copyright © 2022 Perfect Aduh. All rights reserved.
//

import Foundation

// MARK: - MainQueueDispatchDecorator

final class MainQueueDispatchDecorator<T> {
    private let decoratee: T

    init(decoratee: T) {
        self.decoratee = decoratee
    }

    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }

        completion()
    }
}

// MARK: - CurrentDayWeatherForcastLoader

extension MainQueueDispatchDecorator: CurrentDayWeatherForcastLoader where T == CurrentDayWeatherForcastLoader {
    func load(lat: Double, long: Double, completion: @escaping (LoadCurrentDayWeatherForcastResult) -> Void) {
        return decoratee.load(lat: lat, long: long) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

// MARK: - FiveDaysWeatherForcastLoader

extension MainQueueDispatchDecorator: FiveDaysWeatherForcastLoader where T == FiveDaysWeatherForcastLoader {
    func load(lat: Double, long: Double, completion: @escaping (LoadFiveDaysWeatherForcastResult) -> Void) {
        return decoratee.load(lat: lat, long: long) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}
