//
//  ItemUpdateDBWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest
import NIO

final class ItemUpdateDBWrapperTests: XCTestCase {
    
    private var eventLoop: EventLoop!
    private var table: String!
    
    override func setUpWithError() throws {
        TestDatabase.removeAll()
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        table = "TEST"
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        table = nil
    }
    
    // Update
    
    func test_whenUpdateItem_itemUpdated() throws {
        // Given
        let item = MockComicInfoItemFactory.make()
        let itemData = MockComicInfoItemFactory.makeData()
        let criteria = UpdateItemCriteria(item: item, oldSortValue: item.sortValue, on: eventLoop, in: table)
        let sut = ItemUpdateDBWrapperFactory.make(items: itemData)
        
        // When
        let feature = sut.update(with: criteria)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }
    
    func test_whenUpdateItem_throwsItemNotFound() throws {
        // Given
        let item = MockComicInfoItemFactory.make()
        let sut = ItemUpdateDBWrapperFactory.make()
        let criteria = UpdateItemCriteria(item: item, oldSortValue: item.sortValue, on: eventLoop, in: table)
        var thrownError: Error?
        
        // When
        let feature = sut.update(with: criteria)
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
        let criteria = UpdateSummariesCriteria(items: [item], table: table)
        let sut = ItemUpdateDBWrapperFactory.make()
        
        // When
        let feature = sut.updateSummaries(with: criteria)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }
    
}
