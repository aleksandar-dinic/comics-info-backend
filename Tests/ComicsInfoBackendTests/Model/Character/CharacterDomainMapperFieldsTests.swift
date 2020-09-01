//
//  CharacterDomainMapperFieldsTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 01/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import struct Domain.Character
@testable import ComicsInfoCore
import XCTest

final class CharacterDomainMapperFieldsTests: XCTestCase {

    private var character: ComicsInfoCore.Character!
    private var identifier: String!
    private var popularity: Int!
    private var characterName: String!
    private var thumbnail: String!
    private var characterDescription: String!
    private var sut: Domain.Character!

    override func setUpWithError() throws {
        identifier = "1"
        popularity = 0
        characterName = "name"
        thumbnail = "thumbnail"
        characterDescription = "description"
        character = ComicsInfoCore.Character(
            identifier: identifier,
            popularity: popularity,
            name: characterName,
            thumbnail: thumbnail,
            description: characterDescription
        )
        sut = Domain.Character(from: character)
    }

    override func tearDownWithError() throws {
        identifier = nil
        popularity = nil
        characterName = nil
        thumbnail = nil
        characterDescription = nil
        character = nil
        sut = nil
    }

    func testCharacterIdentifier_whenInitFromCharacter_isEqualToCharacterIdentifier() {
        XCTAssertEqual(sut.identifier, identifier)
    }

    func testCharacterPopularity_whenInitFromCharacter_isEqualToCharacterPopularity() {
        XCTAssertEqual(sut.popularity, popularity)
    }

    func testCharacterName_whenInitFromCharacter_isEqualToCharacterName() {
        XCTAssertEqual(sut.name, characterName)
    }

    func testCharacterThumbnail_whenInitFromCharacter_isEqualToCharacterThumbnail() {
        XCTAssertEqual(sut.thumbnail, thumbnail)
    }

    func testCharacterDescription_whenInitFromCharacter_isEqualToCharacterDescription() {
        XCTAssertEqual(sut.description, characterDescription)
    }

}
