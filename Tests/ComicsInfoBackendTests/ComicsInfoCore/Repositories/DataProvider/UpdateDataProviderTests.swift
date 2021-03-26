//
//  UpdateDataProviderTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 06/02/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest
import NIO

final class UpdateDataProviderTests: XCTestCase {
    
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
    
    // Update
    
    func test_whenUpdateItem_itemUpdated() throws {
        // Given
        let item = MockComicInfoItemFactory.make()
        let itemData = MockComicInfoItemFactory.makeData()
        let criteria = UpdateItemCriteria(item: item, oldSortValue: "", on: eventLoop, in: table)
        let sut = UpdateDataProviderFactory.make(items: itemData)
        
        // When
        let feature = sut.update(with: criteria)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }
    
    // Update Summaries
    
    func test_whenUpdateSummaries_summariesUpdated() throws {
        // Given
        let item = MockItemSummaryFactory.make()
        let criteria = UpdateSummariesCriteria(items: [item], table: table)
        let sut = UpdateDataProviderFactory.make()
        
        // When
        let feature = sut.updateSummaries(with: criteria)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }
    
}
