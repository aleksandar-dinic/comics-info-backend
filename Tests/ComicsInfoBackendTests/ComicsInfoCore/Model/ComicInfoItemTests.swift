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

    func test() {
        // Given
        let newItem = ComicInfoItemMock(
            id: "1",
            itemID: "Item#1",
            summaryID: "Item#1",
            itemName: "Item",
            popularity: 1,
            name: "New Item Name"
        )
        let oldItem = ComicInfoItemMock(
            id: "1",
            itemID: "Item#1",
            summaryID: "Item#1",
            itemName: "Item",
            popularity: 0,
            name: "Old Item Name"
        )
        
        // When
        let fields = newItem.updatedFields(old: oldItem)
        
        // Then
        XCTAssertEqual(fields.count, 2)
        XCTAssertTrue(fields.contains("popularity"))
        XCTAssertTrue(fields.contains("name"))
    }
    
}
