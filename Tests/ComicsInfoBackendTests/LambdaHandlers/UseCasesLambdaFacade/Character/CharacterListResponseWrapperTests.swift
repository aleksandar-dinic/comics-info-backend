//
//  CharacterListResponseWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 10/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest
import NIO

final class CharacterListResponseWrapperTests: XCTestCase {

    private var eventLoop: EventLoop!

    override func setUpWithError() throws {
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
    }

    override func tearDownWithError() throws {
        eventLoop = nil
    }

    func test_whenHandleList_returnsResponseWithCharacters() throws {
        // Given
        let characterRepository = CharacterRepositoryMockFactory.makeWithCharacters()
        let characterUseCase = CharacterUseCase(characterRepository: characterRepository)
        let sut = CharacterListResponseWrapper(characterUseCase: characterUseCase)

        var givenBody = "{}"
        if let data = try? JSONEncoder().encode(CharactersMock.characters) {
            givenBody = String(data: data, encoding: .utf8) ?? "{}"
        }

        // When
        let responseFuture = sut.handleList(on: eventLoop)

        // Then
        let response = try responseFuture.wait()
        XCTAssertEqual(response.body, givenBody)
    }

    func testListNonExistingCharacters_whenHandleList_returnsResponseWithErrorCharactersNotFound() throws {
        // Given
        let characterRepository = CharacterRepositoryMockFactory.makeWithoutData()
        let characterUseCase = CharacterUseCase(characterRepository: characterRepository)
        let sut = CharacterListResponseWrapper(characterUseCase: characterUseCase)

        let givenError = APIError.charactersNotFound
        let givenBody = "{\"message\":\"\(String(describing: givenError))\"}"

        // When
        let responseFuture = sut.handleList(on: eventLoop)

        // Then
        let response = try responseFuture.wait()
        XCTAssertEqual(response.body, givenBody)
    }

}
