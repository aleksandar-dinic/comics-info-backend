//
//  CreateUseCaseTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 11/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Logging
import NIO
import XCTest

final class CreateUseCaseTests: XCTestCase {

    private var eventLoop: EventLoop!
    private var logger: Logger!
    private var sut: CharacterCreateUseCase<CharacterCreateRepositoryAPIWrapper>!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        logger = Logger(label: self.className)
        sut = CharacterCreateUseCaseFactoryMock(on: eventLoop, logger: logger).makeUseCase()
        table = String.tableName(for: "TEST")
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        logger = nil
        sut = nil
        table = nil
    }

    func test_whenCrateCharacter_characterIsCreated() throws {
        // Given

        // When
        let feature = sut.create(CharacterMock.makeCharacter(), in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }

}
