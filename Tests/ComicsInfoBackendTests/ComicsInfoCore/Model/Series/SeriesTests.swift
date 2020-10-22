//
//  SeriesTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 15/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class SeriesTests: XCTestCase {

    private var charactersID: Set<String>!
    private var comicsID: Set<String>!
    private var sut: Series!

    override func setUpWithError() throws {
        charactersID = ["1", "2", "3"]
        comicsID = ["1", "2", "3"]
        sut = SeriesMock.makeSeries(
            charactersID: charactersID,
            comicsID: comicsID
        )
    }

    override func tearDownWithError() throws {
        charactersID = nil
        comicsID = nil
        sut = nil
    }

    func testSeriesCharactersID_whenRemoveID_isEqualToCharactersID() {
        // Given
        charactersID.remove("2")

        // When
        sut.removeID("character#2")

        // Then
        XCTAssertEqual(sut.charactersID, charactersID)
    }

    func testSeriesComicsID_whenRemoveID_isEqualToComicsID() {
        // Given
        comicsID.remove("3")

        // When
        sut.removeID("comic#3")

        // Then
        XCTAssertEqual(sut.comicsID, comicsID)
    }

}
