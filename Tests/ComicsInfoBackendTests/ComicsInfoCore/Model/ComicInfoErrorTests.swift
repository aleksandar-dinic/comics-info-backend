//
//  ComicInfoErrorTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 08/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class ComicInfoErrorTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testLocalizedDescription_requestError() {
        // Given
        let comicInfoError = ComicInfoError.requestError
        let localizedDescription = "Request Error"
        
        // When
        let sut = comicInfoError.localizedDescription
        
        // Then
        XCTAssertEqual(sut, localizedDescription)
    }

    func testLocalizedDescription_itemAlreadyExists() {
        // Given
        let comicInfoError = ComicInfoError.itemAlreadyExists(withID: "1", itemType: Character.self)
        let localizedDescription = "Character already exists with id: 1"
        
        // When
        let sut = comicInfoError.localizedDescription
        
        // Then
        XCTAssertEqual(sut, localizedDescription)
    }

    func testLocalizedDescription_itemNotFound() {
        // Given
        let comicInfoError = ComicInfoError.itemNotFound(withID: "1", itemType: Character.self)
        let localizedDescription = "We couldn't find Character with id: 1"
        
        // When
        let sut = comicInfoError.localizedDescription
        
        // Then
        XCTAssertEqual(sut, localizedDescription)
    }

    func testLocalizedDescription_itemsNotFound() {
        // Given
        let comicInfoError = ComicInfoError.itemsNotFound(withIDs: ["1", "2"], itemType: Character.self)
        let localizedDescription = "We couldn't find Character with ids: [\"1\", \"2\"]"
        
        // When
        let sut = comicInfoError.localizedDescription
        
        // Then
        XCTAssertEqual(sut, localizedDescription)
    }

    func testLocalizedDescription_itemsNotFoundEmptySet() {
        // Given
        let comicInfoError = ComicInfoError.itemsNotFound(withIDs: [], itemType: Character.self)
        let localizedDescription = "We couldn't find Character"
        
        // When
        let sut = comicInfoError.localizedDescription
        
        // Then
        XCTAssertEqual(sut, localizedDescription)
    }

    func testLocalizedDescription_invalidItemID() {
        // Given
        let comicInfoError = ComicInfoError.invalidItemID("1", itemType: "character")
        let localizedDescription = "Invalid ItemID: Expected to decode character# but found a 1 instead."
        
        // When
        let sut = comicInfoError.localizedDescription
        
        // Then
        XCTAssertEqual(sut, localizedDescription)
    }
    
    func testLocalizedDescription_summariesAlreadyExist() {
        // Given
        let comicInfoError = ComicInfoError.summariesAlreadyExist(["1", "2"])
        let localizedDescription = "Summaries already exist withIDs: [\"1\", \"2\"]"
        
        // When
        let sut = comicInfoError.localizedDescription
        
        // Then
        XCTAssertEqual(sut, localizedDescription)
    }

    func testLocalizedDescription_invalidSummaryID() {
        // Given
        let comicInfoError = ComicInfoError.invalidSummaryID("1", itemType: "character")
        let localizedDescription = "Invalid SummaryID: Expected to decode character# but found a 1 instead."
        
        // When
        let sut = comicInfoError.localizedDescription
        
        // Then
        XCTAssertEqual(sut, localizedDescription)
    }
    
    func testLocalizedDescription_invalidFields() {
        // Given
        let comicInfoError = ComicInfoError.invalidFields(["UnknownField"])
        let localizedDescription = "Invalid fields: [\"UnknownField\"]"
        
        // When
        let sut = comicInfoError.localizedDescription
        
        // Then
        XCTAssertEqual(sut, localizedDescription)
    }

    func testLocalizedDescription_handlerUnknown() {
        // Given
        let comicInfoError = ComicInfoError.handlerUnknown
        let localizedDescription = "Handler Unknown"
        
        // When
        let sut = comicInfoError.localizedDescription
        
        // Then
        XCTAssertEqual(sut, localizedDescription)
    }
    
    func testLocalizedDescription_internalServerError() {
        // Given
        let comicInfoError = ComicInfoError.internalServerError
        let localizedDescription = "Internal Server Error"
        
        // When
        let sut = comicInfoError.localizedDescription
        
        // Then
        XCTAssertEqual(sut, localizedDescription)
    }

}
