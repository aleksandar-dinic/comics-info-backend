//
//  CharacterDeleteUseCaseTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/05/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import NIO
import XCTest

final class CharacterDeleteUseCaseTests: XCTestCase, CreateCharacterProtocol {

    private var eventLoop: EventLoop!
    private var sut: CharacterDeleteUseCase!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        MockDB.removeAll()
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        sut = CharacterDeleteUseCaseFactoryMock(on: eventLoop).makeUseCase()
        table = String.tableName(for: "TEST")
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        sut = nil
        table = nil
    }

    func test_whenDeleteCharacter_characterIsDeleted() throws {
        // Given
        let givenID = "CharacterID"
        let givenCharacter = CharacterFactory.make(ID: givenID)
        try createCharacter(givenCharacter)

        // When
        let feature = sut.delete(withID: givenID, on: eventLoop, from: table, logger: nil)
        let character = try feature.wait()

        // Then
        XCTAssertEqual(character.id, givenCharacter.id)
    }
    
    func test_whenDeleteCharacterWhenCharacterDoesnotExist_throwsItemNotFound() throws {
        // Given
        let givenID = "CharacterID"
        var thrownError: Error?
        
        // When
        let feature = sut.delete(withID: givenID, on: eventLoop, from: table, logger: nil)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }
        
        // Then
        let error = try XCTUnwrap(thrownError)
        if case let .itemNotFound(ID, _) = error as? ComicInfoError {
            XCTAssertEqual(ID, givenID)
        } else {
            XCTFail("Expected '.itemNotFound' but got \(error)")
        }
    }
    
}
