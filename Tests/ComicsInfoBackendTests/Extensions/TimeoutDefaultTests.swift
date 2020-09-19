//
//  TimeoutDefaultTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 19/09/2020.
//

@testable import ComicsInfoCore
@testable import AsyncHTTPClient
import XCTest

final class TimeoutDefaultTests: XCTestCase {

    private var sut: HTTPClient.Configuration.Timeout!

    override func setUpWithError() throws {
        sut = .default
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testDefaultConnect_IsEqual30Seconds() throws {
        let connect = try XCTUnwrap(sut.connect)
        XCTAssertEqual(connect.nanoseconds, 30_000_000_000)
    }

    func testDefaultRead_IsEqual30Seconds() throws {
        let read = try XCTUnwrap(sut.read)
        XCTAssertEqual(read.nanoseconds, 30_000_000_000)
    }

}
