//
//  CharacterDeleteResponseWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/05/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest
import NIO

final class CharacterDeleteResponseWrapperTests: XCTestCase {

    private var eventLoop: EventLoop!
    private var sut: CharacterDeleteResponseWrapper!
    private var environment: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        MockDB.removeAll()
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        let useCase = CharacterDeleteUseCaseFactoryMock(items: [:], on: eventLoop).makeUseCase()
        sut = CharacterDeleteResponseWrapper(useCase: useCase)
        environment = "TEST"
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        sut = nil
        environment = nil
    }

    func test_whenHandleDeleteWithoutItems_statusIsNoContent() throws {
        // Given
        let request = Request(pathParameters: ["id": "-1"])

        // When
        let feature = sut.handleDelete(on: eventLoop, request: request, environment: environment, logger: nil)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.noContent.code)
    }

    func test_whenHandleDelete_statusIsOk() throws {
        // Given
        let givenID = "CharacterID"
        let request = Request(pathParameters: ["id": givenID])
        let items = CharacterFactory.makeDatabaseItems(ID: givenID)
        let useCase = CharacterDeleteUseCaseFactoryMock(items: items, on: eventLoop).makeUseCase()
        sut = CharacterDeleteResponseWrapper(useCase: useCase)

        // When
        let feature = sut.handleDelete(on: eventLoop, request: request, environment: environment, logger: nil)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.ok.code)
    }

}
