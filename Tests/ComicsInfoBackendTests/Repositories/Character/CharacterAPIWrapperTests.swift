//
//  CharacterAPIWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 02/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest
import NIO

final class CharacterAPIWrapperTests: XCTestCase {

    private var eventLoop: EventLoop!
    private var characterID: String!

    override func setUpWithError() throws {
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        characterID = "1"
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        characterID = nil
    }

    // MARK: - Characters

    func test_whenGetAllCharacters_returns3Characters() throws {
        // Given
        let sut = CharacterAPIWrapperMockFactory.makeWithCharacters()

        // When
        let charactersFuture = sut.getAllCharacters(on: eventLoop)

        // Then
        let characters = try charactersFuture.wait()
        XCTAssertEqual(characters.count, 3)
    }

    func testWithoutData_whenGetAllCharacters_throwsCharactersNotFound() {
        // Given
        let sut = CharacterAPIWrapperMockFactory.makeWithoutData()

        // When
        let charactersFuture = sut.getAllCharacters(on: eventLoop)

        // Then
        XCTAssertThrowsError(try charactersFuture.wait()) {
            XCTAssertEqual($0 as? APIError, .charactersNotFound)
        }
    }

    func testWithBadData_whenGetAllCharacters_throwsCharactersNotFound() {
        // Given
        let sut = CharacterAPIWrapperMockFactory.makeWithCharactersBadData()

        // When
        let charactersFuture = sut.getAllCharacters(on: eventLoop)

        // Then
        XCTAssertThrowsError(try charactersFuture.wait()) {
            XCTAssertEqual($0 as? APIError, .charactersNotFound)
        }
    }

    // MARK: - Character

    func test_whenGetCharacter_returnsCharacter() throws {
        // Given
        let sut = CharacterAPIWrapperMockFactory.makeWithCharacter()

        // When
        let characterFuture = sut.getCharacter(withID: characterID, on: eventLoop)

        // Then
        let character = try characterFuture.wait()
        XCTAssertEqual(character.identifier, characterID)
    }

    func testWithoutData_whenGetCharacter_throwsCharacterNotFound() {
        // Given
        let sut = CharacterAPIWrapperMockFactory.makeWithoutData()

        // When
        let characterFuture = sut.getCharacter(withID: characterID, on: eventLoop)

        // Then
        XCTAssertThrowsError(try characterFuture.wait()) {
            XCTAssertEqual($0 as? APIError, .characterNotFound)
        }
    }

    func testWithBadData_whenGetCharacter_throwsCharacterNotFound() {
        // Given
        let sut = CharacterAPIWrapperMockFactory.makeWithCharacterBadData()

        // When
        let characterFuture = sut.getCharacter(withID: characterID, on: eventLoop)

        // Then
        XCTAssertThrowsError(try characterFuture.wait()) {
            XCTAssertEqual($0 as? APIError, .characterNotFound)
        }
    }

}
