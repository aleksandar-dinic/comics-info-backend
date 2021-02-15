//
//  UseCaseTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 16/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import NIO
import XCTest

final class UseCaseTests: XCTestCase {

    private var eventLoop: EventLoop!
    private var sut: CharacterUseCase!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        MockDB.removeAll()
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        table = String.tableName(for: "TEST")
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        sut = nil
        table = nil
    }

    func test_whenGetItemFromDatabase_returnsItem() throws {
        // Given
        let givenItem = CharacterFactory.make()
        let items = CharacterFactory.makeDatabaseItems()
        sut = CharacterUseCaseFactoryMock(items: items, on: eventLoop).makeUseCase()

        // When
        let featureGet = sut.getItem(on: eventLoop, withID: givenItem.id, fields: nil, from: table, logger: nil, dataSource: .database)
        let item = try featureGet.wait()

        // Then
        XCTAssertEqual(item.id, givenItem.id)
    }

    func test_whenGetAllItemsFromDatabase_returnsItems() throws {
        // Given
        let givenCharacters = CharacterFactory.makeList
        let givenItems = CharacterFactory.makeDatabaseItemsList()
        sut = CharacterUseCaseFactoryMock(items: givenItems, on: eventLoop).makeUseCase()

        // When
        let featureGet = sut.getAllItems(on: eventLoop, fields: nil, from: table, logger: nil, dataSource: .database)
        let items = try featureGet.wait()

        // Then
        XCTAssertEqual(items.map { $0.id }.sorted(by: <), givenCharacters.map { $0.id }.sorted(by: <))
    }

}
