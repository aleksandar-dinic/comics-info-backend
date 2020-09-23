//
//  CharacterUseCaseTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 10/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import CharacterInfo
import XCTest
import NIO

final class CharacterUseCaseTests: XCTestCase {

    private var eventLoop: EventLoop!
    private var characterRepositoryMockFactory: CharacterRepositoryMockFactory!

    override func setUpWithError() throws {
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        characterRepositoryMockFactory = CharacterRepositoryMockFactory(on: eventLoop)
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        characterRepositoryMockFactory = nil
    }

    func testUseCase_genGetAllCharacters_returns3Characters() throws {
        // Given
        let characterRepository = characterRepositoryMockFactory.makeWithCharacters()
        let sut = CharacterUseCase(characterRepository: characterRepository)

        // When
        let charactersFuture = sut.getAllCharacters(fromDataSource: .memory, on: eventLoop)

        // Then
        let characters = try charactersFuture.wait()
        XCTAssertEqual(characters.count, 3)
    }

    func testUseCase_whenGetCharacter_returnsCharacter() throws {
        // Given
        let characterRepository = characterRepositoryMockFactory.makeWithCharacter()
        let sut = CharacterUseCase(characterRepository: characterRepository)
        let characterID = "1"

        // When
        let characterFuture = sut.getCharacter(withID: characterID, fromDataSource: .memory, on: eventLoop)

        // Then
        let character = try characterFuture.wait()
        XCTAssertEqual(character.identifier, characterID)
    }

}
