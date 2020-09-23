//
//  CharacterCreateResponseWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 20/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
@testable import CharacterInfo
import XCTest
import NIO

final class CharacterCreateResponseWrapperTests: XCTestCase {

    private var eventLoop: EventLoop!
    private var characterUseCaseFactory: CharacterUseCaseFactory!
    private var request: Request!
    private var sut: CharacterCreateResponseWrapper!

    override func setUpWithError() throws {
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        characterUseCaseFactory = CharacterUseCaseFactory(on: eventLoop, isLocalServer: true)
        request = Request(pathParameters: nil, body: "{ \"identifier\": \"1\", \"popularity\": 0, \"name\": \"name\" }")
        sut = CharacterCreateResponseWrapper(characterUseCase: characterUseCaseFactory.makeCharacterUseCase())
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        characterUseCaseFactory = nil
        request = nil
        sut = nil
    }

    func test_whenHandleCreate_responseStatusIsCreated() throws {
        // Given

        // When
        let responseFuture = sut.handleCreate(on: eventLoop, request: request)

        // Then
        let response = try responseFuture.wait()
        XCTAssertEqual(response.statusCode.code, HTTPResponseStatus.created.code)
    }

    func test_whenHandleCreate_responseBodyIsCharacterCreated() throws {
        // Given

        // When
        let responseFuture = sut.handleCreate(on: eventLoop, request: request)

        // Then
        let response = try responseFuture.wait()
        XCTAssertEqual(response.body, "{\"message\":\"Character created\"}")
    }

    func testBodyIsNil_whenHandleCreate_responseStatusIsBadRequest() throws {
        // Given
        request = Request(pathParameters: nil, body: nil)

        // When
        let responseFuture = sut.handleCreate(on: eventLoop, request: request)

        // Then
        let response = try responseFuture.wait()
        XCTAssertEqual(response.statusCode.code, HTTPResponseStatus.badRequest.code)
    }

    func testInvalidCharacterJSON_whenHandleCreate_responseStatusIsBadRequest() throws {
        // Given
        request = Request(pathParameters: nil, body: "{ \"\" }")

        // When
        let responseFuture = sut.handleCreate(on: eventLoop, request: request)

        // Then
        let response = try responseFuture.wait()
        XCTAssertEqual(response.statusCode.code, HTTPResponseStatus.badRequest.code)
    }

    func testCreateCharacterWithExistingID_whenHandleCreate_responseStatusIsForbidden() throws {
        // Given

        // When
        _ = try sut.handleCreate(on: eventLoop, request: request).wait()
        let responseFuture = sut.handleCreate(on: eventLoop, request: request)

        // Then
        let response = try responseFuture.wait()
        XCTAssertEqual(response.statusCode.code, HTTPResponseStatus.forbidden.code)
    }

}
