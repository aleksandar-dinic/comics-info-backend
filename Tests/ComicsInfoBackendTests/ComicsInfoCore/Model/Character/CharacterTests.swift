//
//  CharacterTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 01/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class CharacterTests: XCTestCase {

    private var seriesID: Set<String>!
    private var comicsID: Set<String>!
    private var sut: Character!

    override func setUpWithError() throws {
        seriesID = ["1", "2", "3"]
        comicsID = ["1", "2", "3"]
        sut = CharacterMock.makeCharacter(
            seriesID: seriesID,
            comicsID: comicsID
        )
    }

    override func tearDownWithError() throws {
        seriesID = nil
        comicsID = nil
        sut = nil
    }

    func testCharacterSeriesID_whenRemoveID_isEqualToSeriesID() {
        // Given
        seriesID.remove("2")

        // When
        sut.removeID("series#2")

        // Then
        XCTAssertEqual(sut.seriesID, seriesID)
    }

    func testCharacterComicsID_whenRemoveID_isEqualToComicsID() {
        // Given
        comicsID.remove("3")

        // When
        sut.removeID("comic#3")

        // Then
        XCTAssertEqual(sut.comicsID, comicsID)
    }

}
