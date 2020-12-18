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
        let character = CharacterMock.character
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

    // MARK: - Get All Items

    func testGetAllItems_isEqualToGivenData() throws {
        // Given
        sut = InMemoryCacheProvider(itemsCaches: [table: inMemoryCache])

        // When
        let items = try sut.getAllItems(from: table, on: eventLoop).wait()

        // Then
        XCTAssertEqual(items.count, givenData.count)
    }

    func testGetAllItems_whenCacheIsEmpty_throwsItemsNotFound() throws {
        // Given
        sut = InMemoryCacheProvider()
        var thrownError: Error?

        // When
        let itemsFuture = sut.getAllItems(from: table, on: eventLoop)
        XCTAssertThrowsError(try itemsFuture.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemsNotFound = error as? CacheError<Character> {
        } else {
            XCTFail("Expected '.itemsNotFound' but got \(error)")
        }
    }

    // MARK: - Get Item

    func testGetItemWithID_isEqualToGivenItem() throws {
        // Give
        sut = InMemoryCacheProvider(itemsCaches: [table: inMemoryCache])

        // When
        let item = try sut.getItem(withID: "1", from: table, on: eventLoop).wait()

        // Then
        XCTAssertEqual(item.id, "1")
    }

    func testGetItemWithID_whenIDNotExist_throwsItemNotFound() throws {
        // Given
        sut = InMemoryCacheProvider()
        var thrownError: Error?

        // When
        let itemFuture = sut.getItem(withID: "-1", from: table, on: eventLoop)
        XCTAssertThrowsError(try itemFuture.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemNotFound(let itemID, _) = error as? CacheError<Character> {
            XCTAssertEqual(itemID, "-1")
        } else {
            XCTFail("Expected '.itemNotFound' but got \(error)")
        }
    }

    // MARK: - Get Metadata

    func testGetMetadataWithID_isEqualToGivenMetadata() throws {
        // Give
        sut = InMemoryCacheProvider(metadataCaches: [table: inMemoryCache])

        // When
        let item = try sut.getMetadata(withID: "1", from: table, on: eventLoop).wait()

        // Then
        XCTAssertEqual(item.id, "1")
    }

    func testGetmetadataWithID_whenIDNotExist_throwsItemNotFound() throws {
        // Given
        sut = InMemoryCacheProvider()
        var thrownError: Error?

        // When
        let itemFuture = sut.getMetadata(withID: "-1", from: table, on: eventLoop)
        XCTAssertThrowsError(try itemFuture.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemNotFound(let itemID, _) = error as? CacheError<Character> {
            XCTAssertEqual(itemID, "-1")
        } else {
            XCTFail("Expected '.itemNotFound' but got \(error)")
        }
    }

    // MARK: - Get All Metadata

    func testGetAllMetadata_isEqualToGivenMetadata() throws {
        // Given
        sut = InMemoryCacheProvider(metadataCaches: [table: inMemoryCache])

        // When
        let items = try sut.getAllMetadata(withIDs: ["1"], from: table, on: eventLoop).wait()

        // Then
        XCTAssertEqual(items.count, givenData.count)
    }

    func testGetAllMetadata_whenCacheIsEmpty_throwsItemsNotFound() throws {
        // Given
        sut = InMemoryCacheProvider()
        var thrownError: Error?

        // When
        let itemsFuture = sut.getAllMetadata(withIDs: ["-1"], from: table, on: eventLoop)
        XCTAssertThrowsError(try itemsFuture.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemsNotFound = error as? CacheError<Character> {
        } else {
            XCTFail("Expected '.itemsNotFound' but got \(error)")
        }
    }

    func testGetAllMetadata_whenCacheIsEmptyWithEmptyIDs_throwsItemsNotFound() throws {
        // Given
        sut = InMemoryCacheProvider(itemsCaches: [table: inMemoryCache])
        var thrownError: Error?

        // When
        let itemsFuture = sut.getAllMetadata(withIDs: [], from: table, on: eventLoop)
        XCTAssertThrowsError(try itemsFuture.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemsNotFound = error as? CacheError<Character> {
        } else {
            XCTFail("Expected '.itemsNotFound' but got \(error)")
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
