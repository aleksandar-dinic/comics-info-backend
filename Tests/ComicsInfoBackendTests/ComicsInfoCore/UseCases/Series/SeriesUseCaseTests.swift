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
    private var sut: SeriesUseCase<SeriesRepositoryAPIWrapper, InMemoryCacheProvider<Series>>!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        table = String.tableName(for: "TEST")
        let items = SeriesMock.makeDatabaseItems()
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
        let givenItem = SeriesMock.makeSeries()
        var thrownError: Error?

        // When
        let featureGet = sut.getItem(on: eventLoop, withID: givenItem.id, fields: fields, from: table, dataSource: .database)
        XCTAssertThrowsError(try featureGet.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case let .invalidFields(invalidFields) = error as? APIError {
            XCTAssertEqual(invalidFields, ["Invalid"])
        } else {
            XCTFail("Expected '.invalidFields' but got \(error)")
        }
    }
    
    func testGetItem_whenOneOfFieldsIsInvalid_throwInvalidFields() throws {
        // Given
        let fields = Set(["characters", "comics", "Invalid"])
        let givenItem = SeriesMock.makeSeries()
        var thrownError: Error?

        // When
        let featureGet = sut.getItem(on: eventLoop, withID: givenItem.id, fields: fields, from: table, dataSource: .database)
        XCTAssertThrowsError(try featureGet.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case let .invalidFields(invalidFields) = error as? APIError {
            XCTAssertEqual(invalidFields, ["Invalid"])
        } else {
            XCTFail("Expected '.itemsNotFound' but got \(error)")
        }
    }

    func test_whenGetItemFromDatabase_returnsItem() throws {
        // Given
        let givenItem = SeriesMock.makeSeries()

        // When
        let featureGet = sut.getItem(on: eventLoop, withID: givenItem.id, fields: nil, from: table, dataSource: .database)
        let item = try featureGet.wait()

        // Then
        XCTAssertEqual(item.id, givenItem.id)
    }
    
    func test_whenGetItemWithoutFields_returnsItemWithoutSummaries() throws {
        // Given
        let givenItem = SeriesMock.makeSeries()

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
        let givenItem = SeriesMock.makeSeries()

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
        let givenItem = SeriesMock.makeSeries()

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
        
        var items = SeriesMock.makeDatabaseItems()
        let characterItems = CharacterMock.makeDatabaseItems()
        for character in characterItems {
            items[character.key] = character.value
        }
        
        sut = SeriesUseCaseFactoryMock(items: items).makeUseCase()
        
        let givenItem = SeriesMock.makeSeries(charactersID: ["1"])
        let updateUseCase = SeriesUpdateUseCaseFactoryMock().makeUseCase()
        try updateUseCase.update(givenItem, on: eventLoop, in: table).wait()

        // When
        let featureGet = sut.getItem(on: eventLoop, withID: givenItem.id, fields: fields, from: table, dataSource: .database)
        let item = try featureGet.wait()

        // Then
        XCTAssertEqual(item.characters?.first?.itemID, "Series#1")
        XCTAssertEqual(item.characters?.first?.summaryID, "Character#1")
        XCTAssertEqual(item.characters?.first?.itemName, "CharacterSummary<Series>")
    }
    
    func test_whenGetItemComicsField_returnItemWithComics() throws {
        // Given
        let fields = Set(["comics"])
        
        var items = SeriesMock.makeDatabaseItems()
        let comicItems = ComicMock.makeDatabaseItems()
        for comic in comicItems {
            items[comic.key] = comic.value
        }
        
        sut = SeriesUseCaseFactoryMock(items: items).makeUseCase()
        
        let givenItem = SeriesMock.makeSeries(comicsID: ["1"])
        let updateUseCase = SeriesUpdateUseCaseFactoryMock().makeUseCase()
        try updateUseCase.update(givenItem, on: eventLoop, in: table).wait()

        // When
        let featureGet = sut.getItem(on: eventLoop, withID: givenItem.id, fields: fields, from: table, dataSource: .database)
        let item = try featureGet.wait()

        // Then
        XCTAssertEqual(item.comics?.first?.itemID, "Series#1")
        XCTAssertEqual(item.comics?.first?.summaryID, "Comic#1")
        XCTAssertEqual(item.comics?.first?.itemName, "ComicSummary<Series>")
    }
    
    func testGetItem_whenFieldsAreCharactersAndComics_returnItemWithCharactersAndComics() throws {
        // Given
        let fields = Set(["characters", "comics"])
        
        var items = SeriesMock.makeDatabaseItems()
        let characterItems = CharacterMock.makeDatabaseItems()
        for character in characterItems {
            items[character.key] = character.value
        }
        
        let comicItems = ComicMock.makeDatabaseItems()
        for comic in comicItems {
            items[comic.key] = comic.value
        }
        
        sut = SeriesUseCaseFactoryMock(items: items).makeUseCase()
        
        let givenItem = SeriesMock.makeSeries(charactersID: ["1"], comicsID: ["1"])
        let updateUseCase = SeriesUpdateUseCaseFactoryMock().makeUseCase()
        try updateUseCase.update(givenItem, on: eventLoop, in: table).wait()

        // When
        let featureGet = sut.getItem(on: eventLoop, withID: givenItem.id, fields: fields, from: table, dataSource: .database)
        let item = try featureGet.wait()

        // Then
        XCTAssertEqual(item.characters?.first?.summaryID, "Character#1")
        XCTAssertEqual(item.comics?.first?.summaryID, "Comic#1")
    }

    func test_whenGetAllItemsFromDatabase_returnsItems() throws {
        // Given
        DatabaseMock.removeAll()
        let givenSeries = SeriesMock.seriesList
        let givenItems = SeriesMock.makeDatabaseItemsList()
        sut = SeriesUseCaseFactoryMock(items: givenItems).makeUseCase()

        // When
        let featureGet = sut.getAllItems(on: eventLoop, from: table, dataSource: .database)
        let items = try featureGet.wait()

        // Then
        XCTAssertEqual(items.map { $0.id }.sorted(by: <), givenSeries.map { $0.id }.sorted(by: <))
    }

}
