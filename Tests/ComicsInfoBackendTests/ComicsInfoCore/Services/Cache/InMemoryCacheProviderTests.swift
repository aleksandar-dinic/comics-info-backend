//
//  InMemoryCacheProviderTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 16/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest
import NIO

final class InMemoryCacheProviderTests: XCTestCase {

    private var eventLoop: EventLoop!
    private var givenData: [String: Character]!
    private var inMemoryCache: InMemoryCache<String, Character>!
    private var sut: InMemoryCacheProvider<Character>!
    private var table: String!

    override func setUpWithError() throws {
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        let character = CharacterFactory.make()
        givenData = [character.id: character]
        inMemoryCache = InMemoryCache(storage: givenData)
        table = String.tableName(for: "TEST")
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        inMemoryCache = nil
        givenData = nil
        table = nil
    }


    // MARK: - Get Item

    func testGetItemWithID_isEqualToGivenItem() throws {
        // Give
        sut = InMemoryCacheProvider(itemsCaches: [table: inMemoryCache])

        // When
        let result = sut.getItem(withID: "1", from: table)

        // Then
        switch result {
        case let .success(item):
            XCTAssertEqual(item.id, "1")
        case let .failure(error):
            XCTFail("\(error)")
        }
    }

    func testGetItemWithID_whenIDNotExist_throwsItemNotFound() throws {
        // Given
        sut = InMemoryCacheProvider()

        // When
        let result = sut.getItem(withID: "-1", from: table)

        // Then
        switch result {
        case let .success(items):
            XCTFail("Expected '.failure(.itemNotFound(withID: -1))' but got .success(\(items))")
        case let .failure(error):
            XCTAssertEqual(error, .itemNotFound(withID: "-1", itemType: Character.self))
        }
    }

    // MARK: - Get All Items

    func testGetAllItems_isEqualToGivenData() throws {
        // Given
        sut = InMemoryCacheProvider(itemsCaches: [table: inMemoryCache])

        // When
        let result = sut.getAllItems(forSummaryID: nil, from: table)

        // Then
        switch result {
        case let .success(items):
            XCTAssertEqual(items.count, givenData.count)
        case let .failure(error):
            XCTFail("\(error)")
        }
    }

    func testGetAllItems_whenCacheIsEmpty_throwsItemsNotFound() throws {
        // Given
        sut = InMemoryCacheProvider()

        // When
        let result = sut.getAllItems(forSummaryID: nil, from: table)

        // Then
        switch result {
        case let .success(items):
            XCTFail("Expected '.failure(.itemsNotFound)' but got .success(\(items))")
        case let .failure(error):
            XCTAssertEqual(error, .itemsNotFound(itemType: Character.self))
        }
    }

    // MARK: - Save

    func testSaveItems() {
        // Given
        sut = InMemoryCacheProvider(itemsCaches: [table: inMemoryCache])

        // When
        sut.save(items: Array(givenData.values), in: table)

        // Then
        XCTAssertEqual(inMemoryCache.values.count, givenData.count)
    }

}
