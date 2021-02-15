//
//  CharacterUpdateResponseWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import struct Logging.Logger
import XCTest
import NIO

final class CharacterUpdateResponseWrapperTests: XCTestCase, CreateCharacterProtocol {

    private var eventLoop: EventLoop!
    private var sut: CharacterUpdateResponseWrapper!
    private var logger: Logger!
    private var environment: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        MockDB.removeAll()
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        let useCase = CharacterUpdateUseCaseFactoryMock(items: [:], on: eventLoop).makeUseCase()
        sut = CharacterUpdateResponseWrapper(characterUseCase: useCase)
        logger = Logger(label: "CharacterUpdateResponseWrapperTests")
        environment = "TEST"
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        sut = nil
        logger = nil
        environment = nil
    }

    func test_whenHandleUpdateWithoutBody_statusIsBadRequest() throws {
        // Given
        let request = Request()

        // When
        let feature = sut.handleUpdate(on: eventLoop, request: request, environment: environment, logger: logger)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.badRequest.code)
    }

    func test_whenHandleUpdateWithInvalidBody_statusIsBadRequest() throws {
        // Given
        let request = Request(body: "")

        // When
        let feature = sut.handleUpdate(on: eventLoop, request: request, environment: environment, logger: logger)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.badRequest.code)
    }

    func test_whenHandleUpdateNonExistingItem_statusIsNoContent() throws {
        // Given
        let request = Request(body: CharacterFactory.requestBody)

        // When
        let feature = sut.handleUpdate(on: eventLoop, request: request, environment: environment, logger: logger)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.noContent.code)
    }

    func test_whenHandleUpdate_statusIsOk() throws {
        // Given
        let character = CharacterFactory.make(name: "Old Name")
        try createCharacter(character)
        let request = Request(body: CharacterFactory.requestBody)

        // When
        let feature = sut.handleUpdate(on: eventLoop, request: request, environment: environment, logger: logger)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.ok.code)
    }

}
