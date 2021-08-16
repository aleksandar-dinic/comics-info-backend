//
//  Character+DomainTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 12/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import struct ComicsInfoCore.Character
@testable import struct Domain.Character
@testable import struct Domain.SeriesSummary
@testable import struct Domain.ComicSummary
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
                Domain.SeriesSummary(
                    identifier: "1",
                    popularity: 0,
                    title: "Series Title",
                    thumbnail: "Series thumbnail",
                    description: "Series Description"
                )
            ],
            comics: [
                Domain.ComicSummary(
                    identifier: "1",
                    popularity: 0,
                    title: "Comic Title",
                    thumbnail: "Comic thumbnail",
                    description: "Comic Description",
                    number: nil,
                    published: nil
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
    
    func testSeries_whenInitFromCharacter_isNil() {
        XCTAssertNil(sut.series)
    }

    func testComics_whenInitFromCharacter_isNil() {
        XCTAssertNil(sut.comics)
    }
    
    func testItemID_whenInitFromCharacter_isEqualToItemTypeID() {
        XCTAssertEqual(sut.itemID, "\(sut.itemType)#\(domainCharacter.identifier)")
    }
    
    func testItemType_whenInitFromCharacter_isEqualToComic() {
        XCTAssertEqual(sut.itemType, "Character")
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
