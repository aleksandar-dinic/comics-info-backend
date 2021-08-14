//
//  DomainItemSummary+SeriesSummaryTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import struct Domain.ItemSummary
import XCTest

final class DomainItemSummary_SeriesSummaryTests: XCTestCase {
    
    private var summary: SeriesSummary!
    private var sut: Domain.ItemSummary!
    
    override func setUpWithError() throws {
        summary = SeriesSummaryFactory.make()
        sut = Domain.ItemSummary(from: summary)
    }

    override func tearDownWithError() throws {
        summary = nil
        sut = nil
    }

    func testIdentifier_whenInitFromSummary() {
        XCTAssertEqual(
            sut.identifier,
            summary.itemID.replacingOccurrences(of: "\(String.getType(from: SeriesSummary.self))#", with: "")
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
        XCTAssertNil(sut.number)
    }
    
    func testRoles_whenInitFromSummary() {
        XCTAssertNil(sut.roles)
    }

}
