//
//  ItemUpdateDBWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class ItemUpdateDBWrapperTests: XCTestCase {
    
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
        let sut = ItemUpdateDBWrapperFactory.make(items: itemData)
        
        // When
        let feature = sut.update(item, in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }
    
    func test_whenUpdateItem_throwsItemNotFound() throws {
        // Given
        let item = MockComicInfoItemFactory.make()
        let sut = ItemUpdateDBWrapperFactory.make()
        var thrownError: Error?
        
        // When
        let feature = sut.update(item, in: table)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemNotFound(let ID, let itemType) = error as? ComicInfoError {
            XCTAssertEqual(ID, item.id)
            XCTAssertTrue(itemType == MockComicInfoItem.self)
        } else {
            XCTFail("Expected '.itemNotFound' but got \(error)")
        }
    }
    
    // Update Summaries
    
    func test_whenUpdateSummaries_summariesUpdated() throws {
        // Given
        let item = MockItemSummaryFactory.make()
        let sut = ItemUpdateDBWrapperFactory.make()
        
        // When
        let feature = sut.updateSummaries([item], in: table, strategy: .default)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }
    
}
