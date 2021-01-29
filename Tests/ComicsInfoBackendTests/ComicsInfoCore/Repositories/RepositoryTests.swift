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
        sut = RepositoryMock.makeCharacterRepository(items: [:])
        table = String.tableName(for: "TEST")
    }

    override func tearDownWithError() throws {
        sut = nil
        table = nil
    }

    func test_whenGetItemFromDatabase_returnsItem() throws {
        // Given
        let givenItem = CharacterMock.makeCharacter()
        let items = CharacterMock.makeDatabaseItems()
        sut = RepositoryMock.makeCharacterRepository(items: items)
        
        // When
        let featureGet = sut.getItem(withID: givenItem.id, dataSource: .database, from: table)
        let item = try featureGet.wait()

        // Then
        XCTAssertEqual(item.id, givenItem.id)
    }

    // MARK: - Get All Items

    func test_whenGetAllItemsFromDatabase_returnsItems() throws {
        // Given
        let givenCharacters = CharacterMock.charactersList
        let givenItems = CharacterMock.makeDatabaseItemsList()
        sut = RepositoryMock.makeCharacterRepository(items: givenItems)

        // When
        let featureGet = sut.getAllItems(dataSource: .database, from: table)
        let items = try featureGet.wait()

        // Then
        XCTAssertEqual(items.map { $0.id }.sorted(by: <), givenCharacters.map { $0.id }.sorted(by: <))
    }

}
