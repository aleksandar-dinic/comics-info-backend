//
//  SeriesGetAllAPIWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class SeriesGetAllAPIWrapperTests: XCTestCase, CreateCharacterProtocol, CreateSeriesProtocol, CreateComicProtocol {

    private var sut: SeriesGetAllAPIWrapper!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        sut = SeriesGetAllAPIWrapperMock.make(items: [:])
        table = String.tableName(for: "TEST")
    }

    override func tearDownWithError() throws {
        sut = nil
        table = nil
    }

    func test_whenGetAllItems_returnsAllItems() throws {
        // Given
        let character = CharacterMock.makeCharacter(id: "1")
        try createCharacter(character)
        let comic = ComicMock.makeComic(id: "1")
        try createComic(comic)
        try createSeries(SeriesMock.makeSeries(id: "1", charactersID: [character.id]))
        try createSeries(SeriesMock.makeSeries(id: "2", comicsID: [comic.id]))

        // When
        let feature = sut.getAll(from: table)
        let series = try feature.wait()

        // Then
        XCTAssertEqual(series.map { $0.id }.sorted(by: <), ["1", "2"])
    }

    func test_whenGetAllItems_throwsItemsNotFound() throws {
        // Given
        var thrownError: Error?

        // When
        let feature = sut.getAll(from: table)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemsNotFound(let itemIDs, let itemType) = error as? APIError {
            XCTAssertNil(itemIDs)
            XCTAssertTrue(itemType == Series.self)
        } else {
            XCTFail("Expected '.itemsNotFound' but got \(error)")
        }
    }

}
