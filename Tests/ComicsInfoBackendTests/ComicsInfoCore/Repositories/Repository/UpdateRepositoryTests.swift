//
//  UpdateRepositoryTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 06/02/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class UpdateRepositoryTests: XCTestCase {
    
    private var sut: UpdateRepository!
    private var table: String!
    
    override func setUpWithError() throws {
        TestDatabase.removeAll()
        table = "TEST"
    }

    override func tearDownWithError() throws {
        table = nil
    }
    
    // Update
    
    func test_whenUpdateItem_itemUpdated() throws {
        // Given
        let item = MockComicInfoItemFactory.make()
        let itemData = MockComicInfoItemFactory.makeData()
        sut = UpdateRepositoryFactory.make(items: itemData)
        
        // When
        let feature = sut.update(item, in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }
    
    // Update Summaries
    
    func test_whenUpdateSummaries_summariesUpdated() throws {
        // Given
        let item = MockItemSummaryFactory.make()
        sut = UpdateRepositoryFactory.make()
        
        // When
        let feature = sut.updateSummaries([item], in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }
    
}
