//
//  ComicUpdateAPIWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 22/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class ComicUpdateAPIWrapperTests: XCTestCase, CreateCharacterProtocol, CreateSeriesProtocol, CreateComicProtocol {

    private var sut: ComicUpdateAPIWrapper!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        sut = ComicUpdateAPIWrapperMock.make(items: [:])
        table = String.tableName(for: "TEST")
    }

    override func tearDownWithError() throws {
        sut = nil
        table = nil
    }

    func test_whenUpdateComic_comicIsUpdated() throws {
        // Given
        try createComic(ComicMock.makeComic(title: "Old Title"))

        // When
        let feature = sut.update(ComicMock.makeComic(), in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }

}
