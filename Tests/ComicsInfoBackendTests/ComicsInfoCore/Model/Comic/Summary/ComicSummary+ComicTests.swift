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

    private var comic: Comic!
    private var series: Series!
    private var sut: ComicSummary!
    
    override func setUpWithError() throws {
        comic = ComicFactory.make(ID: "ComicID")
        series = SeriesFactory.make(ID: "SeriesID")
        sut = ComicSummary(comic, link: series)
    }

    override func tearDownWithError() throws {
        comic = nil
        series = nil
        sut = nil
    }
    
    func testItemID_whenInitFromComic() throws {
        XCTAssertEqual(sut.itemID, "\(String.getType(from: ComicSummary.self))#\(comic.id)")
    }
    
    func testSummaryID_whenInitFromComic() {
        XCTAssertEqual(sut.summaryID, "\(String.getType(from: SeriesSummary.self))#\(series.id)")
    }
    
    func testItemType_whenInitFromComic() {
        XCTAssertEqual(sut.itemType, .getType(from: ComicSummary.self))
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
        XCTAssertEqual(sut.number, comic.number)
    }

}
