//
//  ComicSummaryTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class ComicSummaryTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
    
    func test_whenUpdate_dateLastUpdatedIsUpdated() throws {
        // Given
        let comic = ComicFactory.make()
        var sut = ComicSummaryFactory.make()
        let oldDateLastUpdated = sut.dateLastUpdated
        
        // When
        sut.update(with: comic)
        
        // Then
        XCTAssertNotEqual(sut.dateLastUpdated, oldDateLastUpdated)
    }

    func test_whenUpdate_popularityIsUpdated() throws {
        // Given
        let comic = ComicFactory.make(popularity: 1)
        var sut = ComicSummaryFactory.make(popularity: 0)
        
        // When
        sut.update(with: comic)
        
        // Then
        XCTAssertEqual(sut.popularity, comic.popularity)
    }
    
    func test_whenUpdate_nameIsUpdated() throws {
        // Given
        let comic = ComicFactory.make(title: "New Name")
        var sut = ComicSummaryFactory.make(name: "Old Name")
        
        // When
        sut.update(with: comic)
        
        // Then
        XCTAssertEqual(sut.name, comic.name)
    }
    
    func test_whenUpdate_thumbnailIsUpdated() throws {
        // Given
        let comic = ComicFactory.make(thumbnail: "New Thumbnail")
        var sut = ComicSummaryFactory.make(thumbnail: "Old Thumbnail")
        
        // When
        sut.update(with: comic)
        
        // Then
        XCTAssertEqual(sut.thumbnail, comic.thumbnail)
    }
    
    func test_whenUpdate_descriptionIsUpdated() throws {
        // Given
        let comic = ComicFactory.make(description: "New Description")
        var sut = ComicSummaryFactory.make(description: "Old Description")
        
        // When
        sut.update(with: comic)
        
        // Then
        XCTAssertEqual(sut.description, comic.description)
    }

}
