//
//  CharacterGetAPIWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class CharacterGetAPIWrapperTests: XCTestCase, CreateCharacterProtocol, CreateSeriesProtocol, CreateComicProtocol {

    private var sut: CharacterGetAPIWrapper!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        sut = CharacterGetAPIWrapperMock.make(items: [:])
        table = String.tableName(for: "TEST")
    }

    override func tearDownWithError() throws {
        sut = nil
        table = nil
    }

    func test_whenGetItem_returnsItem() throws {
        let givenItem = CharacterMock.makeCharacter()
        try createCharacter(givenItem)

        // When
        let feature = sut.get(withID: givenItem.id, from: table)
        let item = try feature.wait()

        // Then
        XCTAssertEqual(item.id, givenItem.id)
    }

    func test_whenGetItemWithNotExistingID_throwsItemNotFound() throws {
        let givenItemID = "-1"
        var thrownError: Error?

        // When
        let feature = sut.get(withID: givenItemID, from: table)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemNotFound(let itemID, let itemType) = error as? APIError {
            XCTAssertEqual(itemID, givenItemID)
            XCTAssertTrue(itemType == Character.self)
        } else {
            XCTFail("Expected '.itemNotFound' but got \(error)")
        }
    }
    
    // Get All
    
    func test_whenGetAllItems_returnsAllItems() throws {
        // Given
        let series = SeriesMock.makeSeries(id: "1")
        try createSeries(series)
        let comic = ComicMock.makeComic(id: "1")
        try createComic(comic)
        try createCharacter(CharacterMock.makeCharacter(id: "1", seriesID: [series.id]))
        try createCharacter(CharacterMock.makeCharacter(id: "2", comicsID: [comic.id]))

        // When
        let feature = sut.getAll(from: table)
        let characters = try feature.wait()

        // Then
        XCTAssertEqual(characters.map { $0.id }.sorted(by: <), ["1", "2"])
    }

    func test_whenGetAllItems_throwsItemsNotFound() throws {
        // Given
        var thrownError: Error?

        // When
        let feature = sut.getAll(from: table)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemsNotFound(let itemIDs, let itemType) = error as? APIError {
            XCTAssertNil(itemIDs)
            XCTAssertTrue(itemType == Character.self)
        } else {
            XCTFail("Expected '.itemsNotFound' but got \(error)")
        }
    }

}
