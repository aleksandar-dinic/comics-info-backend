//
//  SeriesUseCaseTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 29/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import NIO
import XCTest

final class SeriesUseCaseTests: XCTestCase {

    private var eventLoop: EventLoop!
    private var sut: SeriesUseCase<GetDatabaseProvider, InMemoryCacheProvider<Series>>!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        table = String.tableName(for: "TEST")
        let items = SeriesFactory.makeDatabaseItems()
        sut = SeriesUseCaseFactoryMock(items: items).makeUseCase()
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        sut = nil
        table = nil
    }
    
    func test_whenAvailableFields_isEqualToGivenFields() {
        // Given
        let fields = Set(["characters", "comics"])

        // When

        // Then
        XCTAssertEqual(sut.availableFields.sorted(), fields.sorted())
    }
    
    func testGetItem_whenFieldIsInvalid_throwInvalidFields() throws {
        // Given
        let fields = Set(["Invalid"])
        let givenItem = SeriesFactory.make()
        var thrownError: Error?

        // When
        let featureGet = sut.getItem(on: eventLoop, withID: givenItem.id, fields: fields, from: table, dataSource: .database)
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
        let fields = Set(["characters", "comics", "Invalid"])
        let givenItem = SeriesFactory.make()
        var thrownError: Error?

        // When
        let featureGet = sut.getItem(on: eventLoop, withID: givenItem.id, fields: fields, from: table, dataSource: .database)
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
        let givenItem = SeriesFactory.make()

        // When
        let featureGet = sut.getItem(on: eventLoop, withID: givenItem.id, fields: nil, from: table, dataSource: .database)
        let item = try featureGet.wait()

        // Then
        XCTAssertEqual(item.id, givenItem.id)
    }
    
    func test_whenGetItemWithoutFields_returnsItemWithoutSummaries() throws {
        // Given
        let givenItem = SeriesFactory.make()

        // When
        let featureGet = sut.getItem(on: eventLoop, withID: givenItem.id, fields: nil, from: table, dataSource: .database)
        let item = try featureGet.wait()

        // Then
        XCTAssertNil(item.characters)
        XCTAssertNil(item.comics)
    }
    
    func testGetItemWithFieldCharacter_whenCharacterSummaryDoesntExist_returnsItemWithoutSummaries() throws {
        // Given
        let fields = Set(["characters"])
        let givenItem = SeriesFactory.make()

        // When
        let featureGet = sut.getItem(on: eventLoop, withID: givenItem.id, fields: fields, from: table, dataSource: .database)
        let item = try featureGet.wait()

        // Then
        XCTAssertNil(item.characters)
        XCTAssertEqual(item.id, givenItem.id)
    }
    
    func testGetItemWithFieldComic_whenComicSummaryDoesntExist_returnsItemWithoutSummaries() throws {
        // Given
        let fields = Set(["comics"])
        let givenItem = SeriesFactory.make()

        // When
        let featureGet = sut.getItem(on: eventLoop, withID: givenItem.id, fields: fields, from: table, dataSource: .database)
        let item = try featureGet.wait()

        // Then
        XCTAssertNil(item.comics)
        XCTAssertEqual(item.id, givenItem.id)
    }
    
    func test_whenGetItemCharactersField_returnItemWithCharacters() throws {
        // Given
        let fields = Set(["characters"])
        
        var items = SeriesFactory.makeDatabaseItems()
        let characterItems = CharacterFactory.makeDatabaseItems()
        for character in characterItems {
            items[character.key] = character.value
        }
        
        sut = SeriesUseCaseFactoryMock(items: items).makeUseCase()
        
        let givenItem = SeriesFactory.make(charactersID: ["1"])
        let updateUseCase = SeriesUpdateUseCaseFactoryMock().makeUseCase()
        try updateUseCase.update(givenItem, on: eventLoop, in: table).wait()

        // When
        let featureGet = sut.getItem(on: eventLoop, withID: givenItem.id, fields: fields, from: table, dataSource: .database)
        let item = try featureGet.wait()

        // Then
        XCTAssertEqual(item.characters?.first?.itemID, "Character#1")
        XCTAssertEqual(item.characters?.first?.summaryID, "Series#1")
        XCTAssertEqual(item.characters?.first?.itemName, "CharacterSummary<Series>")
    }
    
    func test_whenGetItemComicsField_returnItemWithComics() throws {
        // Given
        let fields = Set(["comics"])
        
        var items = SeriesFactory.makeDatabaseItems()
        let comicItems = ComicFactory.makeDatabaseItems()
        for comic in comicItems {
            items[comic.key] = comic.value
        }
        
        sut = SeriesUseCaseFactoryMock(items: items).makeUseCase()
        
        let givenItem = SeriesFactory.make(comicsID: ["1"])
        let updateUseCase = SeriesUpdateUseCaseFactoryMock().makeUseCase()
        try updateUseCase.update(givenItem, on: eventLoop, in: table).wait()

        // When
        let featureGet = sut.getItem(on: eventLoop, withID: givenItem.id, fields: fields, from: table, dataSource: .database)
        let item = try featureGet.wait()

        // Then
        XCTAssertEqual(item.comics?.first?.itemID, "Comic#1")
        XCTAssertEqual(item.comics?.first?.summaryID, "Series#1")
        XCTAssertEqual(item.comics?.first?.itemName, "ComicSummary<Series>")
    }
    
    func testGetItem_whenFieldsAreCharactersAndComics_returnItemWithCharactersAndComics() throws {
        // Given
        let fields = Set(["characters", "comics"])
        
        var items = SeriesFactory.makeDatabaseItems()
        let characterItems = CharacterFactory.makeDatabaseItems()
        for character in characterItems {
            items[character.key] = character.value
        }
        
        let comicItems = ComicFactory.makeDatabaseItems()
        for comic in comicItems {
            items[comic.key] = comic.value
        }
        
        sut = SeriesUseCaseFactoryMock(items: items).makeUseCase()
        
        let givenItem = SeriesFactory.make(charactersID: ["1"], comicsID: ["1"])
        let updateUseCase = SeriesUpdateUseCaseFactoryMock().makeUseCase()
        try updateUseCase.update(givenItem, on: eventLoop, in: table).wait()

        // When
        let featureGet = sut.getItem(on: eventLoop, withID: givenItem.id, fields: fields, from: table, dataSource: .database)
        let item = try featureGet.wait()

        // Then
        XCTAssertEqual(item.characters?.first?.itemID, "Character#1")
        XCTAssertEqual(item.comics?.first?.itemID, "Comic#1")
    }

    func test_whenGetAllItemsFromDatabase_returnsItems() throws {
        // Given
        DatabaseMock.removeAll()
        let givenSeries = SeriesFactory.seriesList
        let givenItems = SeriesFactory.makeDatabaseItemsList()
        sut = SeriesUseCaseFactoryMock(items: givenItems).makeUseCase()

        // When
        let featureGet = sut.getAllItems(on: eventLoop, fields: nil, from: table, dataSource: .database)
        let items = try featureGet.wait()

        // Then
        XCTAssertEqual(items.map { $0.id }.sorted(by: <), givenSeries.map { $0.id }.sorted(by: <))
    }

}
