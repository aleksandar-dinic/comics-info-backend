//
//  ComicSummaryInitWithComicTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 15/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class ComicSummaryInitWithComicTests: XCTestCase {

    private var comic: Comic!
    private var itemName: String!
    private var id: String!
    private var sut: ComicSummary!

    override func setUpWithError() throws {
        comic = ComicMock.comic
        itemName = "comic"
        id = "2"
        sut = ComicSummary(comic, id: id, itemName: itemName)
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

    func testTitle_whenInitWithComic_isEqualToComicTitle() {
        XCTAssertEqual(sut.title, comic.title)
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

    func testItemID_whenInitWithComic_isEqualToItemID() throws {
        let itemName = try XCTUnwrap(self.itemName)
        let id = try XCTUnwrap(self.id)
        XCTAssertEqual(sut.itemID, "\(itemName)#\(id)")
    }

    func testSummaryID_whenInitWithComic_isEqualToSummaryID() {
        XCTAssertEqual(sut.summaryID, "comic#\(comic.id)")
    }

}
