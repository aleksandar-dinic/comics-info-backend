//
//  Character+DomainTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 12/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import struct ComicsInfoCore.Character
@testable import struct Domain.Character
import XCTest

final class Character_DomainTests: XCTestCase {

    private var givenCharacter: ComicsInfoCore.Character!
    private var sut: Domain.Character!

    override func setUpWithError() throws {
        givenCharacter = CharacterMock.character
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
        XCTAssertEqual(sut.series?.compactMap { $0.identifier }, givenCharacter.series?.compactMap { $0.id })
    }

    func testComics_whenInitFromCharacter_isEqualToCharacterComics() {
        XCTAssertEqual(sut.comics?.compactMap { $0.identifier }, givenCharacter.comics?.compactMap { $0.id })
    }

}
