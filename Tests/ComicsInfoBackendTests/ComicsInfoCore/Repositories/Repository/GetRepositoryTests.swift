//
//  GetRepositoryTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 06/02/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest
import NIO

final class GetRepositoryTests: XCTestCase {

    private var sut: GetRepository<MockComicInfoItem, TestCache<MockComicInfoItem>>!
    private var table: String!
    
    override func setUpWithError() throws {
        TestDatabase.removeAll()
        table = "TEST"
    }

    override func tearDownWithError() throws {
        table = nil
    }
    
    // Get Item

    func test_whenGetItemWithID_returnsItem() throws {
        // Given
        let givenItem = MockComicInfoItemFactory.make()
        let criteria = GetItemCriteria(itemID: givenItem.id, dataSource: .database, table: table)
        let items = MockComicInfoItemFactory.makeData()
        sut = GetRepositoryFactory.make(items: items)

        // When
        let feature = sut.getItem(with: criteria)
        let item = try feature.wait()

        // Then
        XCTAssertEqual(item.id, givenItem.id)
    }
    
    // Get Items

    func test_whenGetItems_returnsItems() throws {
        // Given
        let givenItem = MockComicInfoItemFactory.make()
        let criteria = GetItemsCriteria(IDs: [givenItem.id], dataSource: .database, table: table)
        let databaseItems = MockComicInfoItemFactory.makeData()
        sut = GetRepositoryFactory.make(items: databaseItems)

        // When
        let feature = sut.getItems(with: criteria)
        let items = try feature.wait()

        // Then
        XCTAssertEqual(items.map { $0.id }, [givenItem.id])
    }
    
    // Get All Items

    func test_whenGetAllItems_returnsItems() throws {
        // Given
        let givenItem = MockComicInfoItemFactory.make()
        let criteria = GetAllItemsCriteria(dataSource: .database, table: table)
        let databaseItems = MockComicInfoItemFactory.makeData()
        sut = GetRepositoryFactory.make(items: databaseItems)
        
        // When
        let feature = sut.getAllItems(with: criteria)
        let items = try feature.wait()

        // Then
        XCTAssertEqual(items.map { $0.id }, [givenItem.id])
    }
    
    // Get Summaries

    func test_whenGetSummaries_returnsSummaries() throws {
        // Given
        let givenItem = MockItemSummaryFactory.make()
        let criteria = GetSummariesCriteria(MockItemSummary.self, ID: givenItem.itemID, dataSource: .database, table: table, strategy: .summaryID)
        let databaseItems = MockItemSummaryFactory.makeData()
        sut = GetRepositoryFactory.make(items: databaseItems)

        // When
        let feature: EventLoopFuture<[MockItemSummary]?> = sut.getSummaries(with: criteria)
        let items = try feature.wait()

        // Then
        let summaries = try XCTUnwrap(items)
        XCTAssertEqual(summaries.map { $0.itemID }, [givenItem.itemID])
    }
    
}
