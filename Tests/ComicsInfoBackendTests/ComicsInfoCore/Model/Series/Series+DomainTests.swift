//
//  Series+DomainTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 15/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import struct ComicsInfoCore.Series
@testable import struct Domain.Series
@testable import struct Domain.ItemSummary
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
                ItemSummary(
                    identifier: "1",
                    popularity: 0,
                    name: "Character Name",
                    thumbnail: "Character thumbnail",
                    description: "Character Description",
                    count: nil,
                    number: nil,
                    roles: nil
                )
            ],
            comics: [
                ItemSummary(
                    identifier: "1",
                    popularity: 0,
                    name: "Comic Name",
                    thumbnail: "Comic thumbnail",
                    description: "Comic Description",
                    count: nil,
                    number: nil,
                    roles: nil
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
    
    func testCharacters_whenInitFromSeries_isEqualToSeriesCharacters() {
        XCTAssertEqual(
            sut.characters?.map { $0.itemID }.sorted(),
            domainSeries.characters?.map { "Series#\($0.identifier)" }.sorted()
        )
    }
    
    func testComics_whenInitFromSeries_isEqualToSeriesComics() {
        XCTAssertEqual(
            sut.comics?.map { $0.itemID }.sorted(),
            domainSeries.comics?.map { "Series#\($0.identifier)" }.sorted()
        )
    }
    
    func testItemID_whenInitFromSeries_isEqualToItemNameID() {
        XCTAssertEqual(sut.itemID, "\(sut.itemName)#\(domainSeries.identifier)")
    }
    
    func testSummaryID_whenInitFromCharacter_isEqualToItemNameID() {
        XCTAssertEqual(sut.summaryID, "\(sut.itemName)#\(domainSeries.identifier)")
    }
    
    func testItemName_whenInitFromCharacter_isEqualToComic() {
        XCTAssertEqual(sut.itemName, "Series")
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
