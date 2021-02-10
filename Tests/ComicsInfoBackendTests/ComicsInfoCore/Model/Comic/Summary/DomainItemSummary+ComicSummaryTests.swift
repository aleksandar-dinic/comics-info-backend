//
//  DomainItemSummary+ComicSummaryTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import struct Domain.ItemSummary
import XCTest

final class DomainItemSummary_ComicSummaryTests: XCTestCase {

    private var summary: ComicSummary!
    private var sut: Domain.ItemSummary!
    
    override func setUpWithError() throws {
        summary = ComicSummaryFactory.make()
        sut = Domain.ItemSummary(from: summary)
    }

    override func tearDownWithError() throws {
        summary = nil
        sut = nil
    }

    func testIdentifier_whenInitFromSummary() {
        XCTAssertEqual(
            sut.identifier,
            summary.summaryID.replacingOccurrences(of: "\(String.getType(from: Comic.self))#", with: "")
        )
    }
    
    func testPopularity_whenInitFromSummary() {
        XCTAssertEqual(sut.popularity, summary.popularity)
    }
    
    func testName_whenInitFromSummary() {
        XCTAssertEqual(sut.name, summary.name)
    }
    
    func testThumbnail_whenInitFromSummary() {
        XCTAssertEqual(sut.thumbnail, summary.thumbnail)
    }
    
    func testDescription_whenInitFromSummary() {
        XCTAssertEqual(sut.description, summary.description)
    }
    
    func testCount_whenInitFromSummary() {
        XCTAssertNil(sut.count)
    }
    
    func testNumber_whenInitFromSummary() {
        XCTAssertEqual(sut.number, summary.number)
    }
    
    func testRoles_whenInitFromSummary() {
        XCTAssertNil(sut.roles)
    }

}
