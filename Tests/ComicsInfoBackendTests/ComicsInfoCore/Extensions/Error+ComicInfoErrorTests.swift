//
//  Error+ComicInfoErrorTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 07/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class Error_ComicInfoErrorTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testItemAlreadyExists_whenMapToComicInfoError_isItemAlreadyExists() {
        // Given
        let databaseError: Error = DatabaseError.itemAlreadyExists(withID: "1")
        let givenError = ComicInfoError.itemAlreadyExists(withID: "1", itemType: Comic.self)

        // When
        let sut = databaseError.mapToComicInfoError(itemType: Comic.self)

        // Then
        XCTAssertEqual(sut.localizedDescription, givenError.localizedDescription)
    }

    func testItemNotFound_whenMapToComicInfoError_isItemNotFound() {
        // Given
        let databaseError: Error = DatabaseError.itemNotFound(withID: "1")
        let givenError = ComicInfoError.itemNotFound(withID: "1", itemType: Comic.self)

        // When
        let sut = databaseError.mapToComicInfoError(itemType: Comic.self)

        // Then
        XCTAssertEqual(sut.localizedDescription, givenError.localizedDescription)
    }

    func testItemsNotFound_whenMapToComicInfoError_isItemsNotFound() {
        // Given
        let databaseError: Error = DatabaseError.itemsNotFound(withIDs: ["1"])
        let givenError = ComicInfoError.itemsNotFound(withIDs: ["1"], itemType: Comic.self)

        // When
        let sut = databaseError.mapToComicInfoError(itemType: Comic.self)

        // Then
        XCTAssertEqual(sut.localizedDescription, givenError.localizedDescription)
    }

    func testItemsNotFoundWithIDsNil_whenMapToComicInfoError_isItemsNotFoundWithIDsNil() {
        // Given
        let databaseError: Error = DatabaseError.itemsNotFound(withIDs: nil)
        let givenError = ComicInfoError.itemsNotFound(withIDs: nil, itemType: Comic.self)

        // When
        let sut = databaseError.mapToComicInfoError(itemType: Comic.self)

        // Then
        XCTAssertEqual(sut.localizedDescription, givenError.localizedDescription)
    }
    
    func testError_whenMapToComicInfoError_isGivenError() {
        // Given
        let givenError: Error = NSError(domain: "", code: 0, userInfo: nil)

        // When
        let sut = givenError.mapToComicInfoError(itemType: Comic.self)

        // Then
        XCTAssertEqual(sut.localizedDescription, ComicInfoError.internalServerError.localizedDescription)
    }

}
