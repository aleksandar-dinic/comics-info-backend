//
//  ItemSummaryTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 13/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class ItemSummaryTests: XCTestCase {

    private var sut: ItemSummary<Character>!

    override func setUpWithError() throws {
        sut = CharacterSummaryMock.characterSummary
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    // MARK: - Update

    func testPopularity_whenUpdateWithCharacter_isEqulToCharacterPopularity() {
        // Given
        let character = CharacterMock.character

        // When
        sut.update(with: character)

        // Then
        XCTAssertEqual(sut.popularity, character.popularity)
    }

    func testName_whenUpdateWithCharacter_isEqulToCharacterName() {
        // Given
        let character = CharacterMock.character

        // When
        sut.update(with: character)

        // Then
        XCTAssertEqual(sut.name, character.name)
    }

    func testThumbnail_whenUpdateWithCharacter_isEqulToCharacterThumbnail() {
        // Given
        let character = CharacterMock.character

        // When
        sut.update(with: character)

        // Then
        XCTAssertEqual(sut.thumbnail, character.thumbnail)
    }

    func testDescription_whenUpdateWithCharacter_isEqulToCharacterDescription() {
        // Given
        let character = CharacterMock.character

        // When
        sut.update(with: character)

        // Then
        XCTAssertEqual(sut.description, character.description)
    }

    // MARK: - Should Be Updated

    func test_whenShouldBeUpdatedWithCharacterDiffPopularity_isTrue() {
        // Given
        let character = CharacterMock.makeCharacter(
            popularity: 1,
            name: "Name",
            thumbnail: "Thumbnail",
            description: "Description"
        )
        let sut = CharacterSummaryMock.makeCharacterSummary(
            popularity: 0,
            name: "Name",
            thumbnail: "Thumbnail",
            description: "Description"
        )

        // When
        let shouldBeUpdated = sut.shouldBeUpdated(with: character)

        // Then
        XCTAssertTrue(shouldBeUpdated)
    }

    func test_whenShouldBeUpdatedWithCharacterDiffName_isTrue() {
        // Given
        let character = CharacterMock.makeCharacter(
            popularity: 0,
            name: "New Name",
            thumbnail: "Thumbnail",
            description: "Description"
        )
        let sut = CharacterSummaryMock.makeCharacterSummary(
            popularity: 0,
            name: "Old Name",
            thumbnail: "Thumbnail",
            description: "Description"
        )

        // When
        let shouldBeUpdated = sut.shouldBeUpdated(with: character)

        // Then
        XCTAssertTrue(shouldBeUpdated)
    }

    func test_whenShouldBeUpdatedWithCharacterDiffThumbnail_isTrue() {
        // Given
        let character = CharacterMock.makeCharacter(
            popularity: 0,
            name: "Name",
            thumbnail: "New Thumbnail",
            description: "Description"
        )
        let sut = CharacterSummaryMock.makeCharacterSummary(
            popularity: 0,
            name: "Name",
            thumbnail: "Old Thumbnail",
            description: "Description"
        )

        // When
        let shouldBeUpdated = sut.shouldBeUpdated(with: character)

        // Then
        XCTAssertTrue(shouldBeUpdated)
    }

    func test_whenShouldBeUpdatedWithCharacterDiffDescription_isTrue() {
        // Given
        let character = CharacterMock.makeCharacter(
            popularity: 0,
            name: "Name",
            thumbnail: "Thumbnail",
            description: "New Description"
        )
        let sut = CharacterSummaryMock.makeCharacterSummary(
            popularity: 0,
            name: "Name",
            thumbnail: "Thumbnail",
            description: "Old Description"
        )

        // When
        let shouldBeUpdated = sut.shouldBeUpdated(with: character)

        // Then
        XCTAssertTrue(shouldBeUpdated)
    }

    func test_whenShouldBeUpdatedWithCharacter_isFalse() {
        // Given
        let character = CharacterMock.makeCharacter(
            popularity: 0,
            name: "Name",
            thumbnail: "Thumbnail",
            description: "Description"
        )
        let sut = CharacterSummaryMock.makeCharacterSummary(
            popularity: 0,
            name: "Name",
            thumbnail: "Thumbnail",
            description: "Description"
        )

        // When
        let shouldBeUpdated = sut.shouldBeUpdated(with: character)

        // Then
        XCTAssertFalse(shouldBeUpdated)
    }

}
