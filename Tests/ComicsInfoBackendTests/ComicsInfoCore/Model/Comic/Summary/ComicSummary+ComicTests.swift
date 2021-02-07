//
//  ComicSummary+ComicTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class ComicSummary_ComicTests: XCTestCase {

    private typealias Item = Series
    
    private var comic: Comic!
    private var id: String!
    private var number: String!
    private var sut: ComicSummary<Item>!
    
    override func setUpWithError() throws {
        comic = ComicFactory.make()
        id = "1"
        number = "1"
        sut = ComicSummary<Item>(comic, id: id, number: number)
    }

    override func tearDownWithError() throws {
        comic = nil
        id = nil
        number = nil
        sut = nil
    }
    
    func testItemID_whenInitFromComic() throws {
        let id = try XCTUnwrap(self.id)
        XCTAssertEqual(sut.itemID, "\(String.getType(from: Comic.self))#\(id)")
    }
    
    func testSummaryID_whenInitFromComic() {
        XCTAssertEqual(sut.summaryID, "\(String.getType(from: Item.self))#\(comic.id)")
    }
    
    func testItemName_whenInitFromComic() {
        XCTAssertEqual(sut.itemName, .getType(from: ComicSummary<Item>.self))
    }
    
    func testDateAdded_whenInitFromComic() {
        XCTAssertEqual(
            Calendar.current.compare(sut.dateAdded, to: Date(), toGranularity: .hour),
            .orderedSame
        )
    }
    
    func testDateLastUpdated_whenInitFromComic() {
        XCTAssertEqual(
            Calendar.current.compare(sut.dateLastUpdated, to: Date(), toGranularity: .hour),
            .orderedSame
        )
    }
    
    func testPopularity_whenInitFromComic() {
        XCTAssertEqual(sut.popularity, comic.popularity)
    }
    
    func testName_whenInitFromComic() {
        XCTAssertEqual(sut.name, comic.name)
    }
    
    func testThumbnail_whenInitFromComic() {
        XCTAssertEqual(sut.thumbnail, comic.thumbnail)
    }
    
    func testDescription_whenInitFromComic() {
        XCTAssertEqual(sut.description, comic.description)
    }
    
    func testNumber_whenInitFromComic() {
        XCTAssertEqual(sut.number, number)
    }

}
