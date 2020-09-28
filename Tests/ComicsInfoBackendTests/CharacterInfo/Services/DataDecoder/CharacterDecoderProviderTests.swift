//
//  CharacterDecoderProviderTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 02/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
@testable import CharacterInfo
import XCTest

final class CharacterDecoderProviderTests: XCTestCase {

    private var sut: CharacterDecoderProvider!

    override func setUpWithError() throws {
        sut = CharacterDecoderProvider()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testDecodeAllCharacters_returns3Characters() throws {
        // When
        let characters = try sut.decodeAllCharacters(from: CharactersMock.charactersItems)

        // Then
        XCTAssertEqual(characters.count, 3)
    }

    func testDecodeAllCharacters_whenItemsIsNil_throwsItemsNotFound() {
        XCTAssertThrowsError(try sut.decodeAllCharacters(from: nil)) {
            XCTAssertEqual($0 as? APIError, .itemsNotFound)
        }
    }

    func testDecodeCharacter_returnsCharacter() throws {
        XCTAssertNoThrow(try sut.decodeCharacter(from: CharactersMock.characterData))
    }

    func testDecodeCharacter_whenItemsIsNil_throwsItemNotFound() {
        XCTAssertThrowsError(try sut.decodeCharacter(from: nil)) {
            XCTAssertEqual($0 as? APIError, .itemNotFound)
        }
    }

}
