//
//  SeriesRepositoryAPIWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 22/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class SeriesRepositoryAPIWrapperTests: XCTestCase, CreateSeriesProtocol {

    private var sut: SeriesRepositoryAPIWrapper!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        sut = SeriesRepositoryAPIWrapperMock.make()
        table = String.tableName(for: "TEST")
    }

    override func tearDownWithError() throws {
        sut = nil
        table = nil
    }

    func test_whenGetMetadata_isEqualToGivenMetadata() throws {
        // Given
        let givenSeries = SeriesMock.makeSeries()
        try createSeries(givenSeries)

        // When
        let feature = sut.getMetadata(id: givenSeries.id, from: table)
        let series = try feature.wait()

        // Then
        XCTAssertEqual(series.id, givenSeries.id)
    }

    func test_whenGetMetadataNotExisting_throwsItemNotFound() throws {
        // Given
        let givenSeries = SeriesMock.makeSeries()
        var thrownError: Error?

        // When
        let feature = sut.getMetadata(id: givenSeries.id, from: table)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemNotFound(let itemID, let itemType) = error as? APIError {
            XCTAssertEqual(itemID, "series#\(givenSeries.id)")
            XCTAssertTrue(itemType == Series.self)
        } else {
            XCTFail("Expected '.itemNotFound' but got \(error)")
        }
    }

}
