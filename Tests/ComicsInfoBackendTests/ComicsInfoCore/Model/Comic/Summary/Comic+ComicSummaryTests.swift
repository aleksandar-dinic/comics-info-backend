//
//  Comic+ComicSummaryTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 15/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class Comic_ComicSummaryTests: XCTestCase {

    private var comicSummary: ComicSummary!
    private var sut: Comic!

    override func setUpWithError() throws {
        comicSummary = ComicSummaryMock.comicSummary
        sut = Comic(fromSummary: comicSummary)
    }

    override func tearDownWithError() throws {
        comicSummary = nil
        sut = nil
    }

    func testID_whenInitFromComicSummary_isEqualToComicSummaryID() {
        XCTAssertEqual(sut.id, comicSummary.id)
    }

    func testPopularity_whenInitFromComicSummary_isEqualToComicSummaryPopularity() {
        XCTAssertEqual(sut.popularity, comicSummary.popularity)
    }

    func testTitle_whenInitFromComicSummary_isEqualToComicSummaryTitle() {
        XCTAssertEqual(sut.title, comicSummary.title)
    }
    
    func testDateAdded_whenInitFromComicSummary_isEqualToComicSummaryDateAdded() {
        XCTAssertEqual(sut.dateAdded, comicSummary.dateAdded)
    }
    
    func testDateLastUpdated_whenInitFromComicSummary_isEqualToComicSummaryDateLastUpdated() {
        XCTAssertEqual(sut.dateLastUpdated, comicSummary.dateLastUpdated)
    }

    func testThumbnail_whenInitFromComicSummary_isEqualToComicSummaryThumbnail() {
        XCTAssertEqual(sut.thumbnail, comicSummary.thumbnail)
    }

    func testDescription_whenInitFromComicSummary_isEqualToComicSummaryDescription() {
        XCTAssertEqual(sut.description, comicSummary.description)
    }

    func testIssueNumber_whenInitFromComicSummary_isNil() {
        XCTAssertNil(sut.issueNumber)
    }

    func testVariantDescription_whenInitFromComicSummary_isNil() {
        XCTAssertNil(sut.variantDescription)
    }

    func testFormat_whenInitFromComicSummary_isNil() {
        XCTAssertNil(sut.format)
    }

    func testPageCount_whenInitFromComicSummary_isNil() {
        XCTAssertNil(sut.pageCount)
    }

    func testVariantsIdentifier_whenInitFromComicSummary_isNil() {
        XCTAssertNil(sut.variantsIdentifier)
    }

    func testCollectionsIdentifier_whenInitFromComicSummary_isNil() {
        XCTAssertNil(sut.collectionsIdentifier)
    }

    func testCollectedIssuesIdentifier_whenInitFromComicSummary_isNil() {
        XCTAssertNil(sut.collectedIssuesIdentifier)
    }

    func testImages_whenInitFromComicSummary_isNil() {
        XCTAssertNil(sut.images)
    }

    func testPublished_whenInitFromComicSummary_isNil() {
        XCTAssertNil(sut.published)
    }

    func testCharactersID_whenInitFromComicSummary_isNil() {
        XCTAssertNil(sut.charactersID)
    }

    func testCharacters_whenInitFromComicSummary_isNil() {
        XCTAssertNil(sut.characters)
    }

    func testSeriesID_whenInitFromComicSummary_isNil() {
        XCTAssertNil(sut.seriesID)
    }

    func testSeries_whenInitFromComicSummary_isNil() {
        XCTAssertNil(sut.series)
    }

}
