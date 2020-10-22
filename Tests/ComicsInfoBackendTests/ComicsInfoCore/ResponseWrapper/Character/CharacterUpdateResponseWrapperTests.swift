//
//  CharacterUpdateResponseWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest
import NIO

final class CharacterUpdateResponseWrapperTests: XCTestCase, CreateCharacterProtocol {

    private typealias Cache = InMemoryCacheProvider<Character>

    private var eventLoop: EventLoop!
    private var sut: CharacterUpdateResponseWrapper<CharacterRepositoryAPIWrapper, Cache>!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        let useCase = CharacterUseCaseFactoryMock(on: eventLoop).makeUseCase()
        sut = CharacterUpdateResponseWrapper(characterUseCase: useCase)
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        sut = nil
    }

    func test_whenHandleUpdateWithoutBody_statusIsBadRequest() throws {
        // Given
        let request = Request(pathParameters: nil, body: nil)

        // When
        let feature = sut.handleUpdate(on: eventLoop, request: request)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.badRequest.code)
    }

    func test_whenHandleUpdateWithInvalidBody_statusIsBadRequest() throws {
        // Given
        let request = Request(pathParameters: nil, body: "")

        // When
        let feature = sut.handleUpdate(on: eventLoop, request: request)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.badRequest.code)
    }

    func test_whenHandleUpdateNonExistingItem_statusIsForbidden() throws {
        // Given
        let request = Request(pathParameters: nil, body: CharacterMock.requestBody)

        // When
        let feature = sut.handleUpdate(on: eventLoop, request: request)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.forbidden.code)
    }

    func test_whenHandleUpdate_statusIsOk() throws {
        // Given
        let character = CharacterMock.makeCharacter(name: "Old Name")
        try createCharacter(character)
        let request = Request(pathParameters: nil, body: CharacterMock.requestBody)

        // When
        let feature = sut.handleUpdate(on: eventLoop, request: request)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.ok.code)
    }

}
