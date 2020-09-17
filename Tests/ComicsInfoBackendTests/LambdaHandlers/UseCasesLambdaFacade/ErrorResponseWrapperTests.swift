//
//  ErrorResponseWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 10/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
@testable import CharacterInfo
import XCTest
import NIO

final class ErrorResponseWrapperTests: XCTestCase {

    private var eventLoop: EventLoop!
    private var sut: ErrorResponseWrapperMock!
    private var error: APIError!
    private var givenResponse: Response!

    override func setUpWithError() throws {
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        sut = ErrorResponseWrapperMock()
        error = APIError.requestError
        givenResponse = Response(with: error, statusCode: .notFound)
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        sut = nil
        error = nil
        givenResponse = nil
    }

    func testErrorResponseWrapper_whenCatchError_isEqualResponse() throws {
        // Given

        // When
        let response = try sut.catchError(on: eventLoop, error: error).wait()

        // Then
        XCTAssertEqual(response.statusCode.code, givenResponse.statusCode.code)
        XCTAssertEqual(response.body, givenResponse.body)
    }

}
