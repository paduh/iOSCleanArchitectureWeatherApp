//
//  HTTPClient.swift
//  iOSCleanArchitectureWeatherApp
//
//  Created by Perfect Aduh on 30/09/2022.
//

import Foundation

// MARK: - HTTPClientTask

public protocol HTTPClientTask {
    func cancel()
}

// MARK: - HTTPClientResult

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

// MARK: - HTTPClient

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>

    func get(from url: URL, lat: Double, long: Double, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask
}
