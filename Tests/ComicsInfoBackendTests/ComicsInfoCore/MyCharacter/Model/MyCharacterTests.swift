//
//  MyCharacterTests.swift
//  
//
//  Created by Aleksandar Dinic on 2/6/22.
//

@testable import ComicsInfoCore
import XCTest

final class MyCharacterTests: XCTestCase {
    
    private var sut: MyCharacter!
    private var newMyCharacter: MyCharacter!

    override func setUpWithError() throws {
        sut = MyCharacter.make(
            mySeries: [
                MySeriesSummary.make(identifier: "MySeries#1", popularity: 0, title: "Title1")
            ]
        )
        newMyCharacter = MyCharacter.make(
            mySeries: [
                MySeriesSummary.make(identifier: "MySeries#2", popularity: 0, title: "Title1")
            ]
        )
    }

    override func tearDownWithError() throws {
        sut = nil
        newMyCharacter = nil
    }

    func test_whenUpdateWithNewMyCharacter_mySeriesIsUpdated() {
        // Given
        
        // When
        sut.update(with: newMyCharacter)
        
        // Then
        XCTAssertEqual(sut.mySeries?.count, 2)
    }

}
