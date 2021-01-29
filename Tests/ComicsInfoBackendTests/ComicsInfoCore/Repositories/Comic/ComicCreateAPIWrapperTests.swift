//
//  ComicCreateAPIWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class ComicCreateAPIWrapperTests: XCTestCase, CreateCharacterProtocol, CreateSeriesProtocol {

    private var sut: ComicCreateAPIWrapper!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        sut = ComicCreateAPIWrapperMock.make(items: [:])
        table = String.tableName(for: "TEST")
    }

    override func tearDownWithError() throws {
        sut = nil
        table = nil
    }

    func test_whenCrateComic_comicIsCreated() throws {
        // Given

        // When
        let feature = sut.create(ComicMock.makeComic(), in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }

    func test_whenComicTheSameComicTwice_throwsItemAlreadyExists() throws {
        // Given
        var feature = sut.create(ComicMock.makeComic(), in: table)
        try feature.wait()
        var thrownError: Error?

        // When
        feature = sut.create(ComicMock.makeComic(), in: table)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemAlreadyExists(let itemID, let itemType) = error as? APIError {
            XCTAssertEqual(itemID, "1")
            XCTAssertTrue(itemType == Comic.self)
        } else {
            XCTFail("Expected '.itemAlreadyExists' but got \(error)")
        }
    }

}
