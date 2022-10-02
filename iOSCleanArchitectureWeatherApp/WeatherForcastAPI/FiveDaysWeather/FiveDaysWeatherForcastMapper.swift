//
//  FiveDaysWeatherForcastMapper.swift
//  iOSCleanArchitectureWeatherApp
//
//  Created by Perfect Aduh on 02/10/2022.
//

import Foundation

// MARK: - Five Days Weather Forcast Mapper

final class FiveDaysWeatherForcastMapper {

    private struct Root: Codable {
        let list: [RemoteFiveDaysWeatherForcast]
    }

    static let OK200 = 200

    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFiveDaysWeatherForcast] {
        guard response.statusCode == OK200,
              let root = try? JSONDecoder().decode(
                Root.self,
                from: data)
        else {
            throw RemoteFiveDaysWeatherForcastUseCase.Error.invalidData
        }
        return root.list
    }
}
