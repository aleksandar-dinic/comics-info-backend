//
//  Character+CharacterSummaryTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 13/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class Character_CharacterSummaryTests: XCTestCase {

    private var characterSummary: CharacterSummary!
    private var sut: Character!

    override func setUpWithError() throws {
        characterSummary = CharacterSummaryMock.characterSummary
        sut = Character(fromSummary: characterSummary)
    }

    override func tearDownWithError() throws {
        characterSummary = nil
        sut = nil
    }

    func testID_whenInitFromCharacterSummary_isEqualToCharacterSummaryID() {
        XCTAssertEqual(sut.id, characterSummary.id)
    }

    func testPopularity_whenInitFromCharacterSummary_isEqualToCharacterSummaryPopularity() {
        XCTAssertEqual(sut.popularity, characterSummary.popularity)
    }

    func testName_whenInitFromCharacterSummary_isEqualToCharacterSummaryName() {
        XCTAssertEqual(sut.name, characterSummary.name)
    }

    func testThumbnail_whenInitFromCharacterSummary_isEqualToCharacterSummaryThumbnail() {
        XCTAssertEqual(sut.thumbnail, characterSummary.thumbnail)
    }

    func testDescription_whenInitFromCharacterSummary_isEqualToCharacterSummaryDescription() {
        XCTAssertEqual(sut.description, characterSummary.description)
    }

    func testSeriesID_whenInitFromCharacterSummary_isNil() {
        XCTAssertNil(sut.seriesID)
    }

    func testSeries_whenInitFromCharacterSummary_isNil() {
        XCTAssertNil(sut.series)
    }

    func testComicsID_whenInitFromCharacterSummary_isNil() {
        XCTAssertNil(sut.comicsID)
    }

    func testComics_whenInitFromCharacterSummary_isNil() {
        XCTAssertNil(sut.comics)
    }

}
