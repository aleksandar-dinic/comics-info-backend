//
//  CharacterDatabaseProviderTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 20/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
@testable import CharacterInfo
import XCTest
import NIO

final class CharacterDatabaseProviderTests: XCTestCase {

    private var eventLoop: EventLoop!
    private var sut: CharacterReadResponseWrapper!

    override func setUpWithError() throws {
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
    }

    override func tearDownWithError() throws {
        eventLoop = nil
    }

    func testLocalServer_whenHandleList_statusCodeIsOk() throws {
        // Given
        let characterCacheService = CharacterCacheServiceMock()
        let characterUseCaseFactory = CharacterUseCaseFactory(on: eventLoop, isLocalServer: true, characterCacheService: characterCacheService)
        let sut = CharacterListResponseWrapper(characterUseCase: characterUseCaseFactory.makeCharacterUseCase())

        // When
        let responseFuture = sut.handleList(on: eventLoop)

        // Then
        let response = try responseFuture.wait()
        XCTAssertEqual(response.statusCode.code, HTTPResponseStatus.ok.code)
    }

    func testLocalServer_whenHandleRead_statusCodeIsOk() throws {
        // Given
        let characterCacheService = CharacterCacheServiceMock()
        let characterUseCaseFactory = CharacterUseCaseFactory(on: eventLoop, isLocalServer: true, characterCacheService: characterCacheService)
        let sut = CharacterReadResponseWrapper(characterUseCase: characterUseCaseFactory.makeCharacterUseCase())

        // When
        let responseFuture = sut.handleRead(on: eventLoop, request: Request(pathParameters: [.identifier: "1"], body: nil))

        // Then
        let response = try responseFuture.wait()
        XCTAssertEqual(response.statusCode.code, HTTPResponseStatus.ok.code)
    }

}
