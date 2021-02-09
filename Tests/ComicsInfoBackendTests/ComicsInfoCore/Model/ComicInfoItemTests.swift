//
//  ComicInfoItemTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 29/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class ComicInfoItemTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func test_whenUpdatePopularity_fieldsContainsPopularity() {
        // Given
        let oldItem = MockComicInfoItemFactory.make(popularity: 0)
        let newItem = MockComicInfoItemFactory.make(popularity: 1)
        
        // When
        let fields = newItem.updatedFields(old: oldItem)
        
        // Then
        XCTAssertEqual(fields.count, 1)
        XCTAssertTrue(fields.contains("popularity"))
    }
    
    func test_whenUpdateName_fieldsContainsName() {
        // Given
        let oldItem = MockComicInfoItemFactory.make(name: "Old Item Name")
        let newItem = MockComicInfoItemFactory.make(name: "New Item Name")
        
        // When
        let fields = newItem.updatedFields(old: oldItem)
        
        // Then
        XCTAssertEqual(fields.count, 1)
        XCTAssertTrue(fields.contains("name"))
    }
    
    func test_whenNewItemIsTheSameAsOldItem_fieldsIsEmpty() {
        // Given
        let oldItem = MockComicInfoItemFactory.make()
        let newItem = MockComicInfoItemFactory.make()
        
        // When
        let fields = newItem.updatedFields(old: oldItem)
        
        // Then
        XCTAssertTrue(fields.isEmpty)
    }
    
    func test_whenNewItemMissField_fieldsIsEmpty() {
        // Given
        let oldItem = MockComicInfoItemFactory.make(dummyField: "Field Value")
        let newItem = MockComicInfoItemFactory.make()
        
        // When
        let fields = newItem.updatedFields(old: oldItem)
        
        // Then
        XCTAssertTrue(fields.isEmpty)
    }
    
    func test_whenNewItemHasNewField_fieldsContainsNewField() {
        // Given
        let oldItem = MockComicInfoItemFactory.make()
        let newItem = MockComicInfoItemFactory.make(dummyField: "Field Value")
        
        // When
        let fields = newItem.updatedFields(old: oldItem)
        
        // Then
        XCTAssertEqual(fields.count, 1)
        XCTAssertTrue(fields.contains("dummyField"))
    }
    
}
