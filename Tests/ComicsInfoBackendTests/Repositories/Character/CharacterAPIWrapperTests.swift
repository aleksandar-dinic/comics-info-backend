//
//  CharacterAPIWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 02/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import CharacterInfo
import XCTest
import NIO

final class CharacterAPIWrapperTests: XCTestCase {

    private var eventLoop: EventLoop!
    private var characterAPIWrapperMockFactory: CharacterAPIWrapperMockFactory!
    private var characterID: String!

    override func setUpWithError() throws {
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        characterAPIWrapperMockFactory = CharacterAPIWrapperMockFactory(on: eventLoop)
        characterID = "1"
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        characterAPIWrapperMockFactory = nil
        characterID = nil
    }

    // MARK: - Characters

    func test_whenGetAllCharacters_returns3Characters() throws {
        // Given
        let sut = characterAPIWrapperMockFactory.makeWithCharacters()

        // When
        let charactersFuture = sut.getAllCharacters(on: eventLoop)

        // Then
        let characters = try charactersFuture.wait()
        XCTAssertEqual(characters.count, 3)
    }

    func testWithoutData_whenGetAllCharacters_throwsCharactersNotFound() {
        // Given
        let sut = characterAPIWrapperMockFactory.makeWithoutData()

        // When
        let charactersFuture = sut.getAllCharacters(on: eventLoop)

        // Then
        XCTAssertThrowsError(try charactersFuture.wait()) {
            XCTAssertEqual($0 as? APIError, .charactersNotFound)
        }
    }

    func testWithBadData_whenGetAllCharacters_throwsCharactersNotFound() {
        // Given
        let sut = characterAPIWrapperMockFactory.makeWithCharactersBadData()

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
        let sut = characterAPIWrapperMockFactory.makeWithCharacter()

        // When
        let characterFuture = sut.getCharacter(withID: characterID, on: eventLoop)

        // Then
        let character = try characterFuture.wait()
        XCTAssertEqual(character.identifier, characterID)
    }

    func testWithoutData_whenGetCharacter_throwsCharacterNotFound() {
        // Given
        let sut = characterAPIWrapperMockFactory.makeWithoutData()

        // When
        let characterFuture = sut.getCharacter(withID: characterID, on: eventLoop)

        // Then
        XCTAssertThrowsError(try characterFuture.wait()) {
            XCTAssertEqual($0 as? APIError, .characterNotFound)
        }
    }

    func testWithBadData_whenGetCharacter_throwsCharacterNotFound() {
        // Given
        let sut = characterAPIWrapperMockFactory.makeWithCharacterBadData()

        // When
        let characterFuture = sut.getCharacter(withID: characterID, on: eventLoop)

        // Then
        XCTAssertThrowsError(try characterFuture.wait()) {
            XCTAssertEqual($0 as? APIError, .characterNotFound)
        }
    }

}
