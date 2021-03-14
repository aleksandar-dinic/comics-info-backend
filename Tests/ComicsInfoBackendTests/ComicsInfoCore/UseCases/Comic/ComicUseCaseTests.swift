//
//  ComicUseCaseTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import NIO
import XCTest

final class ComicUseCaseTests: XCTestCase {

    private var eventLoop: EventLoop!
    private var sut: ComicUseCase!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        MockDB.removeAll()
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        table = String.tableName(for: "TEST")
        let items = ComicFactory.makeDatabaseItems()
        sut = ComicUseCaseFactoryMock(items: items).makeUseCase()
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        sut = nil
        table = nil
    }
    
    func test_whenAvailableFields_isEqualToGivenFields() {
        // Given
        let fields = Set(["characters", "series"])

        // When

        // Then
        XCTAssertEqual(sut.availableFields.sorted(), fields.sorted())
    }
    
    func testGetItem_whenFieldIsInvalid_throwInvalidFields() throws {
        // Given
        let fields = Set(["Invalid"])
        let givenItem = ComicFactory.make()
        var thrownError: Error?

        // When
        let featureGet = sut.getItem(on: eventLoop, withID: givenItem.id, fields: fields, from: table, logger: nil, dataSource: .database)
        XCTAssertThrowsError(try featureGet.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case let .invalidFields(invalidFields) = error as? ComicInfoError {
            XCTAssertEqual(invalidFields, ["Invalid"])
        } else {
            XCTFail("Expected '.invalidFields' but got \(error)")
        }
    }
    
    func testGetItem_whenOneOfFieldsIsInvalid_throwInvalidFields() throws {
        // Given
        let fields = Set(["characters", "series", "Invalid"])
        let givenItem = ComicFactory.make()
        var thrownError: Error?

        // When
        let featureGet = sut.getItem(on: eventLoop, withID: givenItem.id, fields: fields, from: table, logger: nil, dataSource: .database)
        XCTAssertThrowsError(try featureGet.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case let .invalidFields(invalidFields) = error as? ComicInfoError {
            XCTAssertEqual(invalidFields, ["Invalid"])
        } else {
            XCTFail("Expected '.itemsNotFound' but got \(error)")
        }
    }

    func test_whenGetItemFromDatabase_returnsItem() throws {
        // Given
        let givenItem = ComicFactory.make()

        // When
        let featureGet = sut.getItem(on: eventLoop, withID: givenItem.id, fields: nil, from: table, logger: nil, dataSource: .database)
        let item = try featureGet.wait()

        // Then
        XCTAssertEqual(item.id, givenItem.id)
    }
    
    func test_whenGetItemWithoutFields_returnsItemWithoutSummaries() throws {
        // Given
        let givenItem = ComicFactory.make()

        // When
        let featureGet = sut.getItem(on: eventLoop, withID: givenItem.id, fields: nil, from: table, logger: nil, dataSource: .database)
        let item = try featureGet.wait()

        // Then
        XCTAssertNil(item.characters)
        XCTAssertNil(item.series)
    }
    
    func testGetItemWithFieldCharacter_whenCharacterSummaryDoesntExist_returnsItemWithoutSummaries() throws {
        // Given
        let fields = Set(["characters"])
        let givenItem = ComicFactory.make()

        // When
        let featureGet = sut.getItem(on: eventLoop, withID: givenItem.id, fields: fields, from: table, logger: nil, dataSource: .database)
        let item = try featureGet.wait()

        // Then
        XCTAssertNil(item.characters)
        XCTAssertEqual(item.id, givenItem.id)
    }
    
    func testGetItemWithFieldSeries_whenSeriesSummaryDoesntExist_returnsItemWithoutSummaries() throws {
        // Given
        let fields = Set(["series"])
        let givenItem = ComicFactory.make()

        // When
        let featureGet = sut.getItem(on: eventLoop, withID: givenItem.id, fields: fields, from: table, logger: nil, dataSource: .database)
        let item = try featureGet.wait()

        // Then
        XCTAssertNil(item.series)
        XCTAssertEqual(item.id, givenItem.id)
    }
    
    func test_whenGetItemCharactersField_returnItemWithCharacters() throws {
        // Given
        let fields = Set(["characters"])
        
        var items = ComicFactory.makeDatabaseItems()
        let characterItems = CharacterFactory.makeDatabaseItems()
        for character in characterItems {
            items[character.key] = character.value
        }
        
        sut = ComicUseCaseFactoryMock(items: items).makeUseCase()
        
        let givenItem = ComicFactory.make(charactersID: ["1"])
        let updateUseCase = ComicUpdateUseCaseFactoryMock().makeUseCase()
        let criteria = UpdateItemCriteria(item: givenItem, on: eventLoop, in: table)
        try updateUseCase.update(with: criteria).wait()

        // When
        let featureGet = sut.getItem(on: eventLoop, withID: givenItem.id, fields: fields, from: table, logger: nil, dataSource: .database)
        let item = try featureGet.wait()

        // Then
        XCTAssertEqual(item.characters?.first?.itemID, "Character#1")
        XCTAssertEqual(item.characters?.first?.summaryID, "Comic#1")
    }
    
    func test_whenGetItemSeriesField_returnItemWithSeries() throws {
        // Given
        let fields = Set(["series"])
        
        var items = ComicFactory.makeDatabaseItems()
        let seriesItems = SeriesFactory.makeDatabaseItems()
        for series in seriesItems {
            items[series.key] = series.value
        }
        
        sut = ComicUseCaseFactoryMock(items: items).makeUseCase()
        
        let givenItem = ComicFactory.make(seriesID: ["1"])
        let updateUseCase = ComicUpdateUseCaseFactoryMock().makeUseCase()
        let criteria = UpdateItemCriteria(item: givenItem, on: eventLoop, in: table)
        try updateUseCase.update(with: criteria).wait()

        // When
        let featureGet = sut.getItem(on: eventLoop, withID: givenItem.id, fields: fields, from: table, logger: nil, dataSource: .database)
        let item = try featureGet.wait()

        // Then
        XCTAssertEqual(item.series?.first?.itemID, "Series#1")
        XCTAssertEqual(item.series?.first?.summaryID, "Comic#1")
    }
    
    func testGetItem_whenFieldsAreCharactersAndSeries_returnItemWithCharactersAndSeries() throws {
        // Given
        let fields = Set(["characters", "series"])
        
        var items = ComicFactory.makeDatabaseItems()
        let characterItems = CharacterFactory.makeDatabaseItems()
        for character in characterItems {
            items[character.key] = character.value
        }
        
        let seriesItems = SeriesFactory.makeDatabaseItems()
        for series in seriesItems {
            items[series.key] = series.value
        }
        
        sut = ComicUseCaseFactoryMock(items: items).makeUseCase()
        
        let givenItem = ComicFactory.make(charactersID: ["1"], seriesID: ["1"])
        let updateUseCase = ComicUpdateUseCaseFactoryMock().makeUseCase()
        let criteria = UpdateItemCriteria(item: givenItem, on: eventLoop, in: table)
        try updateUseCase.update(with: criteria).wait()

        // When
        let featureGet = sut.getItem(on: eventLoop, withID: givenItem.id, fields: fields, from: table, logger: nil, dataSource: .database)
        let item = try featureGet.wait()

        // Then
        XCTAssertEqual(item.characters?.first?.itemID, "Character#1")
        XCTAssertEqual(item.series?.first?.itemID, "Series#1")
    }

    func test_whenGetAllItemsFromDatabase_returnsItems() throws {
        // Given
        MockDB.removeAll()
        let givenComics = ComicFactory.makeList
        let givenItems = ComicFactory.makeDatabaseItemsList()
        sut = ComicUseCaseFactoryMock(items: givenItems).makeUseCase()

        // When
        let featureGet = sut.getAllItems(on: eventLoop, summaryID: nil, fields: nil, from: table, logger: nil, dataSource: .database)
        let items = try featureGet.wait()

        // Then
        XCTAssertEqual(items.map { $0.id }.sorted(by: <), givenComics.map { $0.id }.sorted(by: <))
    }

}
