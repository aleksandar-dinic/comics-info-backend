//
//  ItemSummaryInitWithComicTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 15/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class ItemSummaryInitWithComicTests: XCTestCase {

    private var comic: Comic!
    private var itemName: String!
    private var summaryName: String!
    private var id: String!
    private var sut: ItemSummary<Comic>!

    override func setUpWithError() throws {
        comic = ComicMock.comic
        itemName = "comic"
        summaryName = "comic"
        id = "2"
        sut = ItemSummary(comic, id: id, itemName: itemName)
    }

    override func tearDownWithError() throws {
        comic = nil
        itemName = nil
        id = nil
        sut = nil
    }

    func testID_whenInitWithComic_isEqualToComicID() {
        XCTAssertEqual(sut.id, comic.id)
    }

    func testPopularity_whenInitWithComic_isEqualToComicPopularity() {
        XCTAssertEqual(sut.popularity, comic.popularity)
    }

    func testName_whenInitWithComic_isEqualToComicTitle() {
        XCTAssertEqual(sut.name, comic.title)
    }
    
    func testDateAdded_whenInitWithComic_isEqualToComicDateAdded() {
        XCTAssertNotEqual(sut.dateAdded, comic.dateAdded)
    }
    
    func testDateLastUpdated_whenInitWithComic_isEqualToComicDateLastUpdated() {
        XCTAssertNotEqual(sut.dateLastUpdated, comic.dateLastUpdated)
    }

    func testThumbnail_whenInitWithComic_isEqualToComicThumbnail() {
        XCTAssertEqual(sut.thumbnail, comic.thumbnail)
    }

    func testDescription_whenInitWithComic_isEqualToComicDescription() {
        XCTAssertEqual(sut.description, comic.description)
    }

    func testItemName_whenInitWithComic_isEqualToItemName() {
        XCTAssertEqual(sut.itemName, itemName)
    }
    
    func testSummaryName_whenInitWithComic_isEqualToSummaryName() {
        XCTAssertEqual(sut.summaryName, summaryName)
    }

    func testItemID_whenInitWithComic_isEqualToItemID() throws {
        let itemName = try XCTUnwrap(self.itemName)
        let id = try XCTUnwrap(self.id)
        XCTAssertEqual(sut.itemID, "\(itemName)#\(id)")
    }

    func testSummaryID_whenInitWithComic_isEqualToSummaryID() {
        XCTAssertEqual(sut.summaryID, "comic#\(comic.id)")
    }

}
