//
//  CharacterFromItemsFieldsTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 01/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class CharacterFromItemsFieldsTests: XCTestCase {

    private var items: [String: Any]!
    private var identifier: String!
    private var popularity: Int!
    private var itemName: String!
    private var thumbnail: String!
    private var itemDescription: String!
    private var sut: Character!

    override func setUpWithError() throws {
        identifier = "1"
        popularity = 0
        itemName = "name"
        thumbnail = "thumbnail"
        itemDescription = "description"
        items = [
            "identifier": identifier as Any,
            "popularity": popularity as Any,
            "name": itemName as Any,
            "thumbnail": thumbnail as Any,
            "description": itemDescription as Any
        ]
        sut = try Character(from: items)
    }

    override func tearDownWithError() throws {
        identifier = nil
        popularity = nil
        itemName = nil
        thumbnail = nil
        itemDescription = nil
        items = nil
        sut = nil
    }

    func testCharacterIdentifier_whenInitFromItems_isEqualToItemIdentifier() {
        XCTAssertEqual(sut.identifier, identifier)
    }

    func testCharacterPopularity_whenInitFromItems_isEqualToItemPopularity() {
        XCTAssertEqual(sut.popularity, popularity)
    }

    func testCharacterName_whenInitFromItems_isEqualToItemName() {
        XCTAssertEqual(sut.name, itemName)
    }

    func testCharacterThumbnail_whenInitFromItems_isEqualToItemThumbnail() {
        XCTAssertEqual(sut.thumbnail, thumbnail)
    }

    func testCharacterDescription_whenInitFromItems_isEqualToItemDescription() {
        XCTAssertEqual(sut.description, itemDescription)
    }

}
