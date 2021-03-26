//
//  SeriesSummary+DomainTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import struct Domain.ItemSummary
import XCTest

final class SeriesSummary_DomainTests: XCTestCase {

    private var item: Domain.ItemSummary!
    private var character: Character!
    private var number: String!
    private var sut: SeriesSummary!
    
    override func setUpWithError() throws {
        item = DomainItemSummaryFactory.make()
        character = CharacterFactory.make(ID: "CharacterID")
        number = "1"
        sut = SeriesSummary(from: item, link: character)
    }

    override func tearDownWithError() throws {
        item = nil
        character = nil
        number = nil
        sut = nil
    }
    
    func testItemID_whenInitFromItem() throws {
        XCTAssertEqual(sut.itemID, "\(String.getType(from: SeriesSummary.self))#\(item.identifier)")
    }
    
    func testSummaryID_whenInitFromItem() {
        XCTAssertEqual(sut.summaryID, "\(String.getType(from: CharacterSummary.self))#\(character.id)")
    }
    
    func testItemType_whenInitFromItem() {
        XCTAssertEqual(sut.itemType, .getType(from: SeriesSummary.self))
    }
    
    func testDateAdded_whenInitFromItem() {
        XCTAssertEqual(
            Calendar.current.compare(sut.dateAdded, to: Date(), toGranularity: .hour),
            .orderedSame
        )
    }
    
    func testDateLastUpdated_whenInitFromItem() {
        XCTAssertEqual(
            Calendar.current.compare(sut.dateLastUpdated, to: Date(), toGranularity: .hour),
            .orderedSame
        )
    }
    
    func testPopularity_whenInitFromItem() {
        XCTAssertEqual(sut.popularity, item.popularity)
    }
    
    func testName_whenInitFromItem() {
        XCTAssertEqual(sut.name, item.name)
    }
    
    func testThumbnail_whenInitFromItem() {
        XCTAssertEqual(sut.thumbnail, item.thumbnail)
    }
    
    func testDescription_whenInitFromItem() {
        XCTAssertEqual(sut.description, item.description)
    }
    
}
