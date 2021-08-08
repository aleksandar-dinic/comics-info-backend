//
//  ComicDeleteResponseWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 23/05/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest
import NIO

final class ComicDeleteResponseWrapperTests: XCTestCase {

    private var eventLoop: EventLoop!
    private var sut: ComicDeleteResponseWrapper!
    private var environment: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        MockDB.removeAll()
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        let useCase = ComicDeleteUseCaseFactoryMock(items: [:], on: eventLoop).makeUseCase()
        sut = ComicDeleteResponseWrapper(useCase: useCase)
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
        // Givens
        let givenID = "ComicID"
        let items = ComicFactory.makeDatabaseItems(ID: givenID)
        let useCase = ComicDeleteUseCaseFactoryMock(items: items, on: eventLoop).makeUseCase()
        sut = ComicDeleteResponseWrapper(useCase: useCase)
        let request = Request(pathParameters: ["id": givenID])
        
        // When
        let feature = sut.handleDelete(on: eventLoop, request: request, environment: environment, logger: nil)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.ok.code)
    }

}
