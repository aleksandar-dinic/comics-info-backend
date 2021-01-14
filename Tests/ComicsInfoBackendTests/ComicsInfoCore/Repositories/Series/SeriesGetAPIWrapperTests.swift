//
//  SeriesGetAPIWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class SeriesGetAPIWrapperTests: XCTestCase, CreateSeriesProtocol {

    private var sut: SeriesGetAPIWrapper!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        sut = SeriesGetAPIWrapperMock.make(items: [:])
        table = String.tableName(for: "TEST")
    }

    override func tearDownWithError() throws {
        sut = nil
        table = nil
    }

    func test_whenGetItem_returnsItem() throws {
        let givenItem = SeriesMock.makeSeries()
        try createSeries(givenItem)

        // When
        let feature = sut.get(withID: givenItem.id, from: table)
        let item = try feature.wait()

        // Then
        XCTAssertEqual(item.id, givenItem.id)
    }

    func test_whenGetItemWithNotExistingID_throwsItemNotFound() throws {
        let givenItemID = "-1"
        var thrownError: Error?

        // When
        let feature = sut.get(withID: givenItemID, from: table)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemNotFound(let itemID, let itemType) = error as? APIError {
            XCTAssertEqual(itemID, "series#\(givenItemID)")
            XCTAssertTrue(itemType == Series.self)
        } else {
            XCTFail("Expected '.itemNotFound' but got \(error)")
        }
    }

}
