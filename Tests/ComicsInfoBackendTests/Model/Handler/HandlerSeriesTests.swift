//
//  HandlerSeriesTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 01/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class HandlerSeriesTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    // Initialization

    func testHandler_whenInitialize_isEqualSeriesCreate() {
        // Given
        let seriesCreate = Handler.series(.create)

        // When
        let sut = Handler(rawValue: "series.create")

        // Then
        XCTAssertEqual(sut, seriesCreate)
    }

    func testHandler_whenInitialize_isEqualSeriesRead() {
        // Given
        let seriesRead = Handler.series(.read)

        // When
        let sut = Handler(rawValue: "series.read")

        // Then
        XCTAssertEqual(sut, seriesRead)
    }

    func testHandler_whenInitialize_isEqualSeriesUpdate() {
        // Given
        let seriesUpdate = Handler.series(.update)

        // When
        let sut = Handler(rawValue: "series.update")

        // Then
        XCTAssertEqual(sut, seriesUpdate)
    }

    func testHandler_whenInitialize_isEqualSeriesDelete() {
        // Given
        let seriesDelete = Handler.series(.delete)

        // When
        let sut = Handler(rawValue: "series.delete")

        // Then
        XCTAssertEqual(sut, seriesDelete)
    }

    func testHandler_whenInitialize_isEqualSeriesList() {
        // Given
        let seriesList = Handler.series(.list)

        // When
        let sut = Handler(rawValue: "series.list")

        // Then
        XCTAssertEqual(sut, seriesList)
    }

    // Raw value

    func testHandler_rawValue_isEqualSeriesCreate() {
        // Given
        let sut = Handler.series(.create)
        let rawValue = "series.create"

        // When

        // Then
        XCTAssertEqual(sut.rawValue, rawValue)
    }

    func testHandler_rawValue_isEqualSeriesRead() {
        // Given
        let sut = Handler.series(.read)
        let rawValue = "series.read"

        // When

        // Then
        XCTAssertEqual(sut.rawValue, rawValue)
    }

    func testHandler_rawValue_isEqualSeriesUpdate() {
        // Given
        let sut = Handler.series(.update)
        let rawValue = "series.update"

        // When

        // Then
        XCTAssertEqual(sut.rawValue, rawValue)
    }

    func testHandler_rawValue_isEqualSeriesDelete() {
        // Given
        let sut = Handler.series(.delete)
        let rawValue = "series.delete"

        // When

        // Then
        XCTAssertEqual(sut.rawValue, rawValue)
    }

    func testHandler_rawValue_isEqualSeriesList() {
        // Given
        let sut = Handler.series(.list)
        let rawValue = "series.list"

        // When

        // Then
        XCTAssertEqual(sut.rawValue, rawValue)
    }

}
