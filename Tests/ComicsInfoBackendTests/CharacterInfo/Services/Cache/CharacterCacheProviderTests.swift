//
//  CharacterCacheProviderTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 02/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
@testable import CharacterInfo
import XCTest
import NIO

final class CharacterCacheProviderTests: XCTestCase {

    private var eventLoop: EventLoop!
    private var givenCharacters: [String: Character]!
    private var inMemoryCache: InMemoryCache<String, Character>!

    override func setUpWithError() throws {
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        givenCharacters = [
            CharactersMock.character.identifier: CharactersMock.character,
            CharactersMock.character2.identifier: CharactersMock.character2
        ]
        inMemoryCache = InMemoryCache(storage: givenCharacters)
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        inMemoryCache = nil
        givenCharacters = nil
    }

    // MARK: - Characters

    func testGetAllCharacters_returnsCharacters() throws {
        // Given
        let sut = CharacterCacheProvider(inMemoryCache)

        // When
        let characters = try sut.getAllCharacters(on: eventLoop).wait()

        // Then
        XCTAssertEqual(characters.count, givenCharacters.count)
    }

    func testGetCharacters_whenCacheIsEmpty_throwsItemsNotFound() throws {
        // Given
        let sut = CharacterCacheProvider()

        // When
        let charactersFuture = sut.getAllCharacters(on: eventLoop)

        // Then
        XCTAssertThrowsError(try charactersFuture.wait()) {
            XCTAssertEqual($0 as? APIError, .itemsNotFound)
        }
    }

    // MARK: - Character

    func testGetCharacterWithID_returnsCharacter() throws {
        // Give
        let sut = CharacterCacheProvider(inMemoryCache)

        // When
        let character = try sut.getCharacter(withID: "1", on: eventLoop).wait()

        // Then
        XCTAssertEqual(character.identifier, "1")
    }

    func testGetCharacterWithID_whenIDNotExist_throwsItemNotFound() throws {
        // Given
        let sut = CharacterCacheProvider()

        // When
        let charactersFuture = sut.getCharacter(withID: "-1", on: eventLoop)

        // Then
        XCTAssertThrowsError(try charactersFuture.wait()) {
            XCTAssertEqual($0 as? APIError, .itemNotFound)
        }
    }

    func testSaveCharacters() {
        // Given
        let sut = CharacterCacheProvider(inMemoryCache)

        // When
        sut.save(characters: Array(givenCharacters.values))

        // Then
        XCTAssertEqual(inMemoryCache.values.count, givenCharacters.count)
    }

}
