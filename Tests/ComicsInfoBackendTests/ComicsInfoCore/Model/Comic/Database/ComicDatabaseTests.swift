//
//  ComicDatabaseTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 15/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class ComicDatabaseTests: XCTestCase {

    private var givenComic: Comic!
    private var sut: ComicDatabase!

    override func setUpWithError() throws {
        givenComic = ComicMock.comic
        sut = ComicDatabase(item: givenComic)
    }

    override func tearDownWithError() throws {
        givenComic = nil
        sut = nil
    }

    func testID() {
        XCTAssertEqual(sut.id, "1")
    }

    func testItemID_whenInitFromComic_isEqualToItemID() {
        XCTAssertEqual(sut.itemID, "comic#1")
    }

    func testSummaryID_whenInitFromComic_isEqualToSummaryID() {
        XCTAssertEqual(sut.summaryID, "comic#1")
    }

    func testItemName_whenInitFromComic_isEqualToItemName() {
        XCTAssertEqual(sut.itemName, "comic")
    }

    func testGetCharactersSummaryID_whenInitFromComic_isEqualToCharactersID() {
        XCTAssertEqual(sut.getCharactersID(), ["2", "3", "4"])
    }

    func testGetCharactersSummaryID_whenInitFromComic_charactersIDIsNil() {
        // Given
        givenComic = ComicMock.makeComic()

        // When
        sut = ComicDatabase(item: givenComic)

        // Then
        XCTAssertNil(sut.getCharactersID())
    }

    func testGetSeriesSummaryID_whenInitFromComic_isEqualToSeriesID() {
        XCTAssertEqual(sut.getSeriesID(), ["2", "3", "4"])
    }

    func testGetSeriesSummaryID_whenInitFromComic_seriesIDIsNil() {
        // Given
        givenComic = ComicMock.makeComic()

        // When
        sut = ComicDatabase(item: givenComic)

        // Then
        XCTAssertNil(sut.getSeriesID())
    }

    func testID_whenInitFromComic_isEqualToComicID() {
        XCTAssertEqual(sut.id, givenComic.id)
    }

    func testPopularity_whenInitFromComic_isEqualToComicPopularity() {
        XCTAssertEqual(sut.popularity, givenComic.popularity)
    }

    func testTitle_whenInitFromComic_isEqualToComicTitle() {
        XCTAssertEqual(sut.title, givenComic.title)
    }
    
    func testDateAdded_whenInitFromComic_isEqualToComicDateAdded() {
        XCTAssertEqual(sut.dateAdded, givenComic.dateAdded)
    }
    
    func testDateLastUpdated_whenInitFromComic_isEqualToComicDateLastUpdated() {
        XCTAssertEqual(sut.dateLastUpdated, givenComic.dateLastUpdated)
    }

    func testThumbnail_whenInitFromComic_isEqualToComicThumbnail() {
        XCTAssertEqual(sut.thumbnail, givenComic.thumbnail)
    }

    func testDescription_whenInitFromComic_isEqualToComicDescription() {
        XCTAssertEqual(sut.description, givenComic.description)
    }

    func testNumber_whenInitFromComic_isEqualToComicNumber() {
        XCTAssertEqual(sut.number, givenComic.number)
    }
    
    func testAliases_whenInitFromComic_isEqualToComicAliases() {
        XCTAssertEqual(sut.aliases, givenComic.aliases)
    }

    func testVariantDescription_whenInitFromComic_isEqualToComicVariantDescription() {
        XCTAssertEqual(sut.variantDescription, givenComic.variantDescription)
    }

    func testFormat_whenInitFromComic_isEqualToComicFormat() {
        XCTAssertEqual(sut.format, givenComic.format)
    }

    func testPageCount_whenInitFromComic_isEqualToComicPageCount() {
        XCTAssertEqual(sut.pageCount, givenComic.pageCount)
    }

    func testVariantsIdentifier_whenInitFromComic_isEqualToComicVariantsIdentifier() {
        XCTAssertEqual(sut.variantsIdentifier, givenComic.variantsIdentifier)
    }

    func testCollectionsIdentifier_whenInitFromComic_isEqualToComicCollectionsIdentifier() {
        XCTAssertEqual(sut.collectionsIdentifier, givenComic.collectionsIdentifier)
    }

    func testCollectedIdentifiers_whenInitFromComic_isEqualToComicCollectedIdentifiers() {
        XCTAssertEqual(sut.collectedIdentifiers, givenComic.collectedIdentifiers)
    }

    func testImages_whenInitFromComic_isEqualToComicImages() {
        XCTAssertEqual(sut.images, givenComic.images)
    }

    func testPublished_whenInitFromComic_isEqualToComicPublished() {
        XCTAssertEqual(sut.published, givenComic.published)
    }

    func testCharacters_whenInitFromComic_isEqualToComicCharactersSummary() {
        XCTAssertEqual(sut.charactersSummary?.compactMap { $0.id }, givenComic.characters?.compactMap { $0.id })
    }

    func testSeries_whenInitFromComic_isEqualToComicSeriesSummary() {
        XCTAssertEqual(sut.seriesSummary?.compactMap { $0.id }, givenComic.series?.compactMap { $0.id })
    }

}
