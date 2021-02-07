//
//  CreateDataProviderTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 06/02/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class CreateDataProviderTests: XCTestCase {
    
    private var sut: CreateDataProvider!
    private var table: String!

    override func setUpWithError() throws {
        TestDatabase.removeAll()
        sut = CreateDataProviderFactory.make()
        table = "TEST"
    }

    override func tearDownWithError() throws {
        sut = nil
        table = nil
    }

    // Create
    
    func test_whenCreate_itemIsCreated() throws {
        // Given
        let item = MockComicInfoItemFactory.make()
        
        // When
        let feature = sut.create(item, in: table)
        
        // Then
        XCTAssertNoThrow(try feature.wait())
    }
    
    // Create Summaries
    
    func test_whenCreateSummaries_summaryIsCreated() throws {
        // Given
        let summary = MockItemSummaryFactory.make()
        
        // When
        let feature = sut.createSummaries([summary], in: table)
        
        // Then
        XCTAssertNoThrow(try feature.wait())
    }
    
}
