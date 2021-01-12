//
//  CreateDataProviderTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 11/01/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class CreateDataProviderTests: XCTestCase {

    private var sut: CreateDataProvider<CharacterCreateRepositoryAPIWrapper>!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        sut = DataProviderMock.makeCharacterCreateDataProvider()
        table = String.tableName(for: "TEST")
    }

    override func tearDownWithError() throws {
        sut = nil
        table = nil
    }

    // MARK: - Create

    func test_whenCreateItem_itemIsCreated() throws {
        // Given
        let givenItem = CharacterMock.makeCharacter()

        // When
        let feature = sut.create(givenItem, in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }

}
