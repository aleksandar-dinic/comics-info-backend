//
//  Series+DatabaseItemMapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 15/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class Series_DatabaseItemMapperTests: XCTestCase {

    private var seriesDatabase: SeriesDatabase!
    private var sut: Series!

    override func setUpWithError() throws {
        seriesDatabase = SeriesDatabase(
            tableName: "series",
            itemID: "series#1",
            summaryID: "series#1",
            itemName: "series",
            popularity: 0,
            title: "Title",
            description: "Description",
            thumbnail: "Thumbnail",
            startYear: 1,
            endYear: 2,
            nextIdentifier: "Next Identifier",
            charactersSummary: [CharacterSummaryMock.characterSummary],
            comicsSummary: [ComicSummaryMock.comicSummary]
        )
        sut = Series(from: seriesDatabase)
    }

    override func tearDownWithError() throws {
        seriesDatabase = nil
        sut = nil
    }

    func testID_whenInitFromSeriesDatabase_isEqualToSeriesDatabaseID() {
        XCTAssertEqual(sut.id, seriesDatabase.id)
    }

    func testPopularity_whenInitFromSeriesDatabase_isEqualToSeriesDatabasePopularity() {
        XCTAssertEqual(sut.popularity, seriesDatabase.popularity)
    }

    func testTitle_whenInitFromSeriesDatabase_isEqualToSeriesDatabaseTitle() {
        XCTAssertEqual(sut.title, seriesDatabase.title)
    }

    func testThumbnail_whenInitFromSeriesDatabase_isEqualToSeriesDatabaseThumbnail() {
        XCTAssertEqual(sut.thumbnail, seriesDatabase.thumbnail)
    }

    func testDescription_whenInitFromSeriesDatabase_isEqualToSeriesDatabaseDescription() {
        XCTAssertEqual(sut.description, seriesDatabase.description)
    }

    func testStartYear_whenInitFromSeriesDatabase_isEqualToSeriesDatabaseStartYear() {
        XCTAssertEqual(sut.startYear, seriesDatabase.startYear)
    }

    func testEndYear_whenInitFromSeriesDatabase_isEqualToSeriesDatabaseEndYear() {
        XCTAssertEqual(sut.endYear, seriesDatabase.endYear)
    }

    func testNextIdentifier_whenInitFromSeriesDatabase_isEqualToSeriesDatabaseNextIdentifier() {
        XCTAssertEqual(sut.nextIdentifier, seriesDatabase.nextIdentifier)
    }

    func testCharacters_whenInitFromSeriesDatabase_isEqualToSeriesDatabaseCharactersSummary() {
        XCTAssertEqual(sut.characters?.compactMap { $0.id }, seriesDatabase.charactersSummary?.compactMap { $0.id })
    }

    func testComics_whenInitFromSeriesDatabase_isEqualToSeriesDatabaseComicsSummary() {
        XCTAssertEqual(sut.comics?.compactMap { $0.id }, seriesDatabase.comicsSummary?.compactMap { $0.id })
    }

}
