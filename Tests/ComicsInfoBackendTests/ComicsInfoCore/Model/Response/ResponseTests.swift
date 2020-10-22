//
//  ResponseTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 10/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class ResponseTests: XCTestCase {

    private var object: Character!
    private var givenStatusCode: HTTPResponseStatus!

    override func setUpWithError() throws {
        object = CharacterMock.character
        givenStatusCode = HTTPResponseStatus.ok
    }

    override func tearDownWithError() throws {
        object = nil
        givenStatusCode = nil
    }

    func testResponse_whenInitializeWithObject_bodyIsEqualGivenBody() {
        // Given
        var givenBody = "{}"
        if let data = try? JSONEncoder().encode(object) {
            givenBody = String(data: data, encoding: .utf8) ?? "{}"
        }

        // When
        let sut = Response(with: object, statusCode: givenStatusCode)

        // Then
        XCTAssertEqual(sut.body, givenBody)
    }

    func testResponse_whenInitializeWithObject_statusCodeIsEqualGivenStatusCode() {
        // Given

        // When
        let sut = Response(with: object, statusCode: givenStatusCode)

        // Then
        XCTAssertEqual(sut.statusCode.code, givenStatusCode.code)
    }

}
