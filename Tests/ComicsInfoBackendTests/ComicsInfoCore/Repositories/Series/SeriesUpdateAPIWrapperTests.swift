//
//  SeriesUpdateAPIWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 22/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class SeriesUpdateAPIWrapperTests: XCTestCase, CreateCharacterProtocol, CreateSeriesProtocol, CreateComicProtocol {

    private var sut: SeriesUpdateAPIWrapper!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        sut = SeriesUpdateAPIWrapperMock.make(items: [:])
        table = String.tableName(for: "TEST")
    }

    override func tearDownWithError() throws {
        sut = nil
        table = nil
    }

    func test_whenUpdateSeries_seriesIsUpdated() throws {
        // Given
        try createSeries(SeriesMock.makeSeries(title: "Old Title"))

        // When
        let feature = sut.update(SeriesMock.makeSeries(), in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }

}
