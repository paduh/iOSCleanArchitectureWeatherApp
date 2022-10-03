//
//  RemoteFiveDaysWeatherForcastUseCase.swift
//  iOSCleanArchitectureWeatherApp
//
//  Created by Perfect Aduh on 02/10/2022.
//

import Foundation

// MARK: - Remote Five Days Weather Forcast UseCase

public final class RemoteFiveDaysWeatherForcastUseCase: FiveDaysWeatherForcastLoader {
    private let url: URL
    private let client: HTTPClient

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public typealias Result = LoadFiveDaysWeatherForcastResult

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
            let items = try FiveDaysWeatherForcastMapper.map(data, from: response)
            return .success(items.toDomainModels())
        } catch {
            return .failure(error)
        }
    }
}

private extension Array where Element == RemoteFiveDaysWeatherForcast {
    func toDomainModels() -> [FiveDaysWeatherForcast] {
        map { FiveDaysWeatherForcast(
            main: $0.main?.toMainModels(), weather: $0.weather?.toModels(), dtTxt: $0.dtTxt)}
    }
}

private extension Array where Element == RemoteFiveDaysWeather {
    func toModels() -> [FiveDaysWeather]? {
        map { FiveDaysWeather(id: $0.id, main: $0.main)}
    }
}
