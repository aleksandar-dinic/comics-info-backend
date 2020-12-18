//
//  ComicRepositoryAPIWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 22/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class ComicRepositoryAPIWrapperTests: XCTestCase, CreateComicProtocol {

    private var sut: ComicRepositoryAPIWrapper!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        sut = ComicRepositoryAPIWrapperMock.make()
        table = String.tableName(for: "TEST")
    }

    override func tearDownWithError() throws {
        sut = nil
        table = nil
    }

    func test_whenGetMetadata_isEqualToGivenMetadata() throws {
        // Given
        let givenComic = ComicMock.makeComic()
        try createComic(givenComic)

        // When
        let feature = sut.getMetadata(id: givenComic.id, from: table)
        let comic = try feature.wait()

        // Then
        XCTAssertEqual(comic.id, givenComic.id)
    }

    func test_whenGetMetadataNotExisting_throwsItemNotFound() throws {
        // Given
        let givenComic = ComicMock.makeComic()
        var thrownError: Error?

        // When
        let feature = sut.getMetadata(id: givenComic.id, from: table)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemNotFound(let itemID, let itemType) = error as? APIError {
            XCTAssertEqual(itemID, "comic#\(givenComic.id)")
            XCTAssertTrue(itemType == Comic.self)
        } else {
            XCTFail("Expected '.itemNotFound' but got \(error)")
        }
    }

}
