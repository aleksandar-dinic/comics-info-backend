//
//  HandlerCharacterTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 31/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class HandlerCharacterTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    // Initialization

    func testHandler_whenInitialize_isEqualCharacterCreate() {
        // Given
        let characterCreate = Handler.characters(.create)

        // When
        let sut = Handler(rawValue: "characters.create")

        // Then
        XCTAssertEqual(sut, characterCreate)
    }

    func testHandler_whenInitialize_isEqualCharacterRead() {
        // Given
        let characterRead = Handler.characters(.read)

        // When
        let sut = Handler(rawValue: "characters.read")

        // Then
        XCTAssertEqual(sut, characterRead)
    }

    func testHandler_whenInitialize_isEqualCharacterUpdate() {
        // Given
        let characterUpdate = Handler.characters(.update)

        // When
        let sut = Handler(rawValue: "characters.update")

        // Then
        XCTAssertEqual(sut, characterUpdate)
    }

    func testHandler_whenInitialize_isEqualCharacterDelete() {
        // Given
        let characterDelete = Handler.characters(.delete)

        // When
        let sut = Handler(rawValue: "characters.delete")

        // Then
        XCTAssertEqual(sut, characterDelete)
    }

    func testHandler_whenInitialize_isEqualCharacterList() {
        // Given
        let characterList = Handler.characters(.list)

        // When
        let sut = Handler(rawValue: "characters.list")

        // Then
        XCTAssertEqual(sut, characterList)
    }

    // Raw value

    func testHandler_rawValue_isEqualCharacterCreate() {
        // Given
        let sut = Handler.characters(.create)
        let rawValue = "characters.create"

        // When

        // Then
        XCTAssertEqual(sut.rawValue, rawValue)
    }

    func testHandler_rawValue_isEqualCharacterRead() {
        // Given
        let sut = Handler.characters(.read)
        let rawValue = "characters.read"

        // When

        // Then
        XCTAssertEqual(sut.rawValue, rawValue)
    }

    func testHandler_rawValue_isEqualCharacterUpdate() {
        // Given
        let sut = Handler.characters(.update)
        let rawValue = "characters.update"

        // When

        // Then
        XCTAssertEqual(sut.rawValue, rawValue)
    }

    func testHandler_rawValue_isEqualCharacterDelete() {
        // Given
        let sut = Handler.characters(.delete)
        let rawValue = "characters.delete"

        // When

        // Then
        XCTAssertEqual(sut.rawValue, rawValue)
    }

    func testHandler_rawValue_isEqualCharacterList() {
        // Given
        let sut = Handler.characters(.list)
        let rawValue = "characters.list"

        // When

        // Then
        XCTAssertEqual(sut.rawValue, rawValue)
    }

}
