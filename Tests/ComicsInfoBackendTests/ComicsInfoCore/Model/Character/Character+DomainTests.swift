//
//  Character+DomainTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 12/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import struct ComicsInfoCore.Character
@testable import struct Domain.Character
@testable import struct Domain.ItemSummary
import XCTest

final class Character_DomainTests: XCTestCase {

    private var domainCharacter: Domain.Character!
    private var sut: ComicsInfoCore.Character!
    
    override func setUpWithError() throws {
        domainCharacter = Domain.Character(
            identifier: "1",
            popularity: 0,
            name: "Character Name",
            thumbnail: "Character Thumbnail",
            description: "Character Description",
            realName: "Character RealName",
            aliases: ["Character Aliases"],
            birth: Date(),
            series: [
                ItemSummary(
                    identifier: "1",
                    popularity: 0,
                    name: "Series Name",
                    thumbnail: "Series thumbnail",
                    description: "Series Description",
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
        sut = Character(from: domainCharacter)
    }

    override func tearDownWithError() throws {
        domainCharacter = nil
        sut = nil
    }

    func testId_whenInitFromCharacter_isEqualToCharacterIdentifier() {
        XCTAssertEqual(sut.id, domainCharacter.identifier)
    }

    func testPopularity_whenInitFromCharacter_isEqualToCharacterPopularity() {
        XCTAssertEqual(sut.popularity, domainCharacter.popularity)
    }

    func testName_whenInitFromCharacter_isEqualToCharacterName() {
        XCTAssertEqual(sut.name, domainCharacter.name)
    }

    func testThumbnail_whenInitFromCharacter_isEqualToCharacterThumbnail() {
        XCTAssertEqual(sut.thumbnail, domainCharacter.thumbnail)
    }

    func testDescription_whenInitFromCharacter_isEqualToCharacterDescription() {
        XCTAssertEqual(sut.description, domainCharacter.description)
    }
    
    func testRealName_whenInitFromCharacter_isEqualToCharacterRealName() {
        XCTAssertEqual(sut.realName, domainCharacter.realName)
    }
    
    func testAliases_whenInitFromCharacter_isEqualToCharacterAliases() {
        XCTAssertEqual(sut.aliases, domainCharacter.aliases)
    }
    
    func testBirth_whenInitFromCharacter_isEqualToCharacterBirth() {
        XCTAssertEqual(sut.birth, domainCharacter.birth)
    }
    
    func testSeries_whenInitFromCharacter_isEqualToCharacterSeries() {
        XCTAssertEqual(
            sut.series?.map { $0.itemID }.sorted(),
            domainCharacter.series?.map { "Series#\($0.identifier)" }.sorted()
        )
    }
    
    func testComics_whenInitFromCharacter_isEqualToCharacterComics() {
        XCTAssertEqual(
            sut.comics?.map { $0.itemID }.sorted(),
            domainCharacter.comics?.map { "Comic#\($0.identifier)" }.sorted()
        )
    }
    
    func testItemID_whenInitFromCharacter_isEqualToItemNameID() {
        XCTAssertEqual(sut.itemID, "\(sut.itemName)#\(domainCharacter.identifier)")
    }
    
    func testSummaryID_whenInitFromCharacter_isEqualToItemNameID() {
        XCTAssertEqual(sut.summaryID, "\(sut.itemName)#\(domainCharacter.identifier)")
    }
    
    func testItemName_whenInitFromCharacter_isEqualToComic() {
        XCTAssertEqual(sut.itemName, "Character")
    }
    
    func testSeries_whenInitFromCharacterWitmEmptySeries_seriesIsNil() {
        domainCharacter = Domain.Character(
            identifier: "1",
            popularity: 0,
            name: "Character Name",
            thumbnail: "Character Thumbnail",
            description: "Character Description",
            realName: "Character RealName",
            aliases: ["Character Aliases"],
            birth: Date(),
            series: [],
            comics: []
        )
        sut = Character(from: domainCharacter)
        XCTAssertNil(sut.series)
    }
    
    func testComics_whenInitFromCharacterWitmEmptyComics_comicsIsNil() {
        domainCharacter = Domain.Character(
            identifier: "1",
            popularity: 0,
            name: "Character Name",
            thumbnail: "Character Thumbnail",
            description: "Character Description",
            realName: "Character RealName",
            aliases: ["Character Aliases"],
            birth: Date(),
            series: [],
            comics: []
        )
        sut = Character(from: domainCharacter)
        XCTAssertNil(sut.comics)
    }

}
