//
//  StringDatabaseFieldTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 22/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//


@testable import CharacterInfo
import XCTest

final class StringDatabaseFieldTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testStringExtensionIdentifier_isEqualIdentifier() {
        XCTAssertEqual(String.identifier, "identifier")
    }

    func testStringExtensionPopularity_isEqualPopularity() {
        XCTAssertEqual(String.popularity, "popularity")
    }

    func testStringExtensionName_isEqualName() {
        XCTAssertEqual(String.name, "name")
    }

    func testStringExtensionThumbnail_isEqualThumbnail() {
        XCTAssertEqual(String.thumbnail, "thumbnail")
    }

    func testStringExtensionDescription_isEqualDescription() {
        XCTAssertEqual(String.description, "description")
    }

}
