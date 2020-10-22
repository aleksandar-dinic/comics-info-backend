//
//  ComicTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 15/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class ComicTests: XCTestCase {

    private var charactersID: Set<String>!
    private var seriesID: Set<String>!
    private var sut: Comic!

    override func setUpWithError() throws {
        charactersID = ["1", "2", "3"]
        seriesID = ["1", "2", "3"]
        sut = ComicMock.makeComic(
            charactersID: charactersID,
            seriesID: seriesID
        )
    }

    override func tearDownWithError() throws {
        charactersID = nil
        seriesID = nil
        sut = nil
    }

    func testComicCharactersID_whenRemoveID_isEqualToCharactersID() {
        // Given
        charactersID.remove("3")

        // When
        sut.removeID("character#3")

        // Then
        XCTAssertEqual(sut.charactersID, charactersID)
    }

    func testCharacterSeriesID_whenRemoveID_isEqualToSeriesID() {
        // Given
        seriesID.remove("2")

        // When
        sut.removeID("series#2")

        // Then
        XCTAssertEqual(sut.seriesID, seriesID)
    }

}
