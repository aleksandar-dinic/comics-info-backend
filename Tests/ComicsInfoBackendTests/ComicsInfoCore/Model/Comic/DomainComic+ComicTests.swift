//
//  DomainComic+ComicTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 29/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import struct ComicsInfoCore.Comic
@testable import struct Domain.Comic
import XCTest

final class DomainComic_ComicTests: XCTestCase {

    private var givenComic: ComicsInfoCore.Comic!
    private var sut: Domain.Comic!

    override func setUpWithError() throws {
        givenComic = ComicMock.comic
        sut = Domain.Comic(from: givenComic)
    }

    override func tearDownWithError() throws {
        givenComic = nil
        sut = nil
    }
    
    func testIdentifier_whenInitFromComic_isEqualToComicID() {
        XCTAssertEqual(sut.identifier, givenComic.id)
    }

    func testPopularity_whenInitFromCharacter_isEqualToCharacterPopularity() {
        XCTAssertEqual(sut.popularity, givenComic.popularity)
    }

    func testTitle_whenInitFromComic_isEqualToComicName() {
        XCTAssertEqual(sut.title, givenComic.title)
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
    
    func testCharacters_whenInitFromComic_isEqualToComicCharacters() {
        XCTAssertEqual(
            sut.characters?.map({ "Character#\($0.identifier)" }).sorted(),
            givenComic.characters?.map({ $0.itemID }).sorted()
        )
    }
    
    func testSeries_whenInitFromComic_isEqualToComicSeries() {
        XCTAssertEqual(
            sut.series?.map({ "Series#\($0.identifier)" }).sorted(),
            givenComic.series?.map({ $0.itemID }).sorted()
        )
    }

}
