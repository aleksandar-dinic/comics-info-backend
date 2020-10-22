//
//  RepositoryTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 20/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class RepositoryTests: XCTestCase {

    private var sut: Repository<CharacterRepositoryAPIWrapper, InMemoryCacheProvider<Character>>!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        sut = RepositoryMock.makeCharacterRepository()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    // MARK: - Create

    func test_whenCreateItem_itemIsCreated() throws {
        // Given
        let givenItem = CharacterMock.makeCharacter()

        // When
        let feature = sut.create(givenItem)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }

    // MARK: - Get Item

    func test_whenGetItemFromDatabase_returnsItem() throws {
        // Given
        let givenItem = CharacterMock.makeCharacter()
        let feature = sut.create(givenItem)
        try feature.wait()

        // When
        let featureGet = sut.getItem(withID: givenItem.id, fromDataSource: .database)
        let item = try featureGet.wait()

        // Then
        XCTAssertEqual(item.id, givenItem.id)
    }

    // MARK: - Get All Items

    func test_whenGetAllItemsFromDatabase_returnsItems() throws {
        // Given
        let givenItems = CharacterMock.charactersList
        for givenItem in givenItems {
            let feature = sut.create(givenItem)
            try feature.wait()
        }

        // When
        let featureGet = sut.getAllItems(fromDataSource: .database)
        let items = try featureGet.wait()

        // Then
        XCTAssertEqual(items.map { $0.id }.sorted(by: <), givenItems.map { $0.id }.sorted(by: <))
    }

    // MARK: - Get Metadata

    func test_whenGetMetadataFromDatabase_returnsMetadata() throws {
        // Given
        let givenItem = CharacterMock.makeCharacter()
        let feature = sut.create(givenItem)
        try feature.wait()

        // When
        let featureGet = sut.getMetadata(withID: givenItem.id, fromDataSource: .database)
        let item = try featureGet.wait()

        // Then
        XCTAssertEqual(item.id, givenItem.id)
    }

    // MARK: - Get All Metadata

    func test_whenGetAllMetadataFromDatabase_returnsAllMetadata() throws {
        // Given
        let givenItems = CharacterMock.charactersList
        for givenItem in givenItems {
            let feature = sut.create(givenItem)
            try feature.wait()
        }

        // When
        let featureGet = sut.getAllMetadata(withIDs: Set(givenItems.map { $0.id }), fromDataSource: .database)
        let items = try featureGet.wait()

        // Then
        XCTAssertEqual(items.map { $0.id }.sorted(by: <), givenItems.map { $0.id }.sorted(by: <))
    }

    // MARK: - Update

    func test_whenUpdateItem_itemUpdated() throws {
        // Given
        let givenItem = CharacterMock.makeCharacter()
        let feature = sut.create(givenItem)
        try feature.wait()

        let updateItem = CharacterMock.makeCharacter(name: "New name")
        // When
        let featureUpdate = sut.update(updateItem)

        // Then
        XCTAssertNoThrow(try featureUpdate.wait())
    }

}
