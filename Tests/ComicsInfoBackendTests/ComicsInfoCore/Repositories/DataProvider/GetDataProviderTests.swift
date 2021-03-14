//
//  GetDataProviderTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 06/02/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest
import NIO

final class GetDataProviderTests: XCTestCase {
    
    private var sut: GetDataProvider<MockComicInfoItem, TestCache<MockComicInfoItem>>!
    private var table: String!

    override func setUpWithError() throws {
        sut = GetDataProviderFactory.make()
        table = "TEST"
    }

    override func tearDownWithError() throws {
        sut = nil
        table = nil
    }

}

// Get Item

extension GetDataProviderTests {
    
    func test_whenGetItemFromMemory_retursItem() throws {
        // Given
        let givenItem = MockComicInfoItemFactory.make()
        let criteria = GetItemCriteria(ID: givenItem.id, dataSource: .memory, table: table)
        let cash = TestCache<MockComicInfoItem>(itemsCaches: [table: [givenItem.id: givenItem]])
        sut = GetDataProviderFactory.make(cacheProvider: cash)
        
        // When
        let feature = sut.getItem(with: criteria)
        let item = try feature.wait()
        
        // Then
        XCTAssertEqual(item.id, givenItem.id)
    }
    
    func test_whenGetItemFromDatabase_retursItem() throws {
        // Given
        let givenItem = MockComicInfoItemFactory.make()
        let criteria = GetItemCriteria(ID: givenItem.id, dataSource: .database, table: table)
        let itemData = MockComicInfoItemFactory.makeData()
        sut = GetDataProviderFactory.make(items: itemData)
        
        // When
        let feature = sut.getItem(with: criteria)
        let item = try feature.wait()
        
        // Then
        XCTAssertEqual(item.id, givenItem.id)
    }
    
    func test_whenGetItem_throwsItemNotFound() throws {
        // Given
        let id = "-1"
        let criteria = GetItemCriteria(ID: id, dataSource: .memory, table: table)
        var thrownError: Error?
        
        // When
        let feature = sut.getItem(with: criteria)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }
        
        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemNotFound(let ID, let itemType) = error as? ComicInfoError {
            XCTAssertEqual(ID, id)
            XCTAssertTrue(itemType == MockComicInfoItem.self)
        } else {
            XCTFail("Expected '.itemNotFound' but got \(error)")
        }
    }
    
    func test_whenGetItemFromEmptyMemory_retursItemFromDatabase() throws {
        // Given
        let givenItem = MockComicInfoItemFactory.make()
        let criteria = GetItemCriteria(ID: givenItem.id, dataSource: .memory, table: table)
        let itemData = MockComicInfoItemFactory.makeData()
        sut = GetDataProviderFactory.make(items: itemData)
        
        // When
        let feature = sut.getItem(with: criteria)
        let item = try feature.wait()
        
        // Then
        XCTAssertEqual(item.id, givenItem.id)
    }
    
    func test_whenGetItemFromEmptyMemory_saveItemInCache() throws {
        // Given
        let givenItem = MockComicInfoItemFactory.make()
        let criteria = GetItemCriteria(ID: givenItem.id, dataSource: .memory, table: table)
        let cache = TestCache<MockComicInfoItem>()
        let itemData = MockComicInfoItemFactory.makeData()
        sut = GetDataProviderFactory.make(cacheProvider: cache, items: itemData)
        
        // When
        let feature = sut.getItem(with: criteria)
        XCTAssertNoThrow(try feature.wait())
        
        // Then
        let result = cache.getItem(withID: givenItem.id, from: table)
        switch result {
        case let .success(item):
            XCTAssertEqual(item.id, givenItem.id)
        case let .failure(error):
            XCTFail(error.localizedDescription)
        }
    }

}

// Get Items

extension GetDataProviderTests {
    
    func test_whenGetItemsFromMemory_retursItems() throws {
        // Given
        let givenItem = MockComicInfoItemFactory.make()
        let criteria = GetItemsCriteria(IDs: [givenItem.id], dataSource: .memory, table: table)
        let cash = TestCache<MockComicInfoItem>(itemsCaches: [table: [givenItem.id: givenItem]])
        sut = GetDataProviderFactory.make(cacheProvider: cash)
        
        // When
        let feature = sut.getItems(with: criteria)
        let items = try feature.wait()
        
        // Then
        XCTAssertEqual(items.map { $0.id }, [givenItem.id])
    }
    
    func test_whenGetItemsFromDatabase_retursItems() throws {
        // Given
        let givenItem = MockComicInfoItemFactory.make()
        let criteria = GetItemsCriteria(IDs: [givenItem.id], dataSource: .database, table: table)
        let itemData = MockComicInfoItemFactory.makeData()
        sut = GetDataProviderFactory.make(items: itemData)
        
        // When
        let feature = sut.getItems(with: criteria)
        let items = try feature.wait()
        
        // Then
        XCTAssertEqual(items.map { $0.id }, [givenItem.id])
    }
    
