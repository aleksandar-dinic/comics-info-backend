//
//  SeriesSummaryInitWithSeriesTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 15/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class SeriesSummaryInitWithSeriesTests: XCTestCase {

    private var series: Series!
    private var itemName: String!
    private var summaryName: String!
    private var id: String!
    private var sut: SeriesSummary!

    override func setUpWithError() throws {
        series = SeriesMock.series
        itemName = "character"
        summaryName = "series"
        id = "2"
        sut = SeriesSummary(series, id: id, itemName: itemName)
    }

    override func tearDownWithError() throws {
        series = nil
        itemName = nil
        id = nil
        sut = nil
    }

    func testID_whenInitWithSeries_isEqualToSeriesID() {
        XCTAssertEqual(sut.id, series.id)
    }

    func testPopularity_whenInitWithSeries_isEqualToSeriesPopularity() {
        XCTAssertEqual(sut.popularity, series.popularity)
    }

    func testTitle_whenInitWithSeries_isEqualToSeriesTitle() {
        XCTAssertEqual(sut.title, series.title)
    }
    
    func testDateAdded_whenInitWithSeries_isEqualToSeriesDateAdded() {
        XCTAssertNotEqual(sut.dateAdded, series.dateAdded)
    }
    
    func testDateLastUpdated_whenInitWithSeries_isEqualToSeriesDateLastUpdated() {
        XCTAssertNotEqual(sut.dateLastUpdated, series.dateLastUpdated)
    }

    func testThumbnail_whenInitWithSeries_isEqualToSeriesThumbnail() {
        XCTAssertEqual(sut.thumbnail, series.thumbnail)
    }

    func testDescription_whenInitWithSeries_isEqualToSeriesDescription() {
        XCTAssertEqual(sut.description, series.description)
    }

    func testItemName_whenInitWithSeries_isEqualToItemName() {
        XCTAssertEqual(sut.itemName, itemName)
    }
    
    func testSummaryName_whenInitWithSeries_isEqualToSummaryName() {
        XCTAssertEqual(sut.summaryName, summaryName)
    }

    func testItemID_whenInitWithSeries_isEqualToItemID() throws {
        let itemName = try XCTUnwrap(self.itemName)
        let id = try XCTUnwrap(self.id)
        XCTAssertEqual(sut.itemID, "\(itemName)#\(id)")
    }

    func testSummaryID_whenInitWithSeries_isEqualToSummaryID() {
        XCTAssertEqual(sut.summaryID, "series#\(series.id)")
    }

}
