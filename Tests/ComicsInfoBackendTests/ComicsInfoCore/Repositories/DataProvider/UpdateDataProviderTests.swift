//
//  UpdateDataProviderTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 06/02/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class UpdateDataProviderTests: XCTestCase {
    
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
        let sut = UpdateDataProviderFactory.make(items: itemData)
        
        // When
        let feature = sut.update(item, in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }
    
    // Update Summaries
    
    func test_whenUpdateSummaries_summariesUpdated() throws {
        // Given
        let item = MockItemSummaryFactory.make()
        let sut = UpdateDataProviderFactory.make()
        
        // When
        let feature = sut.updateSummaries([item], in: table, strategy: .default)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }
    
}
