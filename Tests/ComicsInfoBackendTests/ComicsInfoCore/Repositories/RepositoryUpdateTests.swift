//
//  RepositoryUpdateTests.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 11/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class RepositoryUpdateTests: XCTestCase {

    private var sut: UpdateRepository<CharacterUpdateRepositoryAPIWrapper>!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        table = String.tableName(for: "TEST")
        let items = CharacterMock.makeDatabaseItems(table)
        sut = RepositoryMock.makeCharacterRepositoryUpdate(items: items)
    }

    override func tearDownWithError() throws {
        sut = nil
        table = nil
    }

    func test_whenUpdateItem_itemUpdated() throws {
        // Given
        let updateItem = CharacterMock.makeCharacter(name: "New name")
        
        // When
        let featureUpdate = sut.update(updateItem, in: table)

        // Then
        XCTAssertNoThrow(try featureUpdate.wait())
    }

}
