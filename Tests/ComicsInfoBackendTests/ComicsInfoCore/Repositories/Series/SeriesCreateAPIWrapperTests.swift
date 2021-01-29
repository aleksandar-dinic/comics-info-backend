//
//  SeriesCreateAPIWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class SeriesCreateAPIWrapperTests: XCTestCase, CreateCharacterProtocol, CreateComicProtocol {

    private var sut: SeriesCreateAPIWrapper!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        sut = SeriesCreateAPIWrapperMock.make(items: [:])
        table = String.tableName(for: "TEST")
    }

    override func tearDownWithError() throws {
        sut = nil
        table = nil
    }

    // MARK: - Create

    func testCrateSeries_seriesIsCreated() throws {
        // Given

        // When
        let feature = sut.create(SeriesMock.makeSeries(), in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }

    func testCreate_whenSeriesExist_throwsItemAlreadyExists() throws {
        // Given
        var feature = sut.create(SeriesMock.makeSeries(), in: table)
        try feature.wait()
        var thrownError: Error?

        // When
        feature = sut.create(SeriesMock.makeSeries(), in: table)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemAlreadyExists(let itemID, let itemType) = error as? APIError {
            XCTAssertEqual(itemID, "1")
            XCTAssertTrue(itemType == Series.self)
        } else {
            XCTFail("Expected '.itemAlreadyExists' but got \(error)")
        }
    }

}
