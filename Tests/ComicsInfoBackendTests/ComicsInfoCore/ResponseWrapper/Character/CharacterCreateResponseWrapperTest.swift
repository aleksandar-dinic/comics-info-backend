//
//  CharacterCreateResponseWrapperTest.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest
import NIO

final class CharacterCreateResponseWrapperTest: XCTestCase {

    private var eventLoop: EventLoop!
    private var sut: CharacterCreateResponseWrapper!
    private var environment: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        sut = CharacterCreateResponseWrapperMock.make(on: eventLoop)
        environment = "TEST"
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        sut = nil
        environment = nil
    }

    func test_whenHandleCreateWithoutBody_statusIsBadRequest() throws {
        // Given
        let request = Request()

        // When
        let feature = sut.handleCreate(on: eventLoop, request: request, environment: environment)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.badRequest.code)
    }

    func test_whenHandleCreateWithInvalidBody_statusIsBadRequest() throws {
        // Given
        let request = Request(body: "")

        // When
        let feature = sut.handleCreate(on: eventLoop, request: request, environment: environment)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.badRequest.code)
    }

    func test_whenHandleCreate_statusIsCreated() throws {
        // Given
        let request = Request(body: CharacterFactory.requestBody)

        // When
        let feature = sut.handleCreate(on: eventLoop, request: request, environment: environment)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.created.code)
    }

    func test_whenHandleCreateSameItemTwice_statusIsForbidden() throws {
        // Given
        let request = Request(body: CharacterFactory.requestBody)
        var feature = sut.handleCreate(on: eventLoop, request: request, environment: environment)
        _ = try feature.wait()

        // When
        feature = sut.handleCreate(on: eventLoop, request: request, environment: environment)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.forbidden.code)
    }

}
