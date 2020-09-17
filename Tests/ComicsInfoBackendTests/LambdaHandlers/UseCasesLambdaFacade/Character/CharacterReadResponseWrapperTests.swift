//
//  CharacterReadResponseWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 10/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
@testable import CharacterInfo
import XCTest
import NIO

final class CharacterReadResponseWrapperTests: XCTestCase {

    private var eventLoop: EventLoop!
    private var sut: CharacterReadResponseWrapper!

    override func setUpWithError() throws {
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        let characterRepository = CharacterRepositoryMockFactory.makeWithCharacter()
        let characterUseCase = CharacterUseCase(characterRepository: characterRepository)
        sut = CharacterReadResponseWrapper(characterUseCase: characterUseCase)
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        sut = nil
    }

    func test_whenHandleRead_returnsResponseWithCharacter() throws {
        // Given
        var givenBody = "{}"
        if let data = try? JSONEncoder().encode(CharactersMock.character) {
            givenBody = String(data: data, encoding: .utf8) ?? "{}"
        }

        // When
        let responseFuture = sut.handleRead(on: eventLoop, request: makeRequest(pathParameters: [.identifier: "1"]))

        // Then
        let response = try responseFuture.wait()
        XCTAssertEqual(response.body, givenBody)
    }

    func testReadNonExistingCharacter_whenHandleRead_returnsResponseWithErrorCharacterNotFound() throws {
        // Given
        let givenError = APIError.characterNotFound
        let givenBody = "{\"message\":\"\(String(describing: givenError))\"}"

        // When
        let responseFuture = sut.handleRead(on: eventLoop, request: makeRequest(pathParameters: [.identifier: "-1"]))

        // Then
        let response = try responseFuture.wait()
        XCTAssertEqual(response.body, givenBody)
    }

    func testInvalitPathParameters_whenHandleRead_returnsResponseNotFound() throws {
        // Given
        let givenResponse = Response(statusCode: .notFound)

        // When
        let responseFuture = sut.handleRead(on: eventLoop, request: makeRequest(pathParameters: [:]))

        // Then
        let response = try responseFuture.wait()
        XCTAssertEqual(response.statusCode.code, givenResponse.statusCode.code)
    }

    private func makeRequest(pathParameters: [String: String]) -> Request {
        Request(pathParameters: pathParameters, context: Context(http: HTTP(path: "", method: .GET)))
    }

}
