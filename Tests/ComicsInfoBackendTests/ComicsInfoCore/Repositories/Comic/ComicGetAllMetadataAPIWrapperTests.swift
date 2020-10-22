//
//  ComicGetAllMetadataAPIWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class ComicGetAllMetadataAPIWrapperTests: XCTestCase, CreateCharacterProtocol, CreateSeriesProtocol, CreateComicProtocol {

    private var sut: ComicGetAllMetadataAPIWrapper!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        sut = ComicGetAllMetadataAPIWrapperMock.make()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_whenGetAllMetadata_returnsAllMetadata() throws {
        // Given
        let character = CharacterMock.makeCharacter(id: "1")
        try createCharacter(character)
        let series = SeriesMock.makeSeries(id: "1")
        try createSeries(series)
        try createComic(ComicMock.makeComic(id: "2", charactersID: [character.id]))
        try createComic(ComicMock.makeComic(id: "1", seriesID: [series.id]))

        // When
        let feature = sut.getAllMetadata(ids: ["1", "2"])
        let comics = try feature.wait()

        // Then
        XCTAssertEqual(comics.map { $0.id }.sorted(by: <), ["1", "2"])
    }

    func test_whenGetAllMetadata_throwsItemsNotFound() throws {
        // Given
        var thrownError: Error?

        // When
        let feature = sut.getAllMetadata(ids: ["1", "2"])
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemsNotFound(let itemIDs, let itemType) = error as? APIError {
            XCTAssertEqual(itemIDs, ["1", "2"])
            XCTAssertTrue(itemType == Comic.self)
        } else {
            XCTFail("Expected '.itemsNotFound' but got \(error)")
        }
    }

}
