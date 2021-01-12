//
//  UpdateUseCaseTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 11/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Logging
import NIO
import XCTest

final class UpdateUseCaseTests: XCTestCase {

    private var eventLoop: EventLoop!
    private var logger: Logger!
    private var sut: CharacterUpdateUseCase<CharacterUpdateRepositoryAPIWrapper>!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        logger = Logger(label: self.className)
        table = String.tableName(for: "TEST")
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        logger = nil
        sut = nil
        table = nil
    }

    func test_whenUpdateItem_itemUpdated() throws {
        // Given
        let tables = CharacterMock.makeDatabaseTables(table)
        sut = CharacterUpdateUseCaseFactoryMock(tables: tables, on: eventLoop, logger: logger).makeUseCase()

        let updateItem = CharacterMock.makeCharacter(name: "New name")
        // When
        let featureUpdate = sut.update(updateItem, in: table)

        // Then
        XCTAssertNoThrow(try featureUpdate.wait())
    }

}
