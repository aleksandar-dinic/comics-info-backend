//
//  CharacterListResponseWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest
import NIO

final class CharacterListResponseWrapperTests: XCTestCase, CreateCharacterProtocol {

    private var eventLoop: EventLoop!
    private var sut: CharacterListResponseWrapper!
    private var environment: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        MockDB.removeAll()
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        let useCase = CharacterUseCaseFactoryMock(items: [:], on: eventLoop).makeUseCase()
        sut = CharacterListResponseWrapper(characterUseCase: useCase)
        environment = "TEST"
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        sut = nil
        environment = nil
    }

    func test_whenHandleListWithoutItems_statusIsNoContent() throws {
        // Given

        // When
        let feature = sut.handleList(on: eventLoop, request: Request(), environment: environment, logger: nil)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.noContent.code)
    }

    func test_whenHandleList_statusIsOk() throws {
        // Given
        try createCharacter(CharacterFactory.make())

        // When
        let feature = sut.handleList(on: eventLoop, request: Request(), environment: environment, logger: nil)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.ok.code)
    }

}
