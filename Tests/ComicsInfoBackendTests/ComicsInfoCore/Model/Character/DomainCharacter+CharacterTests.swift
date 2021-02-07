//
//  DomainCharacter+CharacterTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 29/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import struct ComicsInfoCore.Character
@testable import struct Domain.Character
import XCTest

final class DomainCharacter_CharacterTests: XCTestCase {

    private var givenCharacter: ComicsInfoCore.Character!
    private var sut: Domain.Character!

    override func setUpWithError() throws {
        givenCharacter = CharacterFactory.make()
        sut = Domain.Character(from: givenCharacter)
    }

    override func tearDownWithError() throws {
        givenCharacter = nil
        sut = nil
    }

    func testIdentifier_whenInitFromCharacter_isEqualToCharacterID() {
        XCTAssertEqual(sut.identifier, givenCharacter.id)
    }

    func testPopularity_whenInitFromCharacter_isEqualToCharacterPopularity() {
        XCTAssertEqual(sut.popularity, givenCharacter.popularity)
    }

    func testName_whenInitFromCharacter_isEqualToCharacterName() {
        XCTAssertEqual(sut.name, givenCharacter.name)
    }

    func testThumbnail_whenInitFromCharacter_isEqualToCharacterThumbnail() {
        XCTAssertEqual(sut.thumbnail, givenCharacter.thumbnail)
    }

    func testDescription_whenInitFromCharacter_isEqualToCharacterDescription() {
        XCTAssertEqual(sut.description, givenCharacter.description)
    }
    
    func testRealName_whenInitFromCharacter_isEqualToCharacterRealName() {
        XCTAssertEqual(sut.realName, givenCharacter.realName)
    }
    
    func testAliases_whenInitFromCharacter_isEqualToCharacterAliases() {
        XCTAssertEqual(sut.aliases, givenCharacter.aliases)
    }
    
    func testBirth_whenInitFromCharacter_isEqualToCharacterBirth() {
        XCTAssertEqual(sut.birth, givenCharacter.birth)
    }
    
    func testSeries_whenInitFromCharacter_isEqualToCharacterSeries() {
        XCTAssertEqual(
            sut.series?.map { "Series#\($0.identifier)" }.sorted(),
            givenCharacter.series?.map { $0.itemID }.sorted()
        )
    }
    
    func testComics_whenInitFromCharacter_isEqualToCharacterComics() {
        XCTAssertEqual(
            sut.comics?.map { "Comic#\($0.identifier)" }.sorted(),
            givenCharacter.comics?.map { $0.itemID }.sorted()
        )
    }

}
