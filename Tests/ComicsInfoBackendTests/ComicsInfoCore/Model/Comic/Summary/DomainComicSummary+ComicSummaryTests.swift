//
//  DomainComicSummary+ComicSummaryTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import struct Domain.ComicSummary
import XCTest

final class DomainComicSummary_ComicSummaryTests: XCTestCase {

    private var summary: ComicsInfoCore.ComicSummary!
    private var sut: Domain.ComicSummary!
    
    override func setUpWithError() throws {
        summary = ComicSummaryFactory.make()
        sut = Domain.ComicSummary(from: summary)
    }

    override func tearDownWithError() throws {
        summary = nil
        sut = nil
    }

    func testIdentifier_whenInitFromSummary() {
        XCTAssertEqual(
            sut.identifier,
            summary.itemID.replacingOccurrences(of: "\(String.getType(from: ComicSummary.self))#", with: "")
        )
    }
    
    func testPopularity_whenInitFromSummary() {
        XCTAssertEqual(sut.popularity, summary.popularity)
    }
    
    func testTitle_whenInitFromSummary() {
        XCTAssertEqual(sut.title, summary.name)
    }
    
    func testThumbnail_whenInitFromSummary() {
        XCTAssertEqual(sut.thumbnail, summary.thumbnail)
    }
    
    func testDescription_whenInitFromSummary() {
        XCTAssertEqual(sut.description, summary.description)
    }
    
    func testNumber_whenInitFromSummary() {
        XCTAssertEqual(sut.number, summary.number)
    }
    
}
