//
//  WeatherForcastFeedViewModel.swift
//  iOSCleanArchitectureWeatherApp
//
//  Created by Perfect Aduh on 02/10/2022.
//  Copyright © 2022 Perfect Aduh. All rights reserved.
//

import Foundation

// MARK: - Weather Forcast Feed ViewModel Delegate

protocol WeatherForcastFeedViewModelDelegate: AnyObject {
    var onLoadingStateChange: ((Bool) -> Void)? { get set }
    var onCurrentDayWeatherForcastLoad: ((CurrentDayWeatherForcast) -> Void)? { get set }
    var onFiveDaysWeatherForcastLoad: (([FiveDaysWeatherForcast]) -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }

    func loadWeatherForcast(lat: Double, long: Double)
    func viewDidLoad()
}

// MARK: - Weather Forcast ViewModel

final class WeatherForcastFeedViewModel: WeatherForcastFeedViewModelDelegate {
    typealias Observer<T> = (T) -> Void

    var onLoadingStateChange: Observer<Bool>?
    var onCurrentDayWeatherForcastLoad: Observer<CurrentDayWeatherForcast>?
    var onFiveDaysWeatherForcastLoad: Observer<[FiveDaysWeatherForcast]>?
    var onError: Observer<String>?

    private let currentDayWeatherForcastLoader: CurrentDayWeatherForcastLoader
    private let fiveDaysWeatherForcastLoader: FiveDaysWeatherForcastLoader

    private let dispatchGroup = DispatchGroup()

    // MARK: - Life Cycle

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
        loadCurrentDayWeatherForcast(lat: lat, long: long)
        loadFiveDaysWeatherForcast(lat: lat, long: long)
    }

    // MARK: - Load Current Day Weather Forcast

    private func loadCurrentDayWeatherForcast(lat: Double, long: Double) {
        dispatchGroup.enter()

        currentDayWeatherForcastLoader.load(lat: lat, long: long) { [weak self] result in
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

    // MARK: - Load Five Days Weather Forcast

    private func loadFiveDaysWeatherForcast(lat: Double, long: Double) {
        dispatchGroup.enter()

        fiveDaysWeatherForcastLoader.load(lat: lat, long: long) { [weak self] result in
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

extension Double {
    var string: String {
        String(self)
    }

    var celciusTemp: String {
        String(format: "%.0f", self - 273.15)
    }
}
