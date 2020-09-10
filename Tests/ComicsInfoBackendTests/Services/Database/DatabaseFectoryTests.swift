//
//  DatabaseFectoryTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 10/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest
import NIO

final class DatabaseFectoryTests: XCTestCase {

    private var eventLoop: EventLoop!

    override func setUpWithError() throws {
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
    }

    override func tearDownWithError() throws {
        eventLoop = nil
    }

    func testDatabaseFectoryMocked_whenMakeDatabase_databaseIsDatabaseMock() {
        // Given
        let sut = DatabaseFectory(mocked: true)

        // When
        let database = sut.makeDatabase(eventLoop: eventLoop)

        // Then
        XCTAssert(database is DatabaseMock)
    }

}
