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

    func testLocalizedDescription_requestError() throws {
        XCTAssertEqual(ComicInfoError.requestError.localizedDescription, "Request Error")
    }

    func testLocalizedDescription_itemAlreadyExists() throws {
        XCTAssertEqual(
            ComicInfoError.itemAlreadyExists(withID: "1", itemType: Character.self).localizedDescription,
            "Character already exists with id: 1"
        )
    }

    func testLocalizedDescription_itemNotFound() throws {
        XCTAssertEqual(
            ComicInfoError.itemNotFound(withID: "1", itemType: Character.self).localizedDescription,
            "We couldn't find Character with id: 1"
        )
    }

    func testLocalizedDescription_itemsNotFound() throws {
        XCTAssertEqual(
            ComicInfoError.itemsNotFound(withIDs: ["1"], itemType: Character.self).localizedDescription,
            "We couldn't find Character with ids: [\"1\"]"
        )
    }

    func testLocalizedDescription_itemsNotFoundEmptySet() throws {
        XCTAssertEqual(
            ComicInfoError.itemsNotFound(withIDs: [], itemType: Character.self).localizedDescription,
            "We couldn't find Character"
        )
    }

    func testLocalizedDescription_invalidItemID() throws {
        XCTAssertEqual(
            ComicInfoError.invalidItemID("1", itemType: "character").localizedDescription,
            "Invalid ItemID: Expected to decode character# but found a 1 instead."
        )
    }

    func testLocalizedDescription_invalidSummaryID() throws {
        XCTAssertEqual(
            ComicInfoError.invalidSummaryID("1", itemType: "character").localizedDescription,
            "Invalid SummaryID: Expected to decode character# but found a 1 instead."
        )
    }
    
    func testLocalizedDescription_invalidFields() throws {
        XCTAssertEqual(
            ComicInfoError.invalidFields(["UnknownField"]).localizedDescription,
            "Invalid fields: [\"UnknownField\"]"
        )
    }

    func testLocalizedDescription_handlerUnknown() throws {
        XCTAssertEqual(
            ComicInfoError.handlerUnknown.localizedDescription,
            "Handler Unknown"
        )
    }
    
    func testLocalizedDescription_internalServerError() throws {
        XCTAssertEqual(
            ComicInfoError.internalServerError.localizedDescription,
            "Internal Server Error"
        )
    }

}
