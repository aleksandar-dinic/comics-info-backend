//
//  SeriesSummaryTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class SeriesSummaryTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
    
    func test_whenUpdate_dateLastUpdatedIsUpdated() throws {
        // Given
        let series = SeriesFactory.make()
        var sut = SeriesSummaryFactory.make()
        let oldDateLastUpdated = sut.dateLastUpdated
        
        // When
        sut.update(with: series)
        
        // Then
        XCTAssertNotEqual(sut.dateLastUpdated, oldDateLastUpdated)
    }

    func test_whenUpdate_popularityIsUpdated() throws {
        // Given
        let series = SeriesFactory.make(popularity: 1)
        var sut = SeriesSummaryFactory.make(popularity: 0)
        
        // When
        sut.update(with: series)
        
        // Then
        XCTAssertEqual(sut.popularity, series.popularity)
    }
    
    func test_whenUpdate_nameIsUpdated() throws {
        // Given
        let series = SeriesFactory.make(title: "New Name")
        var sut = SeriesSummaryFactory.make(name: "Old Name")
        
        // When
        sut.update(with: series)
        
        // Then
        XCTAssertEqual(sut.name, series.name)
    }
    
    func test_whenUpdate_thumbnailIsUpdated() throws {
        // Given
        let series = SeriesFactory.make(thumbnail: "New Thumbnail")
        var sut = SeriesSummaryFactory.make(thumbnail: "Old Thumbnail")
        
        // When
        sut.update(with: series)
        
        // Then
        XCTAssertEqual(sut.thumbnail, series.thumbnail)
    }
    
    func test_whenUpdate_descriptionIsUpdated() throws {
        // Given
        let series = SeriesFactory.make(description: "New Description")
        var sut = SeriesSummaryFactory.make(description: "Old Description")
        
        // When
        sut.update(with: series)
        
        // Then
        XCTAssertEqual(sut.description, series.description)
    }

}