    func test_whenGetItems_throwsItemsNotFound() throws {
        // Given
        let id = "-1"
        let criteria = GetItemsCriteria(IDs: [id], dataSource: .memory, table: table)
        var thrownError: Error?
        
        // When
        let feature = sut.getItems(with: criteria)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }
        
        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemsNotFound(let IDs, let itemType) = error as? ComicInfoError {
            XCTAssertEqual(IDs, [id])
            XCTAssertTrue(itemType == MockComicInfoItem.self)
        } else {
            XCTFail("Expected '.itemsNotFound' but got \(error)")
        }
    }
    
    func test_whenGetItemsFromEmptyMemory_retursItemsFromDatabase() throws {
        // Given
        let givenItem = MockComicInfoItemFactory.make()
        let criteria = GetItemsCriteria(IDs: [givenItem.id], dataSource: .memory, table: table)
        let itemData = MockComicInfoItemFactory.makeData()
        sut = GetDataProviderFactory.make(items: itemData)
        
        // When
        let feature = sut.getItems(with: criteria)
        let items = try feature.wait()
        
        // Then
        XCTAssertEqual(items.map { $0.id }, [givenItem.id])
    }
    
    func test_whenGetItemsFromEmptyMemory_saveItemsInCache() throws {
        // Given
        let givenItem = MockComicInfoItemFactory.make()
        let criteria = GetItemsCriteria(IDs: [givenItem.id], dataSource: .memory, table: table)
        let cache = TestCache<MockComicInfoItem>()
        let itemData = MockComicInfoItemFactory.makeData()
        sut = GetDataProviderFactory.make(cacheProvider: cache, items: itemData)
        
        // When
        let feature = sut.getItems(with: criteria)
        XCTAssertNoThrow(try feature.wait())
        
        // Then
        let result = cache.getItems(withIDs: [givenItem.id], from: table)
        XCTAssertEqual(result.items.map { $0.id }, [givenItem.id])
        XCTAssertTrue(result.missingIDs.isEmpty)
    }
    
    func test_whenGetItemsOneFromMemoryOneFromDatabase_retursItems() throws {
        // Given
        let itemInCache = MockComicInfoItemFactory.make(id: "2")
        let cash = TestCache<MockComicInfoItem>(itemsCaches: [table: [itemInCache.id: itemInCache]])

        let itemInDatabase = MockComicInfoItemFactory.make(ID: "5")
        sut = GetDataProviderFactory.make(
            cacheProvider: cash,
            items: [itemInDatabase.itemID: try JSONEncoder().encode(itemInDatabase)]
        )
        let criteria = GetItemsCriteria(IDs: [itemInDatabase.id, itemInCache.id], dataSource: .memory, table: table)
        
        // When
        let feature = sut.getItems(with: criteria)
        let items = try feature.wait()
        
        // Then
        XCTAssertEqual(items.map { $0.id }.sorted(), [itemInDatabase.id, itemInCache.id].sorted())
    }
    
}

// Get all items

extension GetDataProviderTests {
 
    func test_whenGetAllItemsFromMemory_retursItems() throws {
        // Given
        let givenItem = MockComicInfoItemFactory.make()
        let criteria = GetAllItemsCriteria(summaryID: nil, dataSource: .memory, table: table)
        let cash = TestCache<MockComicInfoItem>(itemsCaches: [table: [givenItem.id: givenItem]])
        sut = GetDataProviderFactory.make(cacheProvider: cash)
        
        // When
        let feature = sut.getAllItems(with: criteria)
        let items = try feature.wait()
        
        // Then
        XCTAssertEqual(items.map { $0.id }, [givenItem.id])
    }
    
    func test_whenGetAllItemsFromDatabase_retursItems() throws {
        // Given
        let givenItem = MockComicInfoItemFactory.make()
        let criteria = GetAllItemsCriteria(summaryID: nil, dataSource: .database, table: table)
        let itemData = MockComicInfoItemFactory.makeData()
        sut = GetDataProviderFactory.make(items: itemData)
        
        // When
        let feature = sut.getAllItems(with: criteria)
        let items = try feature.wait()
        
        // Then
        XCTAssertEqual(items.map { $0.id }, [givenItem.id])
    }
    
