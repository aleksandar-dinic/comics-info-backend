//
//  CharacterSummary+CharacterTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class CharacterSummary_CharacterTests: XCTestCase {

    private var character: Character!
    private var series: Series!
    private var count: Int!
    private var sut: CharacterSummary!
    
    override func setUpWithError() throws {
        character = CharacterFactory.make(ID: "CharacterID")
        series = SeriesFactory.make(ID: "SeriesID")
        count = 0
        sut = CharacterSummary(character, link: series, count: count)
    }

    override func tearDownWithError() throws {
        character = nil
        series = nil
        count = nil
        sut = nil
    }
    
    func testItemID_whenInitFromCharacter() throws {
        XCTAssertEqual(sut.itemID, "\(String.getType(from: CharacterSummary.self))#\(character.id)")
    }

    func testSummaryID_whenInitFromCharacter() {
        XCTAssertEqual(sut.summaryID, "\(String.getType(from: SeriesSummary.self))#\(series.id)")
    }
    
    func testItemType_whenInitFromCharacter() {
        XCTAssertEqual(sut.itemType, .getType(from: CharacterSummary.self))
    }
    
    func testDateAdded_whenInitFromCharacter() {
        XCTAssertEqual(
            Calendar.current.compare(sut.dateAdded, to: Date(), toGranularity: .hour),
            .orderedSame
        )
    }
    
    func testDateLastUpdated_whenInitFromCharacter() {
        XCTAssertEqual(
            Calendar.current.compare(sut.dateLastUpdated, to: Date(), toGranularity: .hour),
            .orderedSame
        )
    }
    
    func testPopularity_whenInitFromCharacter() {
        XCTAssertEqual(sut.popularity, character.popularity)
    }
    
    func testName_whenInitFromCharacter() {
        XCTAssertEqual(sut.name, character.name)
    }
    
    func testThumbnail_whenInitFromCharacter() {
        XCTAssertEqual(sut.thumbnail, character.thumbnail)
    }
    
    func testDescription_whenInitFromCharacter() {
        XCTAssertEqual(sut.description, character.description)
    }
    
    func testcount_whenInitFromCharacter() {
        XCTAssertEqual(sut.count, count)
    }

}
