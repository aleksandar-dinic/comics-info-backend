//
//  DomainSeriesSummary+SeriesSummaryTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import struct Domain.SeriesSummary
import XCTest

final class DomainSeriesSummary_SeriesSummaryTests: XCTestCase {
    
    private var summary: ComicsInfoCore.SeriesSummary!
    private var sut: Domain.SeriesSummary!
    
    override func setUpWithError() throws {
        summary = SeriesSummaryFactory.make()
        sut = Domain.SeriesSummary(from: summary)
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
    
    func testTitle_whenInitFromSummary() {
        XCTAssertEqual(sut.title, summary.name)
    }
    
    func testThumbnail_whenInitFromSummary() {
        XCTAssertEqual(sut.thumbnail, summary.thumbnail)
    }
    
    func testDescription_whenInitFromSummary() {
        XCTAssertEqual(sut.description, summary.description)
    }
    
}