    func test_whenGetAllItems_throwsItemsNotFound() throws {
        // Given
        let criteria = GetAllItemsCriteria(summaryID: nil, dataSource: .memory, table: table)
        var thrownError: Error?
        
        // When
        let feature = sut.getAllItems(with: criteria)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }
        
        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemsNotFound(let IDs, let itemType) = error as? ComicInfoError {
            XCTAssertNil(IDs)
            XCTAssertTrue(itemType == MockComicInfoItem.self)
        } else {
            XCTFail("Expected '.itemsNotFound' but got \(error)")
        }
    }
    
    func test_whenGetAllItemsFromEmptyMemory_retursItemsFromDatabase() throws {
        // Given
        let givenItem = MockComicInfoItemFactory.make()
        let criteria = GetAllItemsCriteria(summaryID: nil, dataSource: .memory, table: table)
        let itemData = MockComicInfoItemFactory.makeData()
        sut = GetDataProviderFactory.make(items: itemData)
        
        // When
        let feature = sut.getAllItems(with: criteria)
        let items = try feature.wait()
        
        // Then
        XCTAssertEqual(items.map { $0.id }, [givenItem.id])
    }
    
    func test_whenGetAllItemsFromEmptyMemory_saveItemsInCache() throws {
        // Given
        let givenItem = MockComicInfoItemFactory.make()
        let criteria = GetAllItemsCriteria(summaryID: nil, dataSource: .memory, table: table)
        let cache = TestCache<MockComicInfoItem>()
        let itemData = MockComicInfoItemFactory.makeData()
        sut = GetDataProviderFactory.make(cacheProvider: cache, items: itemData)
        
        // When
        let feature = sut.getAllItems(with: criteria)
        XCTAssertNoThrow(try feature.wait())
        
        // Then
        let result = cache.getAllItems(forSummaryID: nil, from: table)
        switch result {
        case let .success(items):
            XCTAssertEqual(items.map { $0.id }, [givenItem.id])
        case let .failure(error):
            XCTFail(error.localizedDescription)
        }
    }
    
}

// Get Summaries

extension GetDataProviderTests {
 
    func test_whenGetSummariesFromMemory_retursSummaries() throws {
        // Given
        let givenItem = MockItemSummaryFactory.make()
        let criteria = GetSummariesCriteria(MockItemSummary.self, ID: "1", dataSource: .memory, table: table, strategy: .summaryID)
        let cash = TestCache<MockComicInfoItem>(itemsSummaries: [table: [givenItem.itemID: givenItem]])
        sut = GetDataProviderFactory.make(cacheProvider: cash)
        
        // When
        let feature = sut.getSummaries(with: criteria)
        let items = try feature.wait()
        
        // Then
        XCTAssertEqual(items?.map { $0.itemID }, [givenItem.itemID])
    }
    
    func test_whenGetSummariesFromDatabase_retursSummaries() throws {
        // Given
        let givenItem = MockItemSummaryFactory.make()
        let criteria = GetSummariesCriteria(MockItemSummary.self, ID: givenItem.itemID, dataSource: .database, table: table, strategy: .summaryID)
        let itemData = MockItemSummaryFactory.makeData()
        sut = GetDataProviderFactory.make(items: itemData)
        
        // When
        let feature = sut.getSummaries(with: criteria)
        let items = try feature.wait()
        
        // Then
        XCTAssertEqual(items?.map { $0.itemID }, [givenItem.itemID])
    }
    
    func test_whenGetSummaries_returnsNil() throws {
        // Given
        let criteria = GetSummariesCriteria(MockItemSummary.self, ID: "-1", dataSource: .memory, table: table, strategy: .summaryID)
        
        // When
        let feature = sut.getSummaries(with: criteria)
        let items = try feature.wait()
        
        // Then
        XCTAssertNil(items)
    }
    
    func test_whenGetSummariesFromEmptyMemory_retursSummariesFromDatabase() throws {
        // Given
        let givenItem = MockItemSummaryFactory.make()
        let criteria = GetSummariesCriteria(MockItemSummary.self, ID: givenItem.itemID, dataSource: .memory, table: table, strategy: .summaryID)
        let itemData = MockItemSummaryFactory.makeData()
        sut = GetDataProviderFactory.make(items: itemData)
        
        // When
        let feature = sut.getSummaries(with: criteria)
        let items = try feature.wait()
        
        // Then
        XCTAssertEqual(items?.map { $0.itemID }, [givenItem.itemID])
    }
    
    func test_whenGetSummariesFromEmptyMemory_saveSummariesInCache() throws {
        // Given
        let givenItem = MockItemSummaryFactory.make()
        let criteria = GetSummariesCriteria(MockItemSummary.self, ID: "", dataSource: .memory, table: table, strategy: .summaryID)
        let cache = TestCache<MockComicInfoItem>()
        let itemData = MockItemSummaryFactory.makeData()
        sut = GetDataProviderFactory.make(cacheProvider: cache, items: itemData)
        
        // When
        let feature = sut.getSummaries(with: criteria)
        XCTAssertNoThrow(try feature.wait())
        
        // Then
        let result: Result<[MockItemSummary], CacheError<MockComicInfoItem>> = cache.getSummaries(forID: "", from: table)
        switch result {
        case let .success(items):
            XCTAssertEqual(items.map { $0.itemID }, [givenItem.itemID])
        case let .failure(error):
            XCTFail(error.localizedDescription)
        }
    }
    
}
