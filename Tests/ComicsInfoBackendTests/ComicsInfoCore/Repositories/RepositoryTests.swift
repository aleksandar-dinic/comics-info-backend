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
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        sut = RepositoryMock.makeCharacterRepository(tables: [:])
        table = String.tableName(for: "TEST")
    }

    override func tearDownWithError() throws {
        sut = nil
        table = nil
    }

    // MARK: - Get Item

    func test_whenGetItemFromDatabase_returnsItem() throws {
        // Given
        let givenItem = CharacterMock.makeCharacter()
        let tables = CharacterMock.makeDatabaseTables(table)
        sut = RepositoryMock.makeCharacterRepository(tables: tables)
        
        // When
        let featureGet = sut.getItem(withID: givenItem.id, fromDataSource: .database, from: table)
        let item = try featureGet.wait()

        // Then
        XCTAssertEqual(item.id, givenItem.id)
    }

    // MARK: - Get All Items

    func test_whenGetAllItemsFromDatabase_returnsItems() throws {
        // Given
        let givenItems = CharacterMock.charactersList
        let tables = CharacterMock.makeDatabaseTablesList(table)
        sut = RepositoryMock.makeCharacterRepository(tables: tables)

        // When
        let featureGet = sut.getAllItems(fromDataSource: .database, from: table)
        let items = try featureGet.wait()

        // Then
        XCTAssertEqual(items.map { $0.id }.sorted(by: <), givenItems.map { $0.id }.sorted(by: <))
    }

    // MARK: - Get Metadata

    func test_whenGetMetadataFromDatabase_returnsMetadata() throws {
        // Given
        let givenItem = CharacterMock.makeCharacter()
        let tables = CharacterMock.makeDatabaseTables(table)
        sut = RepositoryMock.makeCharacterRepository(tables: tables)

        // When
        let featureGet = sut.getMetadata(withID: givenItem.id, fromDataSource: .database, from: table)
        let item = try featureGet.wait()

        // Then
        XCTAssertEqual(item.id, givenItem.id)
    }

    // MARK: - Get All Metadata

    func test_whenGetAllMetadataFromDatabase_returnsAllMetadata() throws {
        // Given
        let givenItems = CharacterMock.charactersList
        let tables = CharacterMock.makeDatabaseTablesList(table)
        sut = RepositoryMock.makeCharacterRepository(tables: tables)

        // When
        let featureGet = sut.getAllMetadata(withIDs: Set(givenItems.map { $0.id }), fromDataSource: .database, from: table)
        let items = try featureGet.wait()

        // Then
        XCTAssertEqual(items.map { $0.id }.sorted(by: <), givenItems.map { $0.id }.sorted(by: <))
    }

}
