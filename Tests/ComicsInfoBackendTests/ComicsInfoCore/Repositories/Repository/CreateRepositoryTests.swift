//
//  CreateRepositoryTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 06/02/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest
import NIO

final class CreateRepositoryTests: XCTestCase {
    
    private var sut: CreateRepository!
    private var eventLoop: EventLoop!
    private var table: String!

    override func setUpWithError() throws {
        TestDatabase.removeAll()
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        table = "TEST"
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        table = nil
    }

    // Create
    
    func test_whenCreate_itemIsCreated() throws {
        // Given
        let item = MockComicInfoItemFactory.make()
        let criteria = CreateItemCriteria(item: item, on: eventLoop, in: table)
        sut = CreateRepositoryFactory.make()
        
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
        sut = CreateRepositoryFactory.make()
        
        // When
        let feature = sut.createSummaries(with: criteria)
        let createdSummaries = try feature.wait()
        
        // Then
        XCTAssertEqual(createdSummaries.first?.itemID, summary.itemID)
    }
    
}
