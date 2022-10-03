//
//  WeatherForcastViewModel.swift
//  iOSCleanArchitectureWeatherApp
//
//  Created by Perfect Aduh on 02/10/2022.
//  Copyright © 2022 Perfect Aduh. All rights reserved.
//

import Foundation

// MARK: - WeatherForcastViewModelDelegate

protocol WeatherForcastViewModelDelegate: AnyObject {
    var onLoadingStateChange: ((Bool) -> Void)? { get set }
    var onCurrentDayWeatherForcastLoad: ((CurrentDayWeatherForcast) -> Void)? { get set }
    var onFiveDaysWeatherForcastLoad: (([FiveDaysWeatherForcast]) -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }

    func loadWeatherForcast(lat: Double, long: Double)
    func viewDidLoad()
}

// MARK: - WeatherForcastViewModel

final class WeatherForcastViewModel: WeatherForcastViewModelDelegate {
    typealias Observer<T> = (T) -> Void

    var onLoadingStateChange: Observer<Bool>?
    var onCurrentDayWeatherForcastLoad: Observer<CurrentDayWeatherForcast>?
    var onFiveDaysWeatherForcastLoad: Observer<[FiveDaysWeatherForcast]>?
    var onError: Observer<String>?

    private let currentDayWeatherForcastLoader: CurrentDayWeatherForcastLoader
    private let fiveDaysWeatherForcastLoader: FiveDaysWeatherForcastLoader

    private let dispatchGroup = DispatchGroup()

    init(
        currentDayWeatherForcastLoader: CurrentDayWeatherForcastLoader,
        fiveDaysWeatherForcastLoader: FiveDaysWeatherForcastLoader) {
        self.currentDayWeatherForcastLoader = currentDayWeatherForcastLoader
        self.fiveDaysWeatherForcastLoader = fiveDaysWeatherForcastLoader
    }

    func viewDidLoad() {
        onLoadingStateChange?(true)
        dispatchGroup.notify(queue: .main) { [ weak self] in
            self?.onLoadingStateChange?(false)
         }
    }

    func loadWeatherForcast(lat: Double, long: Double) {

    }

    private func loadCurrentDayWeatherForcast(lat: Double, long: Double) {
        dispatchGroup.enter()
        currentDayWeatherForcastLoader.load { [weak self] result in
            guard let self = self else { return }

            self.dispatchGroup.leave()

            switch result {
            case .failure(let error):
                self.onError?(error.localizedDescription)
            case .success(let weatherForcast):
                self.onCurrentDayWeatherForcastLoad?(weatherForcast)
            }
        }
    }

    private func loadFiveDaysWeatherForcast(lat: Double, long: Double) {
        dispatchGroup.enter()

        fiveDaysWeatherForcastLoader.load { [weak self] result in
            guard let self = self else { return }

            self.dispatchGroup.leave()

            switch result {
            case .failure(let error):
                self.onError?(error.localizedDescription)
            case .success(let weatherForcast):
                self.onFiveDaysWeatherForcastLoad?(weatherForcast)
            }
        }
    }
}
