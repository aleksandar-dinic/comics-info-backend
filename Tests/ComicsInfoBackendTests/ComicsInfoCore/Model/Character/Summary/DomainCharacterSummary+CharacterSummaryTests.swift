//
//  DomainCharacterSummary+CharacterSummaryTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import struct Domain.CharacterSummary
import XCTest

final class DomainCharacterSummary_CharacterSummaryTests: XCTestCase {
    
    private var summary: ComicsInfoCore.CharacterSummary!
    private var sut: Domain.CharacterSummary!
    
    override func setUpWithError() throws {
        summary = CharacterSummaryFactory.make()
        sut = Domain.CharacterSummary(from: summary)
    }

    override func tearDownWithError() throws {
        summary = nil
        sut = nil
    }

    func testIdentifier_whenInitFromSummary() {
        XCTAssertEqual(
            sut.identifier,
            summary.itemID.replacingOccurrences(of: "\(String.getType(from: CharacterSummary.self))#", with: "")
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
        XCTAssertEqual(sut.count, summary.count)
    }
    
}
