//
//  CharacterRepositoryTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 02/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
@testable import CharacterInfo
import XCTest
import NIO

final class CharacterRepositoryTests: XCTestCase {

    private var eventLoop: EventLoop!
    private var characterDataProviderMockFactory: CharacterDataProviderMockFactory!
    private var dataSourceLayer: DataSourceLayer!

    override func setUpWithError() throws {
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        characterDataProviderMockFactory = CharacterDataProviderMockFactory(on: eventLoop)
        dataSourceLayer = .database
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        characterDataProviderMockFactory = nil
        dataSourceLayer = nil
    }

    // MARK: - Characters

    func test_whenGetAllCharacters_returns3Characters() throws {
        // Given
        let characterDataProvider = characterDataProviderMockFactory.makeWithCharactersFromDatabase()
        let sut = CharacterRepository(characterDataProvider: characterDataProvider)

        // When
        let charactersFuture = sut.getAllCharacters(fromDataSource: dataSourceLayer, on: eventLoop)

        // Then
        let characters = try charactersFuture.wait()
        XCTAssertEqual(characters.count, 3)
    }

    // MARK: - Character

    func test_whenGetCharacter_returnsCharacter() throws {
        // Given
        let characterDataProvider = characterDataProviderMockFactory.makeWithCharacterFromDatabase()
        let sut = CharacterRepository(characterDataProvider: characterDataProvider)
        let characterID = "1"

        // When
        let characterFuture = sut.getCharacter(withID: characterID, fromDataSource: dataSourceLayer, on: eventLoop)

        // Then
        let character = try characterFuture.wait()
        XCTAssertEqual(character.identifier, characterID)
    }

}
