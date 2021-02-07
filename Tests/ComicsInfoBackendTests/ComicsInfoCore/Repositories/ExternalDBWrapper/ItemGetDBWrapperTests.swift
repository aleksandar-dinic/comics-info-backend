//
//  ItemGetDBWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest
import NIO

final class ItemGetDBWrapperTests: XCTestCase {

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
        let items = MockComicInfoItemFactory.makeData()
        let sut = ItemGetDBWrapperFactory.make(items: items)

        // When
        let feature = sut.getItem(withID: givenItem.id, from: table)
        let item = try feature.wait()

        // Then
        XCTAssertEqual(item.id, givenItem.id)
    }
    
    func test_whenGetItemWithID_throwsItemNotFound() throws {
        // Given
        let id = "-1"
        let sut = ItemGetDBWrapperFactory.make()
        var thrownError: Error?

        // When
        let feature = sut.getItem(withID: id, from: table)
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
    
    // Get Items

    func test_whenGetItems_returnsItems() throws {
        // Given
        let givenItem = MockComicInfoItemFactory.make()
        let databaseItems = MockComicInfoItemFactory.makeData()
        let sut = ItemGetDBWrapperFactory.make(items: databaseItems)

        // When
        let feature = sut.getItems(withIDs: [givenItem.id], from: table)
        let items = try feature.wait()

        // Then
        XCTAssertEqual(items.map { $0.id }, [givenItem.id])
    }
    
    func test_whenGetItems_throwsItemsNotFound() throws {
        // Given
        let ids: Set<String> = ["-1"]
        let sut = ItemGetDBWrapperFactory.make()
        var thrownError: Error?

        // When
        let feature = sut.getItems(withIDs: ids, from: table)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemsNotFound(let IDs, let itemType) = error as? ComicInfoError {
            XCTAssertEqual(IDs, ids)
            XCTAssertTrue(itemType == MockComicInfoItem.self)
        } else {
            XCTFail("Expected '.itemsNotFound' but got \(error)")
        }
    }
    
    // Get All Items

    func test_whenGetAllItems_returnsItems() throws {
        // Given
        let givenItem = MockComicInfoItemFactory.make()
        let databaseItems = MockComicInfoItemFactory.makeData()
        let sut = ItemGetDBWrapperFactory.make(items: databaseItems)
        
        // When
        let feature = sut.getAllItems(from: table)
        let items = try feature.wait()

        // Then
        XCTAssertEqual(items.map { $0.id }, [givenItem.id])
    }
    
    func test_whenGetAllItems_throwsItemsNotFound() throws {
        // Given
        let sut = ItemGetDBWrapperFactory.make()
        var thrownError: Error?
        
        // When
        let feature = sut.getAllItems(from: table)
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
    
    // Get Summaries

    func test_whenGetSummaries_returnsSummaries() throws {
        // Given
        let givenItem = MockItemSummaryFactory.make()
        let databaseItems = MockItemSummaryFactory.makeData()
        let sut = ItemGetDBWrapperFactory.make(items: databaseItems)

        // When
        let feature: EventLoopFuture<[MockItemSummary]?> = sut.getSummaries(forID: givenItem.itemID, from: table, by: .summaryID)
        let items = try feature.wait()

        // Then
        let summaries = try XCTUnwrap(items)
        XCTAssertEqual(summaries.map { $0.itemID }, [givenItem.itemID])
    }
    
    func test_whenGetSummaries_returnsNil() throws {
        // Given
        let givenItem = MockItemSummaryFactory.make()
        let sut = ItemGetDBWrapperFactory.make()

        // When
        let feature: EventLoopFuture<[MockItemSummary]?> = sut.getSummaries(forID: givenItem.itemID, from: table, by: .summaryID)
        let items = try feature.wait()

        // Then
        XCTAssertNil(items)
    }

}
