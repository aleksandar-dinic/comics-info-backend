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

    private typealias Cache = InMemoryCacheProvider<Character>

    private var eventLoop: EventLoop!
    private var sut: CharacterListResponseWrapper<CharacterRepositoryAPIWrapper, Cache>!
    private var environment: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        let useCase = CharacterUseCaseFactoryMock(on: eventLoop).makeUseCase()
        sut = CharacterListResponseWrapper(characterUseCase: useCase)
        environment = "TEST"
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        sut = nil
        environment = nil
    }

    func test_whenHandleListWithoutItems_statusIsNotFound() throws {
        // Given

        // When
        let feature = sut.handleList(on: eventLoop, environment: environment)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.notFound.code)
    }

    func test_whenHandleList_statusIsOk() throws {
        // Given
        try createCharacter(CharacterMock.makeCharacter())

        // When
        let feature = sut.handleList(on: eventLoop, environment: environment)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.ok.code)
    }

}
