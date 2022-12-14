//
//  RemoteCurrentDayWeatherForcastUseCase.swift
//  iOSCleanArchitectureWeatherApp
//
//  Created by Perfect Aduh on 30/09/2022.
//

import Foundation

// MARK: - RemoteMovieLoader

public final class RemoteCurrentDayWeatherForcastUseCase: CurrentDayWeatherForcastLoader {
    private let url: URL
    private let client: HTTPClient

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public typealias Result = LoadCurrentDayWeatherForcastResult

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public func load(lat: Double, long: Double, completion: @escaping (Result) -> Void) {
        _ = client.get(from: url, lat: lat, long: long, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success((data, response)):
                completion(self.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        })
    }

    private func map(_ data: Data, from response: HTTPURLResponse) -> Result {

        do {
            let items = try CurrentDayWeatherForcastMapper.map(data, from: response)
            return .success(items.toModels())
        } catch {
            return .failure(error)
        }
    }
}

private extension RemoteCurrentDayWeatherForcast {
    func toModels() -> CurrentDayWeatherForcast {
        CurrentDayWeatherForcast(
            id: id,
            weather: weather?.toModels(),
            main: main?.toMainModels())
    }
}

private extension Array where Element == RemoteWeather {
    func toModels() -> [CurrentDayWeather]? {
        map { CurrentDayWeather(
            id: $0.id,
            main: $0.main)}
    }
}

extension RemoteMain {
    func toMainModels() -> Main {
        Main(temp: temp, tempMin: tempMin, tempMax: tempMax)
    }
}
