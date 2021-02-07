//
//  CreateRepositoryTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 06/02/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class CreateRepositoryTests: XCTestCase {
    
    private var sut: CreateRepository!
    private var table: String!

    override func setUpWithError() throws {
        TestDatabase.removeAll()
        table = "TEST"
    }

    override func tearDownWithError() throws {
        table = nil
    }

    // Create
    
    func test_whenCreate_itemIsCreated() throws {
        // Given
        let item = MockComicInfoItemFactory.make()
        sut = CreateRepositoryFactory.make()
        
        // When
        let feature = sut.create(item, in: table)
        
        // Then
        XCTAssertNoThrow(try feature.wait())
    }
    
    // Create Summaries
    
    func test_whenCreateSummaries_summaryIsCreated() throws {
        // Given
        let summary = MockItemSummaryFactory.make()
        sut = CreateRepositoryFactory.make()
        
        // When
        let feature = sut.createSummaries([summary], in: table)
        
        // Then
        XCTAssertNoThrow(try feature.wait())
    }
    
}
