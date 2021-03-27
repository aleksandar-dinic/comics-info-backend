//
//  CreateDataProviderTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 06/02/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest
import NIO

final class CreateDataProviderTests: XCTestCase {
    
    private var sut: CreateDataProvider!
    private var eventLoop: EventLoop!
    private var table: String!

    override func setUpWithError() throws {
        TestDatabase.removeAll()
        sut = CreateDataProviderFactory.make()
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        table = "TEST"
    }

    override func tearDownWithError() throws {
        sut = nil
        eventLoop = nil
        table = nil
    }

    // Create
    
    func test_whenCreate_itemIsCreated() throws {
        // Given
        let item = MockComicInfoItemFactory.make()
        let criteria = CreateItemCriteria(item: item, on: eventLoop, in: table)
        
        // When
        let feature = sut.create(with: criteria)
        let createdItem = try feature.wait()
        
        // Then
        XCTAssertEqual(createdItem.id, item.id)
    }
    
    // Create Summaries
    
    func test_whenCreateSummaries_summaryIsCreated() throws {
        // Given
        let summary = MockItemSummaryFactory.make()
        let criteria = CreateSummariesCriteria(summaries: [summary], on: eventLoop, in: table)
        
        // When
        let feature = sut.createSummaries(with: criteria)
        
        // Then
        XCTAssertNoThrow(try feature.wait())
    }
    
}
