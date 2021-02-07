//
//  CharacterSummaryTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class CharacterSummaryTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
    
    func test_whenUpdate_dateLastUpdatedIsUpdated() throws {
        // Given
        let character = CharacterFactory.make()
        var sut: CharacterSummary<Series> = CharacterSummaryFactory.make()
        let oldDateLastUpdated = sut.dateLastUpdated
        
        // When
        sut.update(with: character)
        
        // Then
        XCTAssertNotEqual(sut.dateLastUpdated, oldDateLastUpdated)
    }

    func test_whenUpdate_popularityIsUpdated() throws {
        // Given
        let character = CharacterFactory.make(popularity: 1)
        var sut: CharacterSummary<Series> = CharacterSummaryFactory.make(popularity: 0)
        
        // When
        sut.update(with: character)
        
        // Then
        XCTAssertEqual(sut.popularity, character.popularity)
    }
    
    func test_whenUpdate_nameIsUpdated() throws {
        // Given
        let character = CharacterFactory.make(name: "New Name")
        var sut: CharacterSummary<Series> = CharacterSummaryFactory.make(name: "Old Name")
        
        // When
        sut.update(with: character)
        
        // Then
        XCTAssertEqual(sut.name, character.name)
    }
    
    func test_whenUpdate_thumbnailIsUpdated() throws {
        // Given
        let character = CharacterFactory.make(thumbnail: "New Thumbnail")
        var sut: CharacterSummary<Series> = CharacterSummaryFactory.make(thumbnail: "Old Thumbnail")
        
        // When
        sut.update(with: character)
        
        // Then
        XCTAssertEqual(sut.thumbnail, character.thumbnail)
    }
    
    func test_whenUpdate_descriptionIsUpdated() throws {
        // Given
        let character = CharacterFactory.make(description: "New Description")
        var sut: CharacterSummary<Series> = CharacterSummaryFactory.make(description: "Old Description")
        
        // When
        sut.update(with: character)
        
        // Then
        XCTAssertEqual(sut.description, character.description)
    }

}
