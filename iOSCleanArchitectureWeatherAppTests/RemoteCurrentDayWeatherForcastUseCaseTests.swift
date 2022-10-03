// swiftlint: disable force_try
// swiftlint: disable type_name
//  RemoteCurrentDayWeatherForcastUseCaseTests.swift
//  iOSCleanArchitectureWeatherApp
//
//  Created by Perfect Aduh on 30/09/2022.
//

import XCTest
import iOSCleanArchitectureWeatherApp

class RemoteCurrentDayWeatherForcastUseCaseTests: XCTestCase {

    func test_init_doesNotRequestDataFromUrl() {
        let url = URL(string: "any-url.com")!
        let (_, client) = makeSUT(url: url)

        XCTAssertTrue(client.requestedUrls.isEmpty)
    }

    func test_load_requestsDataFromUrl() {
        let url = URL(string: "any-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in}

        XCTAssertEqual([url], client.requestedUrls)
    }

    func test_loadTwice_requestsDataFromUrlTwice() {
        let url = URL(string: "any-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in}
        sut.load { _ in}

        XCTAssertEqual(client.requestedUrls, [url, url])
    }

    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        expect(sut, toCompleteWithResult: failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 000, userInfo: nil)
            client.complete(with: clientError)
        }
    }

    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 201, 300, 400, 404, 500]
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWithResult: failure(.invalidData)) {
                let itemsJSON = makeItemsJSON([:])
                client.complete(withStatusCode: code, data: itemsJSON, index: index)
            }
        }
    }

    func test_load_deliversErrorsOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWithResult: failure(.invalidData)) {
            let invalidJSON = Data("Invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }

    func test_load_deliversItemOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()

        let item = makeItem(
            id: 1111,
            weather: [],
            main: nil)
        expect(sut, toCompleteWithResult: .success(item.model)) {
            let json = makeItemsJSON(item.json)
            client.complete(withStatusCode: 200, data: json)
        }
    }

    func test_load_doesNotDeliveryResultAfterSUTInstanceHasDeallocated() {

        let url = URL(string: "any-url")!
        let client = HTTPClientSpy()
        var sut: RemoteCurrentDayWeatherForcastUseCase?
        sut = RemoteCurrentDayWeatherForcastUseCase(url: url, client: client)
        var capturedResult = [RemoteCurrentDayWeatherForcastUseCase.Result]()
        sut?.load { capturedResult.append($0) }

        sut = nil
        client.complete(withStatusCode: 200, data: makeItemsJSON([:]))

        XCTAssertTrue(capturedResult.isEmpty)
    }

    // MARK: Helpers

    private func  makeSUT(
        url: URL = URL(string: "any-url.com")!,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (RemoteCurrentDayWeatherForcastUseCase, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteCurrentDayWeatherForcastUseCase(url: url, client: client)
        trackForMemoryLeak(client, file: file, line: line)
        trackForMemoryLeak(sut, file: file, line: line)
        return (sut, client)
    }

    private func failure(_ error: RemoteCurrentDayWeatherForcastUseCase.Error) -> LoadCurrentDayWeatherForcastResult {
        .failure(error)
    }

    private func makeItem(
        id: Int?,
        weather: [CurrentDayWeather]?,
        main: Main?)
    -> (model: CurrentDayWeatherForcast, json: [String: Any]) {
        let item = CurrentDayWeatherForcast(
            id: id,
            weather: weather,
            main: main)

        let itemJSON: [String: Any] = [
            "id": item.id,
            "weather": item.weather,
            "main": main
        ].compactMapValues { $0 }
        return (model: item, json: itemJSON)
    }

    private func makeItemsJSON(_ items: [String: Any]) -> Data {
        return try! JSONSerialization.data(withJSONObject: items)
    }

    func expect(
        _ sut: RemoteCurrentDayWeatherForcastUseCase,
        toCompleteWithResult expectedResult: RemoteCurrentDayWeatherForcastUseCase.Result,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line) {

        let exp = expectation(description: "wait for load completion")

        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.failure(
                receivedError as RemoteCurrentDayWeatherForcastUseCase.Error
            ), (.failure(
                expectedError as RemoteCurrentDayWeatherForcastUseCase.Error))):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }

        action()

        wait(for: [exp], timeout: 1.0)
    }

    private class HTTPClientSpy: HTTPClient {

        var messages = [(url: URL, completions: (HTTPClient.Result) -> Void)]()
        var requestedUrls: [URL] {
            messages.map { $0.url}
        }

        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
            messages.append((url, completion))

            return URLSessionTaskWrapperSpy(wrapped: URLSessionTask())
        }

        func complete(with error: Error, at index: Int = 0) {
            messages[index].completions(.failure(error))
        }

        func complete(withStatusCode code: Int, data: Data, index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedUrls[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil)!
            messages[index].completions(.success((data, response)))
        }
    }

    private struct URLSessionTaskWrapperSpy: HTTPClientTask {
        let wrapped: URLSessionTask

        func cancel() {
            wrapped.cancel()
        }
    }
}
