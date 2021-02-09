//
//  CharacterTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 09/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class CharacterTests: XCTestCase {
    
    private var sut: Character!

    override func setUpWithError() throws {
        sut = CharacterFactory.make(id: "1")
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_whenUpdatePopularity_popularityIsUpdated() {
        // Given
        let newItem = CharacterFactory.make(id: "1", popularity: 0)
        
        // When
        sut.update(with: newItem)
        
        // Then
        XCTAssertEqual(sut.popularity, newItem.popularity)
    }
    
    func test_whenUpdateName_nameIsUpdated() {
        // Given
        let newItem = CharacterFactory.make(id: "1", name: "New Name")
        
        // When
        sut.update(with: newItem)
        
        // Then
        XCTAssertEqual(sut.name, newItem.name)
    }
    
    func test_whenUpdateDateLastUpdated_dateLastUpdatedIsUpdated() {
        // Given
        let newItem = CharacterFactory.make(id: "1")
        
        // When
        sut.update(with: newItem)
        
        // Then
        XCTAssertNotEqual(sut.dateAdded, sut.dateLastUpdated)
    }
    
    func test_whenUpdateThumbnail_thumbnailIsUpdated() {
        // Given
        let newItem = CharacterFactory.make(id: "1", thumbnail: "New Thumbnail")
        
        // When
        sut.update(with: newItem)
        
        // Then
        XCTAssertEqual(sut.thumbnail, newItem.thumbnail)
    }
    
    func test_whenUpdateNewThumbnailIsNil_thumbnailIsnotUpdated() {
        // Given
        let newItem = CharacterFactory.make(id: "1", thumbnail: nil)
        sut = CharacterFactory.make(id: "1", thumbnail: "Old Thumbnail")
        
        // When
        sut.update(with: newItem)
        
        // Then
        XCTAssertNotNil(sut.thumbnail)
    }
    
    func test_whenUpdateDescription_descriptionIsUpdated() {
        // Given
        let newItem = CharacterFactory.make(id: "1", description: "New Description")
        
        // When
        sut.update(with: newItem)
        
        // Then
        XCTAssertEqual(sut.description, newItem.description)
    }
    
    func test_whenUpdateNewDescriptionIsNil_descriptionIsnotUpdated() {
        // Given
        let newItem = CharacterFactory.make(id: "1", description: nil)
        sut = CharacterFactory.make(id: "1", description: "Old Description")
        
        // When
        sut.update(with: newItem)
        
        // Then
        XCTAssertNotNil(sut.description)
    }
    
    func test_whenUpdateRealName_realNameIsUpdated() {
        // Given
        let newItem = CharacterFactory.make(id: "1", realName: "New RealName")
        
        // When
        sut.update(with: newItem)
        
        // Then
        XCTAssertEqual(sut.realName, newItem.realName)
    }
    
    func test_whenUpdateNewRealNameIsNil_realNameIsnotUpdated() {
        // Given
        let newItem = CharacterFactory.make(id: "1", realName: nil)
        sut = CharacterFactory.make(id: "1", realName: "Old RealName")
        
        // When
        sut.update(with: newItem)
        
        // Then
        XCTAssertNotNil(sut.realName)
    }
    
    func test_whenUpdateAliases_aliasesIsUpdated() {
        // Given
        let newItem = CharacterFactory.make(id: "1", aliases: ["New Aliases"])
        
        // When
        sut.update(with: newItem)
        
        // Then
        XCTAssertTrue(Set(newItem.aliases ?? []).isSubset(of: Set(sut.aliases ?? [])))
    }
    
    func test_whenUpdateBirth_birthIsUpdated() {
        // Given
        let newItem = CharacterFactory.make(id: "1", birth: Date())
        
        // When
        sut.update(with: newItem)
        
        // Then
        XCTAssertEqual(sut.birth, newItem.birth)
    }
    
    func test_whenUpdateNewBirthIsNil_birthIsnotUpdated() {
        // Given
        let newItem = CharacterFactory.make(id: "1", birth: nil)
        sut = CharacterFactory.make(id: "1", birth: Date())
        
        // When
        sut.update(with: newItem)
        
        // Then
        XCTAssertNotNil(sut.birth)
    }

}
