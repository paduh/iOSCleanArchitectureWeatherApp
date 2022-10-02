//
//  CurrentDayWeatherForcastMapper.swift
//  iOSCleanArchitectureWeatherApp
//
//  Created by Perfect Aduh on 30/09/2022.
//

import Foundation

// MARK: - CurrentDayWeatherForcastMapper

final class CurrentDayWeatherForcastMapper {

    static let OK200 = 200

    static func map(_ data: Data, from response: HTTPURLResponse) throws -> RemoteCurrentDayWeatherForcast {
        guard response.statusCode == OK200,
              let remoteCurrentDayWeatherForcast = try? JSONDecoder().decode(
                RemoteCurrentDayWeatherForcast.self,
                from: data)
        else {
            throw RemoteCurrentDayWeatherForcastUseCase.Error.invalidData
        }
        return remoteCurrentDayWeatherForcast
    }
}
