//
//  SeriesDatabaseTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 15/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class SeriesDatabaseTests: XCTestCase {

    private var givenSeries: Series!
    private var sut: SeriesDatabase!

    override func setUpWithError() throws {
        givenSeries = SeriesMock.series
        sut = SeriesDatabase(item: givenSeries)
    }

    override func tearDownWithError() throws {
        givenSeries = nil
        sut = nil
    }

    func testID() {
        XCTAssertEqual(sut.id, "1")
    }

    func testItemID_whenInitFromSeries_isEqualToItemID() {
        XCTAssertEqual(sut.itemID, "series#1")
    }

    func testSummaryID_whenInitFromSeries_isEqualToSummaryID() {
        XCTAssertEqual(sut.summaryID, "series#1")
    }

    func testItemName_whenInitFromSeries_isEqualToItemName() {
        XCTAssertEqual(sut.itemName, "series")
    }

    func testGetCharactersSummaryID_whenInitFromSeries_isEqualToCharactersID() {
        XCTAssertEqual(sut.getCharactersID(), ["2", "3", "4"])
    }

    func testGetCharactersSummaryID_whenInitFromSeries_seriesIDIsNil() {
        // Given
        givenSeries = SeriesMock.makeSeries()

        // When
        sut = SeriesDatabase(item: givenSeries)

        // Then
        XCTAssertNil(sut.getCharactersID())
    }

    func testGetComicsSummaryID_whenInitFromSeries_isEqualToComicsID() {
        XCTAssertEqual(sut.getComicsID(), ["2", "3", "4"])
    }

    func testGetComicsSummaryID_whenInitFromSeries_comicsIDIsNil() {
        // Given
        givenSeries = SeriesMock.makeSeries()

        // When
        sut = SeriesDatabase(item: givenSeries)

        // Then
        XCTAssertNil(sut.getComicsID())
    }

    func testID_whenInitFromSeries_isEqualToSeriesID() {
        XCTAssertEqual(sut.id, givenSeries.id)
    }

    func testPopularity_whenInitFromSeries_isEqualToSeriesPopularity() {
        XCTAssertEqual(sut.popularity, givenSeries.popularity)
    }

    func testTitle_whenInitFromSeries_isEqualToSeriesTitle() {
        XCTAssertEqual(sut.title, givenSeries.title)
    }

    func testThumbnail_whenInitFromSeries_isEqualToSeriesThumbnail() {
        XCTAssertEqual(sut.thumbnail, givenSeries.thumbnail)
    }

    func testDescription_whenInitFromSeries_isEqualToSeriesDescription() {
        XCTAssertEqual(sut.description, givenSeries.description)
    }

    func testStartYear_whenInitFromSeries_isEqualToSeriesStartYear() {
        XCTAssertEqual(sut.startYear, givenSeries.startYear)
    }

    func testEndYear_whenInitFromSeries_isEqualToSeriesEndYear() {
        XCTAssertEqual(sut.endYear, givenSeries.endYear)
    }

    func testNextIdentifier_whenInitFromSeries_isEqualToSeriesNextIdentifier() {
        XCTAssertEqual(sut.nextIdentifier, givenSeries.nextIdentifier)
    }

    func testSeries_whenInitFromSeries_isEqualToSeriesSeriesSummary() {
        XCTAssertEqual(sut.charactersSummary?.compactMap { $0.id }, givenSeries.characters?.compactMap { $0.id })
    }

    func testComics_whenInitFromSeries_isEqualToSeriesComicsSummary() {
        XCTAssertEqual(sut.comicsSummary?.compactMap { $0.id }, givenSeries.comics?.compactMap { $0.id })
    }

}
