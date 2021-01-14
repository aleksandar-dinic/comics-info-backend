//
//  Series+SeriesSummaryTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 15/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class Series_SeriesSummaryTests: XCTestCase {

    private var seriesSummary: SeriesSummary!
    private var sut: Series!

    override func setUpWithError() throws {
        seriesSummary = SeriesSummaryMock.seriesSummary
        sut = Series(fromSummary: seriesSummary)
    }

    override func tearDownWithError() throws {
        seriesSummary = nil
        sut = nil
    }

    func testID_whenInitFromSeriesSummary_isEqualToSeriesSummaryID() {
        XCTAssertEqual(sut.id, seriesSummary.id)
    }

    func testPopularity_whenInitFromSeriesSummary_isEqualToSeriesSummaryPopularity() {
        XCTAssertEqual(sut.popularity, seriesSummary.popularity)
    }

    func testTitle_whenInitFromSeriesSummary_isEqualToSeriesSummaryTitle() {
        XCTAssertEqual(sut.title, seriesSummary.title)
    }
    
    func testDateAdded_whenInitFromSeriesSummary_isEqualToSeriesSummaryDateAdded() {
        XCTAssertEqual(sut.dateAdded, seriesSummary.dateAdded)
    }
    
    func testDateLastUpdated_whenInitFromSeriesSummary_isEqualToSeriesSummaryDateLastUpdated() {
        XCTAssertEqual(sut.dateLastUpdated, seriesSummary.dateLastUpdated)
    }

    func testThumbnail_whenInitFromSeriesSummary_isEqualToSeriesSummaryThumbnail() {
        XCTAssertEqual(sut.thumbnail, seriesSummary.thumbnail)
    }

    func testDescription_whenInitFromSeriesSummary_isEqualToSeriesSummaryDescription() {
        XCTAssertEqual(sut.description, seriesSummary.description)
    }

    func testStartYear_whenInitFromSeriesSummary_isNil() {
        XCTAssertNil(sut.startYear)
    }

    func testEndYear_whenInitFromSeriesSummary_isNil() {
        XCTAssertNil(sut.endYear)
    }

    func testNextIdentifier_whenInitFromSeriesSummary_isNil() {
        XCTAssertNil(sut.nextIdentifier)
    }

    func testCharactersID_whenInitFromSeriesSummary_isNil() {
        XCTAssertNil(sut.charactersID)
    }

    func testCharacter_whenInitFromSeriesSummary_isNil() {
        XCTAssertNil(sut.characters)
    }

    func testComicsID_whenInitFromSeriesSummary_isNil() {
        XCTAssertNil(sut.comicsID)
    }

    func testComics_whenInitFromSeriesSummary_isNil() {
        XCTAssertNil(sut.comics)
    }

}
