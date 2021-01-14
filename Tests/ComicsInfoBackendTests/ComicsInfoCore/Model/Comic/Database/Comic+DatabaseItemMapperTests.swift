//
//  Comic+DatabaseItemMapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 15/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class Comic_DatabaseItemMapperTests: XCTestCase {

    private var comicDatabase: ComicDatabase!
    private var sut: Comic!

    override func setUpWithError() throws {
        comicDatabase = ComicDatabase(
            itemID: "comic#1",
            summaryID: "comic#1",
            itemName: "comic",
            popularity: 0,
            title: "Title",
            dateAdded: Date(),
            dateLastUpdated: Date(),
            description: "Description",
            thumbnail: "Thumbnail",
            issueNumber: "IssueNumber",
            variantDescription: "VariantDescription",
            format: "Format",
            pageCount: 1,
            variantsIdentifier: ["VariantsIdentifier"],
            collectionsIdentifier: ["CollectionsIdentifier"],
            collectedIssuesIdentifier: ["CollectedIssuesIdentifier"],
            images: ["Images"],
            published: Date(),
            charactersSummary: [CharacterSummaryMock.characterSummary],
            seriesSummary: [SeriesSummaryMock.seriesSummary]
        )
        sut = Comic(from: comicDatabase)
    }

    override func tearDownWithError() throws {
        comicDatabase = nil
        sut = nil
    }

    func testID_whenInitFromComicDatabase_isEqualToComicDatabaseID() {
        XCTAssertEqual(sut.id, comicDatabase.id)
    }

    func testPopularity_whenInitFromComicDatabase_isEqualToComicDatabasePopularity() {
        XCTAssertEqual(sut.popularity, comicDatabase.popularity)
    }

    func testTitle_whenInitFromComicDatabase_isEqualToComicDatabaseTitle() {
        XCTAssertEqual(sut.title, comicDatabase.title)
    }
    
    func testDateAdded_whenInitFromComicDatabase_isEqualToComicDatabaseDateAdded() {
        XCTAssertEqual(sut.dateAdded, comicDatabase.dateAdded)
    }
    
    func testDateLastUpdated_whenInitFromComicDatabase_isEqualToComicDatabaseDateLastUpdated() {
        XCTAssertEqual(sut.dateLastUpdated, comicDatabase.dateLastUpdated)
    }

    func testThumbnail_whenInitFromComicDatabase_isEqualToComicDatabaseThumbnail() {
        XCTAssertEqual(sut.thumbnail, comicDatabase.thumbnail)
    }

    func testDescription_whenInitFromComicDatabase_isEqualToComicDatabaseDescription() {
        XCTAssertEqual(sut.description, comicDatabase.description)
    }

    func testIssueNumber_whenInitFromComicDatabase_isEqualToComicDatabaseIssueNumber() {
        XCTAssertEqual(sut.issueNumber, comicDatabase.issueNumber)
    }

    func testVariantDescription_whenInitFromComicDatabase_isEqualToComicDatabaseVariantDescription() {
        XCTAssertEqual(sut.variantDescription, comicDatabase.variantDescription)
    }

    func testFormat_whenInitFromComicDatabase_isEqualToComicDatabaseFormat() {
        XCTAssertEqual(sut.format, comicDatabase.format)
    }

    func testPageCount_whenInitFromComicDatabase_isEqualToComicDatabasePageCount() {
        XCTAssertEqual(sut.pageCount, comicDatabase.pageCount)
    }

    func testVariantsIdentifier_whenInitFromComicDatabase_isEqualToComicDatabaseVariantsIdentifier() {
        XCTAssertEqual(sut.variantsIdentifier, comicDatabase.variantsIdentifier)
    }

    func testCollectionsIdentifier_whenInitFromComicDatabase_isEqualToComicDatabaseCollectionsIdentifier() {
        XCTAssertEqual(sut.collectionsIdentifier, comicDatabase.collectionsIdentifier)
    }

    func testCollectedIssuesIdentifier_whenInitFromComicDatabase_isEqualToComicDatabaseCollectedIssuesIdentifier() {
        XCTAssertEqual(sut.collectedIssuesIdentifier, comicDatabase.collectedIssuesIdentifier)
    }

    func testImages_whenInitFromComicDatabase_isEqualToComicDatabaseImages() {
        XCTAssertEqual(sut.images, comicDatabase.images)
    }

    func testPublished_whenInitFromComicDatabase_isEqualToComicDatabasePublished() {
        XCTAssertEqual(sut.published, comicDatabase.published)
    }

    func testCharacters_whenInitFromComicDatabase_isEqualToComicDatabaseCharactersSummary() {
        XCTAssertEqual(sut.characters?.compactMap { $0.id }, comicDatabase.charactersSummary?.compactMap { $0.id })
    }

    func testSeries_whenInitFromComicDatabase_isEqualToComicDatabaseSeriesSummary() {
        XCTAssertEqual(sut.series?.compactMap { $0.id }, comicDatabase.seriesSummary?.compactMap { $0.id })
    }

}
