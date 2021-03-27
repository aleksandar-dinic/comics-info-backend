//
//  ItemCreateDBWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest
import NIO

final class ItemCreateDBWrapperTests: XCTestCase {
    
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

    // Create
    
    func test_whenCreate_itemIsCreated() throws {
        // Given
        let item = MockComicInfoItemFactory.make()
        let sut = ItemCreateDBWrapperFactory.make()
        let criteria = CreateItemCriteria(item: item, on: eventLoop, in: table)
        
        // When
        let feature = sut.create(with: criteria)
        let createdItem = try feature.wait()
        
        // Then
        XCTAssertEqual(createdItem.id, item.id)
    }
    
    func test_whenCreateItem_throwsItemAlreadyExists() throws {
        // Given
        let item = MockComicInfoItemFactory.make()
        let itemData = MockComicInfoItemFactory.makeData()
        let sut = ItemCreateDBWrapperFactory.make(items: itemData)
        let criteria = CreateItemCriteria(item: item, on: eventLoop, in: table)
        var thrownError: Error?
        
        // When
        let feature = sut.create(with: criteria)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }
        
        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemAlreadyExists(let ID, let itemType) = error as? ComicInfoError {
            XCTAssertEqual(ID, item.id)
            XCTAssertTrue(itemType == MockComicInfoItem.self)
        } else {
            XCTFail("Expected '.itemAlreadyExists' but got \(error)")
        }
    }
    
    // Create Summaries
    
    func test_whenCreateSummaries_summaryIsCreated() throws {
        // Given
        let summary = MockItemSummaryFactory.make()
        let criteria = CreateSummariesCriteria(summaries: [summary], on: eventLoop, in: table)
        let sut = ItemCreateDBWrapperFactory.make()
        
        // When
        let feature = sut.createSummaries(with: criteria)
        let createdSummaries = try feature.wait()
        
        // Then
        XCTAssertEqual(createdSummaries.first?.itemID, summary.itemID)
    }
    
    func test_whenCreateSummary_throwsItemAlreadyExists() throws {
        // Given
        let summary = MockItemSummaryFactory.make()
        let itemData = MockItemSummaryFactory.makeData()
        let sut = ItemCreateDBWrapperFactory.make(items: itemData)
        let criteria = CreateSummariesCriteria(summaries: [summary], on: eventLoop, in: table)
        var thrownError: Error?
        
        // When
        let feature = sut.createSummaries(with: criteria)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }
        
        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemAlreadyExists(let ID, let itemType) = error as? ComicInfoError {
            XCTAssertEqual(ID, "1|1")
            XCTAssertTrue(itemType == MockItemSummary.self)
        } else {
            XCTFail("Expected '.itemAlreadyExists' but got \(error)")
        }
    }
 
}
