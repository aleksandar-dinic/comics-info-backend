//
//  Comic+DomainTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 14/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import struct ComicsInfoCore.Comic
@testable import struct Domain.Comic
@testable import struct Domain.CharacterSummary
@testable import struct Domain.SeriesSummary
import XCTest

final class Comic_DomainTests: XCTestCase {

    private var domainComic: Domain.Comic!
    private var sut: ComicsInfoCore.Comic!

    override func setUpWithError() throws {
        domainComic = Domain.Comic(
            identifier: "1",
            popularity: 0,
            title: "Comic Title",
            thumbnail: "Comic Thumbnail",
            description: "Comic Description",
            number: "1",
            aliases: ["Comic Aliases"],
            variantDescription: "variantDescription",
            format: "format",
            pageCount: 1,
            variantsIdentifier: ["variantsIdentifier"],
            collectionsIdentifier: ["collectionsIdentifier"],
            collectedIdentifiers: ["collectedIdentifiers"],
            images: ["images"],
            published: Date(),
            characters: [
                Domain.CharacterSummary(
                    identifier: "1",
                    popularity: 0,
                    name: "Character Name",
                    thumbnail: "Character thumbnail",
                    description: "Character Description",
                    count: nil
                )
            ],
            series: [
                Domain.SeriesSummary(
                    identifier: "1",
                    popularity: 0,
                    title: "Series Title",
                    thumbnail: "Series thumbnail",
                    description: "Series Description"
                )
            ]
        )
        sut = ComicsInfoCore.Comic(from: domainComic)
    }

    override func tearDownWithError() throws {
        domainComic = nil
        sut = nil
    }
    
    func testId_whenInitFromComic_isEqualToComicIdentifier() {
        XCTAssertEqual(sut.id, domainComic.identifier)
    }

    func testPopularity_whenInitFromCharacter_isEqualToCharacterPopularity() {
        XCTAssertEqual(sut.popularity, domainComic.popularity)
    }

    func testTitle_whenInitFromComic_isEqualToComicName() {
        XCTAssertEqual(sut.title, domainComic.title)
    }

    func testThumbnail_whenInitFromComic_isEqualToComicThumbnail() {
        XCTAssertEqual(sut.thumbnail, domainComic.thumbnail)
    }

    func testDescription_whenInitFromComic_isEqualToComicDescription() {
        XCTAssertEqual(sut.description, domainComic.description)
    }

    func testNumber_whenInitFromComic_isEqualToComicNumber() {
        XCTAssertEqual(sut.number, domainComic.number)
    }
    
    func testAliases_whenInitFromComic_isEqualToComicAliases() {
        XCTAssertEqual(sut.aliases, domainComic.aliases)
    }

    func testVariantDescription_whenInitFromComic_isEqualToComicVariantDescription() {
        XCTAssertEqual(sut.variantDescription, domainComic.variantDescription)
    }

    func testFormat_whenInitFromComic_isEqualToComicFormat() {
        XCTAssertEqual(sut.format, domainComic.format)
    }

    func testPageCount_whenInitFromComic_isEqualToComicPageCount() {
        XCTAssertEqual(sut.pageCount, domainComic.pageCount)
    }

    func testVariantsIdentifier_whenInitFromComic_isEqualToComicVariantsIdentifier() {
        XCTAssertEqual(sut.variantsIdentifier, domainComic.variantsIdentifier)
    }

    func testCollectionsIdentifier_whenInitFromComic_isEqualToComicCollectionsIdentifier() {
        XCTAssertEqual(sut.collectionsIdentifier, domainComic.collectionsIdentifier)
    }

    func testCollectedIdentifiers_whenInitFromComic_isEqualToComicCollectedIdentifiers() {
        XCTAssertEqual(sut.collectedIdentifiers, domainComic.collectedIdentifiers)
    }

    func testImages_whenInitFromComic_isEqualToComicImages() {
        XCTAssertEqual(sut.images, domainComic.images)
    }

    func testPublished_whenInitFromComic_isEqualToComicPublished() {
        XCTAssertEqual(sut.published, domainComic.published)
    }
    
    func testCharacters_whenInitFromComic_isNil() {
        XCTAssertNil(sut.characters)
    }
    
    func testSeries_whenInitFromComic_isNil() {
        XCTAssertNil(sut.series)
    }

    func testItemID_whenInitFromComic_isEqualToItemTypeID() {
        XCTAssertEqual(sut.itemID, "\(sut.itemType)#\(domainComic.identifier)")
    }
    
    func testItemType_whenInitFromComic_isEqualToComic() {
        XCTAssertEqual(sut.itemType, "Comic")
    }
    
    func testCharacters_whenInitFromComicWitmEmptyCharacters_charactersIsNil() {
        domainComic = Domain.Comic(
            identifier: "1",
            popularity: 0,
            title: "Comic Title",
            thumbnail: "Comic Thumbnail",
            description: "Comic Description",
            number: "1",
            aliases: ["Comic Aliases"],
            variantDescription: "variantDescription",
            format: "format",
            pageCount: 1,
            variantsIdentifier: ["variantsIdentifier"],
            collectionsIdentifier: ["collectionsIdentifier"],
            collectedIdentifiers: ["collectedIdentifiers"],
            images: ["images"],
            published: Date(),
            characters: [],
            series: []
        )
        sut = ComicsInfoCore.Comic(from: domainComic)
        XCTAssertNil(sut.characters)
    }
    
    func testSeries_whenInitFromComicWitmEmptySeries_seriesIsNil() {
        domainComic = Domain.Comic(
            identifier: "1",
            popularity: 0,
            title: "Comic Title",
            thumbnail: "Comic Thumbnail",
            description: "Comic Description",
            number: "1",
            aliases: ["Comic Aliases"],
            variantDescription: "variantDescription",
            format: "format",
            pageCount: 1,
            variantsIdentifier: ["variantsIdentifier"],
            collectionsIdentifier: ["collectionsIdentifier"],
            collectedIdentifiers: ["collectedIdentifiers"],
            images: ["images"],
            published: Date(),
            characters: [],
            series: []
        )
        sut = ComicsInfoCore.Comic(from: domainComic)
        XCTAssertNil(sut.series)
    }

}
