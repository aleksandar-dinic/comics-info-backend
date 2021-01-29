//
//  Error+APIErrorTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 07/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class Error_APIErrorTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testItemAlreadyExists_whenMapToAPIError_isItemAlreadyExists() {
        // Given
        let databaseError: Error = DatabaseError.itemAlreadyExists(withID: "1")
        let givenError = APIError.itemAlreadyExists(withID: "1", itemType: Comic.self)

        // When
        let sut = databaseError.mapToAPIError(itemType: Comic.self)

        // Then
        XCTAssertEqual(sut.localizedDescription, givenError.localizedDescription)
    }

    func testItemNotFound_whenMapToAPIError_isItemNotFound() {
        // Given
        let databaseError: Error = DatabaseError.itemNotFound(withID: "1")
        let givenError = APIError.itemNotFound(withID: "1", itemType: Comic.self)

        // When
        let sut = databaseError.mapToAPIError(itemType: Comic.self)

        // Then
        XCTAssertEqual(sut.localizedDescription, givenError.localizedDescription)
    }

    func testItemsNotFound_whenMapToAPIError_isItemsNotFound() {
        // Given
        let databaseError: Error = DatabaseError.itemsNotFound(withIDs: ["1"])
        let givenError = APIError.itemsNotFound(withIDs: ["1"], itemType: Comic.self)

        // When
        let sut = databaseError.mapToAPIError(itemType: Comic.self)

        // Then
        XCTAssertEqual(sut.localizedDescription, givenError.localizedDescription)
    }

    func testItemsNotFoundWithIDsNil_whenMapToAPIError_isItemsNotFoundWithIDsNil() {
        // Given
        let databaseError: Error = DatabaseError.itemsNotFound(withIDs: nil)
        let givenError = APIError.itemsNotFound(withIDs: nil, itemType: Comic.self)

        // When
        let sut = databaseError.mapToAPIError(itemType: Comic.self)

        // Then
        XCTAssertEqual(sut.localizedDescription, givenError.localizedDescription)
    }
    
    func testError_whenMapToAPIError_isGivenError() {
        // Given
        let givenError: Error = NSError(domain: "", code: 0, userInfo: nil)

        // When
        let sut = givenError.mapToAPIError(itemType: Comic.self)

        // Then
        XCTAssertEqual(sut.localizedDescription, givenError.localizedDescription)
    }

}
