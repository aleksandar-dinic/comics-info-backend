//
//  SeriesSummaryTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 15/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class SeriesSummaryTests: XCTestCase {

    private var sut: SeriesSummary!

    override func setUpWithError() throws {
        sut = SeriesSummaryMock.seriesSummary
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    // MARK: - Update

    func testPopularity_whenUpdateWithSeries_isEqulToSeriesPopularity() {
        // Given
        let series = SeriesMock.series

        // When
        sut.update(with: series)

        // Then
        XCTAssertEqual(sut.popularity, series.popularity)
    }

    func testTitle_whenUpdateWithSeries_isEqulToSeriesTitle() {
        // Given
        let series = SeriesMock.series

        // When
        sut.update(with: series)

        // Then
        XCTAssertEqual(sut.title, series.title)
    }

    func testThumbnail_whenUpdateWithSeries_isEqulToSeriesThumbnail() {
        // Given
        let series = SeriesMock.series

        // When
        sut.update(with: series)

        // Then
        XCTAssertEqual(sut.thumbnail, series.thumbnail)
    }

    func testDescription_whenUpdateWithSeries_isEqulToSeriesDescription() {
        // Given
        let series = SeriesMock.series

        // When
        sut.update(with: series)

        // Then
        XCTAssertEqual(sut.description, series.description)
    }

    // MARK: - Should Be Updated

    func test_whenShouldBeUpdatedWithSeriesDiffPopularity_isTrue() {
        // Given
        let series = SeriesMock.makeSeries(
            popularity: 1,
            title: "Title",
            thumbnail: "Thumbnail",
            description: "Description"
        )
        let sut = SeriesSummaryMock.makeSeriesSummary(
            popularity: 0,
            title: "Title",
            thumbnail: "Thumbnail",
            description: "Description"
        )

        // When
        let shouldBeUpdated = sut.shouldBeUpdated(with: series)

        // Then
        XCTAssertTrue(shouldBeUpdated)
    }

    func test_whenShouldBeUpdatedWithSeriesDiffName_isTrue() {
        // Given
        let series = SeriesMock.makeSeries(
            popularity: 0,
            title: "New Title",
            thumbnail: "Thumbnail",
            description: "Description"
        )
        let sut = SeriesSummaryMock.makeSeriesSummary(
            popularity: 0,
            title: "Old Title",
            thumbnail: "Thumbnail",
            description: "Description"
        )

        // When
        let shouldBeUpdated = sut.shouldBeUpdated(with: series)

        // Then
        XCTAssertTrue(shouldBeUpdated)
    }

    func test_whenShouldBeUpdatedWithSeriesDiffThumbnail_isTrue() {
        // Given
        let series = SeriesMock.makeSeries(
            popularity: 0,
            title: "Title",
            thumbnail: "New Thumbnail",
            description: "Description"
        )
        let sut = SeriesSummaryMock.makeSeriesSummary(
            popularity: 0,
            title: "Title",
            thumbnail: "Old Thumbnail",
            description: "Description"
        )

        // When
        let shouldBeUpdated = sut.shouldBeUpdated(with: series)

        // Then
        XCTAssertTrue(shouldBeUpdated)
    }

    func test_whenShouldBeUpdatedWithSeriesDiffDescription_isTrue() {
        // Given
        let series = SeriesMock.makeSeries(
            popularity: 0,
            title: "Title",
            thumbnail: "Thumbnail",
            description: "New Description"
        )
        let sut = SeriesSummaryMock.makeSeriesSummary(
            popularity: 0,
            title: "Title",
            thumbnail: "Thumbnail",
            description: "Old Description"
        )

        // When
        let shouldBeUpdated = sut.shouldBeUpdated(with: series)

        // Then
        XCTAssertTrue(shouldBeUpdated)
    }

    func test_whenShouldBeUpdatedWithSeries_isFalse() {
        // Given
        let series = SeriesMock.makeSeries(
            popularity: 0,
            title: "Title",
            thumbnail: "Thumbnail",
            description: "Description"
        )
        let sut = SeriesSummaryMock.makeSeriesSummary(
            popularity: 0,
            title: "Title",
            thumbnail: "Thumbnail",
            description: "Description"
        )

        // When
        let shouldBeUpdated = sut.shouldBeUpdated(with: series)

        // Then
        XCTAssertFalse(shouldBeUpdated)
    }

}
