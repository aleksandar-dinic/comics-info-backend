//
//  HandlerComicsTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 01/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class HandlerComicsTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    // Initialization

    func testHandler_whenInitialize_isEqualComicsCreate() {
        // Given
        let comicsCreate = Handler.comics(.create)

        // When
        let sut = Handler(rawValue: "comics.create")

        // Then
        XCTAssertEqual(sut, comicsCreate)
    }

    func testHandler_whenInitialize_isEqualComicsRead() {
        // Given
        let comicsRead = Handler.comics(.read)

        // When
        let sut = Handler(rawValue: "comics.read")

        // Then
        XCTAssertEqual(sut, comicsRead)
    }

    func testHandler_whenInitialize_isEqualComicsUpdate() {
        // Given
        let comicsUpdate = Handler.comics(.update)

        // When
        let sut = Handler(rawValue: "comics.update")

        // Then
        XCTAssertEqual(sut, comicsUpdate)
    }

    func testHandler_whenInitialize_isEqualComicsDelete() {
        // Given
        let comicsDelete = Handler.comics(.delete)

        // When
        let sut = Handler(rawValue: "comics.delete")

        // Then
        XCTAssertEqual(sut, comicsDelete)
    }

    func testHandler_whenInitialize_isEqualComicsList() {
        // Given
        let comicsList = Handler.comics(.list)

        // When
        let sut = Handler(rawValue: "comics.list")

        // Then
        XCTAssertEqual(sut, comicsList)
    }

    // Raw value

    func testHandler_rawValue_isEqualComicsCreate() {
        // Given
        let sut = Handler.comics(.create)
        let rawValue = "comics.create"

        // When

        // Then
        XCTAssertEqual(sut.rawValue, rawValue)
    }

    func testHandler_rawValue_isEqualComicsRead() {
        // Given
        let sut = Handler.comics(.read)
        let rawValue = "comics.read"

        // When

        // Then
        XCTAssertEqual(sut.rawValue, rawValue)
    }

    func testHandler_rawValue_isEqualComicsUpdate() {
        // Given
        let sut = Handler.comics(.update)
        let rawValue = "comics.update"

        // When

        // Then
        XCTAssertEqual(sut.rawValue, rawValue)
    }

    func testHandler_rawValue_isEqualComicsDelete() {
        // Given
        let sut = Handler.comics(.delete)
        let rawValue = "comics.delete"

        // When

        // Then
        XCTAssertEqual(sut.rawValue, rawValue)
    }

    func testHandler_rawValue_isEqualComicsList() {
        // Given
        let sut = Handler.comics(.list)
        let rawValue = "comics.list"

        // When

        // Then
        XCTAssertEqual(sut.rawValue, rawValue)
    }

}

