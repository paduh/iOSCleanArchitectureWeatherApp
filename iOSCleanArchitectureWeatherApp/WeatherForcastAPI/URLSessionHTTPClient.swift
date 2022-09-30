//
//  URLSessionHTTPClient.swift
//  iOSCleanArchitectureWeatherApp
//
//  Created by Perfect Aduh on 30/09/2022.
//

import Foundation

// MARK: - URLSessionHTTPClient

public final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    private struct UnexpectedValuesRepresentation: Error {}
    
    private struct URLSessionTaskWrapper: HTTPClientTask {
        let wrapped: URLSessionTask
        
        func cancel() {
            wrapped.cancel()
        }
    }
    
    public func get(from url: URL,completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        let parameters: [String : CustomStringConvertible] = [:]
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            components.queryItems = parameters.keys.map { key in
                URLQueryItem(name: key, value: parameters[key]?.description)
            }
        let url = components.url!
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request){ data, response, error in completion(Result {
                    if let error = error {
                        throw error
                    } else if let data = data, let response = response as? HTTPURLResponse {
                        return (data, response)
                    } else {
                        throw UnexpectedValuesRepresentation()
                    }
                })
            }
            task.resume()
            return URLSessionTaskWrapper(wrapped: task)
    }
}
