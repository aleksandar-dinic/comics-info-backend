//
//  CharacterSummary+DomainTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import struct Domain.ItemSummary
import XCTest

final class CharacterSummary_DomainTests: XCTestCase {

    private typealias Item = Series
    
    private var item: Domain.ItemSummary!
    private var id: String!
    private var count: Int!
    private var sut: CharacterSummary<Item>!
    
    override func setUpWithError() throws {
        item = DomainItemSummaryFactory.make()
        id = "1"
        count = 0
        sut = CharacterSummary<Item>(from: item, id: id, count: count)
    }

    override func tearDownWithError() throws {
        item = nil
        id = nil
        count = nil
        sut = nil
    }

    func testItemID_whenInitFromItem() throws {
        let id = try XCTUnwrap(self.id)
        XCTAssertEqual(sut.itemID, "\(String.getType(from: Character.self))#\(id)")
    }
    
    func testSummaryID_whenInitFromItem() {
        XCTAssertEqual(sut.summaryID, "\(String.getType(from: Item.self))#\(item.identifier)")
    }
    
    func testItemName_whenInitFromItem() {
        XCTAssertEqual(sut.itemName, .getType(from: CharacterSummary<Item>.self))
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
    
    func testCount_whenInitFromItem() {
        XCTAssertEqual(sut.count, count)
    }

}
