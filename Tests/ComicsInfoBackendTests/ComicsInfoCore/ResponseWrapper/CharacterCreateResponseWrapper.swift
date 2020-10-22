//
//  CreateResponseWrapper.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest
import NIO

final class CreateResponseWrapper: XCTestCase {

    private typealias Cache = InMemoryCacheProvider<Character>
    private typealias UseCase = CharacterUseCase<CharacterRepositoryAPIWrapper, Cache>

    private var eventLoop: EventLoop!
    private var sut: CreateResponseWrapper<UseCase>!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        sut = CharacterCreateResponseWrapperMock.make(on: eventLoop)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_whenHandleCreateWithoutBody_statusIsBadRequest() throws {
        // Given
        let request = Request(pathParameters: nil, body: nil)

        // When
        let feature = sut.handleCreate(on: eventLoop, request: request)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.badRequest.code)
    }

    func test_whenHandleCreateWithInvalidBody_statusIsBadRequest() throws {
        // Given
        let request = Request(pathParameters: nil, body: "")

        // When
        let feature = sut.handleCreate(on: eventLoop, request: request)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.badRequest.code)
    }

    func test_whenHandleCreate_statusIsCreated() throws {
        // Given
        let request = Request(pathParameters: nil, body: CharacterMock.requestBody)

        // When
        let feature = sut.handleCreate(on: eventLoop, request: request)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.created.code)
    }

    func test_whenHandleCreateSameItemTwice_statusIsForbidden() throws {
        // Given
        let request = Request(pathParameters: nil, body: CharacterMock.requestBody)
        var feature = sut.handleCreate(on: eventLoop, request: request)
        _ = try feature.wait()

        // When
        feature = sut.handleCreate(on: eventLoop, request: request)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.forbidden.code)
    }

}
