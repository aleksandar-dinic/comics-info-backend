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

    func test_whenMapToAPIError_isRequestError() {
        // Given
        let databaseError: Error = DatabaseError.itemDoesNotHaveItemID
        let givenError = APIError.requestError

        // When
        let sut = databaseError.mapToAPIError(itemType: Comic.self)

        // Then
        XCTAssertEqual(sut.localizedDescription, givenError.localizedDescription)
    }

    func test_whenMapToAPIError_isItemAlreadyExists() {
        // Given
        let databaseError: Error = DatabaseError.itemAlreadyExists(withID: "1")
        let givenError = APIError.itemAlreadyExists(withID: "1", itemType: Comic.self)

        // When
        let sut = databaseError.mapToAPIError(itemType: Comic.self)

        // Then
        XCTAssertEqual(sut.localizedDescription, givenError.localizedDescription)
    }

    func test_whenMapToAPIError_isItemNotFound() {
        // Given
        let databaseError: Error = DatabaseError.itemNotFound(withID: "1")
        let givenError = APIError.itemNotFound(withID: "1", itemType: Comic.self)

        // When
        let sut = databaseError.mapToAPIError(itemType: Comic.self)

        // Then
        XCTAssertEqual(sut.localizedDescription, givenError.localizedDescription)
    }

    func test_whenMapToAPIError_isItemsNotFound() {
        // Given
        let databaseError: Error = DatabaseError.itemsNotFound(withIDs: ["1"])
        let givenError = APIError.itemsNotFound(withIDs: ["1"], itemType: Comic.self)

        // When
        let sut = databaseError.mapToAPIError(itemType: Comic.self)

        // Then
        XCTAssertEqual(sut.localizedDescription, givenError.localizedDescription)
    }

    func test_whenMapToAPIError_isGivenError() {
        // Given
        let givenError: Error = NSError(domain: "", code: 0, userInfo: nil)

        // When
        let sut = givenError.mapToAPIError(itemType: Comic.self)

        // Then
        XCTAssertEqual(sut.localizedDescription, givenError.localizedDescription)
    }

}
