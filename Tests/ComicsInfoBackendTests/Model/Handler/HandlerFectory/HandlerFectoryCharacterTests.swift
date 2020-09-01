//
//  HandlerFectoryCharacterTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 01/09/2020.
//

@testable import ComicsInfoCore
import XCTest

final class HandlerFectoryCharacterTests: XCTestCase {

    private var sut: HandlerFectory!

    override func setUpWithError() throws {
        sut = HandlerFectory(mocked: true)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testMakeHandler_whenPathIsCharactersAndMethodIsPost_isCharactersCreate() {
        // Given
        let charactersCreate = Handler.characters(.create)

        // When
        let handler = sut.makeHandler(path: "/characters", method: .POST)

        // Then
        XCTAssertEqual(handler, charactersCreate)
    }

    func testMakeHandler_whenPathIsCharactersWithIDAndMethodIsGet_isCharactersRead() {
        // Given
        let charactersRead = Handler.characters(.read)

        // When
        let handler = sut.makeHandler(path: "/characters/", method: .GET)

        // Then
        XCTAssertEqual(handler, charactersRead)
    }

    func testMakeHandler_whenPathIsCharactersWithIDAndMethodIsPut_isCharactersUpdate() {
        // Given
        let charactersUpdate = Handler.characters(.update)

        // When
        let handler = sut.makeHandler(path: "/characters/", method: .PUT)

        // Then
        XCTAssertEqual(handler, charactersUpdate)
    }

    func testMakeHandler_whenPathIsCharactersWithIDAndMethodIsDelete_isCharactersDelete() {
        // Given
        let charactersDelete = Handler.characters(.delete)

        // When
        let handler = sut.makeHandler(path: "/characters/", method: .DELETE)

        // Then
        XCTAssertEqual(handler, charactersDelete)
    }

    func testMakeHandler_whenPathIsCharactersAndMethodIsGet_isCharactersList() {
        // Given
        let charactersList = Handler.characters(.list)

        // When
        let handler = sut.makeHandler(path: "/characters", method: .GET)

        // Then
        XCTAssertEqual(handler, charactersList)
    }

    func testMakeHandler_whenPathIsCharactersAndMethodIsDelete_isNil() {
        // Given

        // When
        let handler = sut.makeHandler(path: "/characters", method: .DELETE)

        // Then
        XCTAssertNil(handler)
    }

}
