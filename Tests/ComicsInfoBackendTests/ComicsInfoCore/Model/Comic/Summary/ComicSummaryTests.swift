//
//  ComicSummaryTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 15/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class ComicSummaryTests: XCTestCase {

    private var sut: ComicSummary!

    override func setUpWithError() throws {
        sut = ComicSummaryMock.comicSummary
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    // MARK: - Update

    func testPopularity_whenUpdateWithComic_isEqulToComicPopularity() {
        // Given
        let comic = ComicMock.comic

        // When
        sut.update(with: comic)

        // Then
        XCTAssertEqual(sut.popularity, comic.popularity)
    }

    func testTitle_whenUpdateWithComic_isEqulToComicTitle() {
        // Given
        let comic = ComicMock.comic

        // When
        sut.update(with: comic)

        // Then
        XCTAssertEqual(sut.title, comic.title)
    }

    func testThumbnail_whenUpdateWithComic_isEqulToComicThumbnail() {
        // Given
        let comic = ComicMock.comic

        // When
        sut.update(with: comic)

        // Then
        XCTAssertEqual(sut.thumbnail, comic.thumbnail)
    }

    func testDescription_whenUpdateWithComic_isEqulToComicDescription() {
        // Given
        let comic = ComicMock.comic

        // When
        sut.update(with: comic)

        // Then
        XCTAssertEqual(sut.description, comic.description)
    }

    // MARK: - Should Be Updated

    func test_whenShouldBeUpdatedWithComicDiffPopularity_isTrue() {
        // Given
        let comic = ComicMock.makeComic(
            popularity: 1,
            title: "Title",
            thumbnail: "Thumbnail",
            description: "Description"
        )
        let sut = ComicSummaryMock.makeComicSummary(
            popularity: 0,
            title: "Title",
            thumbnail: "Thumbnail",
            description: "Description"
        )

        // When
        let shouldBeUpdated = sut.shouldBeUpdated(with: comic)

        // Then
        XCTAssertTrue(shouldBeUpdated)
    }

    func test_whenShouldBeUpdatedWithComicDiffTitle_isTrue() {
        // Given
        let comic = ComicMock.makeComic(
            popularity: 0,
            title: "New Title",
            thumbnail: "Thumbnail",
            description: "Description"
        )
        let sut = ComicSummaryMock.makeComicSummary(
            popularity: 0,
            title: "Old Title",
            thumbnail: "Thumbnail",
            description: "Description"
        )

        // When
        let shouldBeUpdated = sut.shouldBeUpdated(with: comic)

        // Then
        XCTAssertTrue(shouldBeUpdated)
    }

    func test_whenShouldBeUpdatedWithComicDiffThumbnail_isTrue() {
        // Given
        let comic = ComicMock.makeComic(
            popularity: 0,
            title: "Title",
            thumbnail: "New Thumbnail",
            description: "Description"
        )
        let sut = ComicSummaryMock.makeComicSummary(
            popularity: 0,
            title: "Title",
            thumbnail: "Old Thumbnail",
            description: "Description"
        )

        // When
        let shouldBeUpdated = sut.shouldBeUpdated(with: comic)

        // Then
        XCTAssertTrue(shouldBeUpdated)
    }

    func test_whenShouldBeUpdatedWithComicDiffDescription_isTrue() {
        // Given
        let comic = ComicMock.makeComic(
            popularity: 0,
            title: "Title",
            thumbnail: "Thumbnail",
            description: "New Description"
        )
        let sut = ComicSummaryMock.makeComicSummary(
            popularity: 0,
            title: "Title",
            thumbnail: "Thumbnail",
            description: "Old Description"
        )

        // When
        let shouldBeUpdated = sut.shouldBeUpdated(with: comic)

        // Then
        XCTAssertTrue(shouldBeUpdated)
    }

    func test_whenShouldBeUpdatedWithComic_isFalse() {
        // Given
        let Comic = ComicMock.makeComic(
            popularity: 0,
            title: "Title",
            thumbnail: "Thumbnail",
            description: "Description"
        )
        let sut = ComicSummaryMock.makeComicSummary(
            popularity: 0,
            title: "Title",
            thumbnail: "Thumbnail",
            description: "Description"
        )

        // When
        let shouldBeUpdated = sut.shouldBeUpdated(with: Comic)

        // Then
        XCTAssertFalse(shouldBeUpdated)
    }

}
