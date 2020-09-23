//
//  HTTPResponseStatus4xxTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 10/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class HTTPResponseStatus4xxTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testBadRequestCode_IsEqual400() {
        // Given
        let sut = HTTPResponseStatus.badRequest

        // Then
        XCTAssertEqual(sut.code, 400)
    }

    func testUnauthorizedCode_IsEqual401() {
        // Given
        let sut = HTTPResponseStatus.unauthorized

        // Then
        XCTAssertEqual(sut.code, 401)
    }

    func testPaymentRequiredCode_IsEqual402() {
        // Given
        let sut = HTTPResponseStatus.paymentRequired

        // Then
        XCTAssertEqual(sut.code, 402)
    }

    func testForbiddenCode_IsEqual403() {
        // Given
        let sut = HTTPResponseStatus.forbidden

        // Then
        XCTAssertEqual(sut.code, 403)
    }

    func testNotFoundCode_IsEqual404() {
        // Given
        let sut = HTTPResponseStatus.notFound

        // Then
        XCTAssertEqual(sut.code, 404)
    }

    func testMethodNotAllowedCode_IsEqual405() {
        // Given
        let sut = HTTPResponseStatus.methodNotAllowed

        // Then
        XCTAssertEqual(sut.code, 405)
    }

    func testNotAcceptableCode_IsEqual406() {
        // Given
        let sut = HTTPResponseStatus.notAcceptable

        // Then
        XCTAssertEqual(sut.code, 406)
    }

    func testProxyAuthenticationRequiredCode_IsEqual407() {
        // Given
        let sut = HTTPResponseStatus.proxyAuthenticationRequired

        // Then
        XCTAssertEqual(sut.code, 407)
    }

    func testRequestTimeoutCode_IsEqual408() {
        // Given
        let sut = HTTPResponseStatus.requestTimeout

        // Then
        XCTAssertEqual(sut.code, 408)
    }

    func testConflictCode_IsEqual409() {
        // Given
        let sut = HTTPResponseStatus.conflict

        // Then
        XCTAssertEqual(sut.code, 409)
    }

    func testGoneCode_IsEqual410() {
        // Given
        let sut = HTTPResponseStatus.gone

        // Then
        XCTAssertEqual(sut.code, 410)
    }

    func testLengthRequiredCode_IsEqual411() {
        // Given
        let sut = HTTPResponseStatus.lengthRequired

        // Then
        XCTAssertEqual(sut.code, 411)
    }

    func testPreconditionFailedCode_IsEqual412() {
        // Given
        let sut = HTTPResponseStatus.preconditionFailed

        // Then
        XCTAssertEqual(sut.code, 412)
    }

    func testPayloadTooLargeCode_IsEqual413() {
        // Given
        let sut = HTTPResponseStatus.payloadTooLarge

        // Then
        XCTAssertEqual(sut.code, 413)
    }

    func testUriTooLongCode_IsEqual414() {
        // Given
        let sut = HTTPResponseStatus.uriTooLong

        // Then
        XCTAssertEqual(sut.code, 414)
    }

    func testUnsupportedMediaTypeCode_IsEqual415() {
        // Given
        let sut = HTTPResponseStatus.unsupportedMediaType

        // Then
        XCTAssertEqual(sut.code, 415)
    }

    func testRangeNotSatisfiableCode_IsEqual416() {
        // Given
        let sut = HTTPResponseStatus.rangeNotSatisfiable

        // Then
        XCTAssertEqual(sut.code, 416)
    }

    func testExpectationFailedCode_IsEqual417() {
        // Given
        let sut = HTTPResponseStatus.expectationFailed

        // Then
        XCTAssertEqual(sut.code, 417)
    }

    func testImATeapotCode_IsEqual418() {
        // Given
        let sut = HTTPResponseStatus.imATeapot

        // Then
        XCTAssertEqual(sut.code, 418)
    }

    func testMisdirectedRequestCode_IsEqual421() {
        // Given
        let sut = HTTPResponseStatus.misdirectedRequest

        // Then
        XCTAssertEqual(sut.code, 421)
    }

    func testUnprocessableEntityCode_IsEqual422() {
        // Given
        let sut = HTTPResponseStatus.unprocessableEntity

        // Then
        XCTAssertEqual(sut.code, 422)
    }

    func testLockedCode_IsEqual423() {
        // Given
        let sut = HTTPResponseStatus.locked

        // Then
        XCTAssertEqual(sut.code, 423)
    }

    func testFailedDependencyCode_IsEqual424() {
        // Given
        let sut = HTTPResponseStatus.failedDependency

        // Then
        XCTAssertEqual(sut.code, 424)
    }

    func testUpgradeRequiredCode_IsEqual426() {
        // Given
        let sut = HTTPResponseStatus.upgradeRequired

        // Then
        XCTAssertEqual(sut.code, 426)
    }

    func testPreconditionRequiredCode_IsEqual428() {
        // Given
        let sut = HTTPResponseStatus.preconditionRequired

        // Then
        XCTAssertEqual(sut.code, 428)
    }

    func testTooManyRequestsCode_IsEqual429() {
        // Given
        let sut = HTTPResponseStatus.tooManyRequests

        // Then
        XCTAssertEqual(sut.code, 429)
    }

    func testRequestHeaderFieldsTooLargeCode_IsEqual431() {
        // Given
        let sut = HTTPResponseStatus.requestHeaderFieldsTooLarge

        // Then
        XCTAssertEqual(sut.code, 431)
    }

    func testUnavailableForLegalReasonsCode_IsEqual451() {
        // Given
        let sut = HTTPResponseStatus.unavailableForLegalReasons

        // Then
        XCTAssertEqual(sut.code, 451)
    }

}
