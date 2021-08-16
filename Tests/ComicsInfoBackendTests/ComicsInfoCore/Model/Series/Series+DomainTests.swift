//
//  Series+DomainTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 15/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import struct ComicsInfoCore.Series
@testable import struct Domain.Series
@testable import struct Domain.CharacterSummary
@testable import struct Domain.ComicSummary
import XCTest

final class Series_DomainTests: XCTestCase {

    private var domainSeries: Domain.Series!
    private var sut: ComicsInfoCore.Series!

    override func setUpWithError() throws {
        domainSeries = Domain.Series(
            identifier: "1",
            popularity: 0,
            title: "Series Title",
            thumbnail: "Series Thumbnail",
            description: "Series Description",
            startYear: 1,
            endYear: 2,
            aliases: ["Series Aliases"],
            nextIdentifier: "nextIdentifier",
            characters: [
                Domain.CharacterSummary(
                    identifier: "1",
                    popularity: 0,
                    name: "Character Name",
                    thumbnail: "Character thumbnail",
                    description: "Character Description",
                    count: 2
                )
            ],
            comics: [
                Domain.ComicSummary(
                    identifier: "1",
                    popularity: 0,
                    title: "Comic Title",
                    thumbnail: "Comic thumbnail",
                    description: "Comic Description",
                    number: "Comic Number",
                    published: Date()
                )
            ]
        )
        sut = ComicsInfoCore.Series(from: domainSeries)
    }

    override func tearDownWithError() throws {
        domainSeries = nil
        sut = nil
    }
    
    func testId_whenInitFromSeries_isEqualToSeriesIdentifier() {
        XCTAssertEqual(sut.id, domainSeries.identifier)
    }

    func testPopularity_whenInitFromCharacter_isEqualToCharacterPopularity() {
        XCTAssertEqual(sut.popularity, domainSeries.popularity)
    }

    func testTitle_whenInitFromSeries_isEqualToSeriesName() {
        XCTAssertEqual(sut.title, domainSeries.title)
    }

    func testThumbnail_whenInitFromSeries_isEqualToSeriesThumbnail() {
        XCTAssertEqual(sut.thumbnail, domainSeries.thumbnail)
    }

    func testDescription_whenInitFromSeries_isEqualToSeriesDescription() {
        XCTAssertEqual(sut.description, domainSeries.description)
    }

    func testStartYear_whenInitFromSeries_isEqualToSeriesStartYear() {
        XCTAssertEqual(sut.startYear, domainSeries.startYear)
    }

    func testEndYear_whenInitFromSeries_isEqualToSeriesEndYear() {
        XCTAssertEqual(sut.endYear, domainSeries.endYear)
    }
    
    func testAliases_whenInitFromSeries_isEqualToSeriesAliases() {
        XCTAssertEqual(sut.aliases, domainSeries.aliases)
    }

    func testNextIdentifier_whenInitFromSeries_isEqualToSeriesNextIdentifier() {
        XCTAssertEqual(sut.nextIdentifier, domainSeries.nextIdentifier)
    }
    
    func testCharacters_whenInitFromSeries_isNil() {
        XCTAssertNil(sut.characters)
    }
    
    func testComics_whenInitFromSeries_isNil() {
        XCTAssertNil(sut.comics)
    }
    
    func testItemID_whenInitFromSeries_isEqualToItemTypeID() {
        XCTAssertEqual(sut.itemID, "\(sut.itemType)#\(domainSeries.identifier)")
    }
    
    func testItemType_whenInitFromCharacter_isEqualToComic() {
        XCTAssertEqual(sut.itemType, "Series")
    }
    
    func testCharacters_whenInitFromSeriesWitmEmptyCharacters_charactersIsNil() {
        domainSeries = Domain.Series(
            identifier: "1",
            popularity: 0,
            title: "Series Title",
            thumbnail: "Series Thumbnail",
            description: "Series Description",
            startYear: 1,
            endYear: 2,
            aliases: ["Series Aliases"],
            nextIdentifier: "nextIdentifier",
            characters: [],
            comics: []
        )
        sut = Series(from: domainSeries)
        XCTAssertNil(sut.characters)
    }
    
    func testComics_whenInitFromSeriesWitmEmptyComics_comicsIsNil() {
        domainSeries = Domain.Series(
            identifier: "1",
            popularity: 0,
            title: "Series Title",
            thumbnail: "Series Thumbnail",
            description: "Series Description",
            startYear: 1,
            endYear: 2,
            aliases: ["Series Aliases"],
            nextIdentifier: "nextIdentifier",
            characters: [],
            comics: []
        )
        sut = Series(from: domainSeries)
        XCTAssertNil(sut.comics)
    }

}
