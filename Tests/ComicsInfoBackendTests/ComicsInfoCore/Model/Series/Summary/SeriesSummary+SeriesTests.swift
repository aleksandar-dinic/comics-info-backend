//
//  SeriesSummary+SeriesTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class SeriesSummary_SeriesTests: XCTestCase {

    private typealias Item = Character
    
    private var series: Series!
    private var id: String!
    private var number: String!
    private var sut: SeriesSummary<Item>!
    
    override func setUpWithError() throws {
        series = SeriesFactory.make()
        id = "1"
        number = "1"
        sut = SeriesSummary<Item>(series, id: id)
    }

    override func tearDownWithError() throws {
        series = nil
        id = nil
        number = nil
        sut = nil
    }
    
    func testItemID_whenInitFromSeries() throws {
        let id = try XCTUnwrap(self.id)
        XCTAssertEqual(sut.itemID, "\(String.getType(from: Series.self))#\(id)")
    }
    
    func testSummaryID_whenInitFromSeries() {
        XCTAssertEqual(sut.summaryID, "\(String.getType(from: Item.self))#\(series.id)")
    }
    
    func testItemName_whenInitFromSeries() {
        XCTAssertEqual(sut.itemName, .getType(from: SeriesSummary<Item>.self))
    }
    
    func testDateAdded_whenInitFromSeries() {
        XCTAssertEqual(
            Calendar.current.compare(sut.dateAdded, to: Date(), toGranularity: .hour),
            .orderedSame
        )
    }
    
    func testDateLastUpdated_whenInitFromSeries() {
        XCTAssertEqual(
            Calendar.current.compare(sut.dateLastUpdated, to: Date(), toGranularity: .hour),
            .orderedSame
        )
    }
    
    func testPopularity_whenInitFromSeries() {
        XCTAssertEqual(sut.popularity, series.popularity)
    }
    
    func testName_whenInitFromSeries() {
        XCTAssertEqual(sut.name, series.name)
    }
    
    func testThumbnail_whenInitFromSeries() {
        XCTAssertEqual(sut.thumbnail, series.thumbnail)
    }
    
    func testDescription_whenInitFromSeries() {
        XCTAssertEqual(sut.description, series.description)
    }
    
}
