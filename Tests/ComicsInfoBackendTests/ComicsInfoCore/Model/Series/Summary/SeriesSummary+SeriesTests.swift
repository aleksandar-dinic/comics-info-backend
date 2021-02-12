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

    private var series: Series!
    private var character: Character!
    private var number: String!
    private var sut: SeriesSummary!
    
    override func setUpWithError() throws {
        series = SeriesFactory.make(ID: "SeriesID")
        character = CharacterFactory.make(ID: "CharacterID")
        number = "1"
        sut = SeriesSummary(series, link: character)
    }

    override func tearDownWithError() throws {
        series = nil
        character = nil
        number = nil
        sut = nil
    }
    
    func testItemID_whenInitFromSeries() throws {
        XCTAssertEqual(sut.itemID, "\(String.getType(from: Series.self))#\(series.id)")
    }
    
    func testSummaryID_whenInitFromSeries() {
        XCTAssertEqual(sut.summaryID, "\(String.getType(from: Character.self))#\(character.id)")
    }
    
    func testItemType_whenInitFromSeries() {
        XCTAssertEqual(sut.itemType, .getType(from: SeriesSummary.self))
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
