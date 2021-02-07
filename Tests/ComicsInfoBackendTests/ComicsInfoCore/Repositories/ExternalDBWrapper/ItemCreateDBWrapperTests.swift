//
//  ItemCreateDBWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class ItemCreateDBWrapperTests: XCTestCase {
    
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
        let sut = ItemCreateDBWrapperFactory.make()
        
        // When
        let feature = sut.create(item, in: table)
        
        // Then
        XCTAssertNoThrow(try feature.wait())
    }
    
    func test_whenCreateItem_throwsItemAlreadyExists() throws {
        // Given
        let item = MockComicInfoItemFactory.make()
        let itemData = MockComicInfoItemFactory.makeData()
        let sut = ItemCreateDBWrapperFactory.make(items: itemData)
        var thrownError: Error?
        
        // When
        let feature = sut.create(item, in: table)
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
        let sut = ItemCreateDBWrapperFactory.make()
        
        // When
        let feature = sut.createSummaries([summary], in: table)
        
        // Then
        XCTAssertNoThrow(try feature.wait())
    }
    
    func test_whenCreateSummary_throwsItemAlreadyExists() throws {
        // Given
        let summary = MockItemSummaryFactory.make()
        let itemData = MockItemSummaryFactory.makeData()
        let sut = ItemCreateDBWrapperFactory.make(items: itemData)
        var thrownError: Error?
        
        // When
        let feature = sut.createSummaries([summary], in: table)
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
