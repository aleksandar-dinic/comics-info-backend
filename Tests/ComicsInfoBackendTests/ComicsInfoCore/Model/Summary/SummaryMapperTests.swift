//
//  SummaryMapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 29/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class SummaryMapperTests: XCTestCase {
    
    private var summaryMapper: SummaryMapperMock!

    override func setUpWithError() throws {
        summaryMapper = SummaryMapperMock.make()
    }

    override func tearDownWithError() throws {
        summaryMapper = nil
    }

    func testSummaryMapper_whenShouldUpdateExistingSummariesWithPopularity_isTrue() {
        // Given
        let fields = Set(arrayLiteral: "popularity")
        
        // When
        let shouldUpdate = summaryMapper.shouldUpdateExistingSummaries(fields)
        
        // Then
        XCTAssertTrue(shouldUpdate)
    }

    func testSummaryMapper_whenShouldUpdateExistingSummariesWithName_isTrue() {
        // Given
        let fields = Set(arrayLiteral: "name")
        
        // When
        let shouldUpdate = summaryMapper.shouldUpdateExistingSummaries(fields)
        
        // Then
        XCTAssertTrue(shouldUpdate)
    }
    
    func testSummaryMapper_whenShouldUpdateExistingSummariesWithTitle_isTrue() {
        // Given
        let fields = Set(arrayLiteral: "title")
        
        // When
        let shouldUpdate = summaryMapper.shouldUpdateExistingSummaries(fields)
        
        // Then
        XCTAssertTrue(shouldUpdate)
    }
    
    func testSummaryMapper_whenShouldUpdateExistingSummariesWithThumbnail_isTrue() {
        // Given
        let fields = Set(arrayLiteral: "thumbnail")
        
        // When
        let shouldUpdate = summaryMapper.shouldUpdateExistingSummaries(fields)
        
        // Then
        XCTAssertTrue(shouldUpdate)
    }
    
    func testSummaryMapper_whenShouldUpdateExistingSummariesWithDescription_isTrue() {
        // Given
        let fields = Set(arrayLiteral: "description")
        
        // When
        let shouldUpdate = summaryMapper.shouldUpdateExistingSummaries(fields)
        
        // Then
        XCTAssertTrue(shouldUpdate)
    }
    
    func testSummaryMapper_whenShouldUpdateExistingSummariesWithUnknown_isFalse() {
        // Given
        let fields = Set(arrayLiteral: "unknown")
        
        // When
        let shouldUpdate = summaryMapper.shouldUpdateExistingSummaries(fields)
        
        // Then
        XCTAssertFalse(shouldUpdate)
    }

}
