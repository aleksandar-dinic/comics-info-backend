//
//  String+DatabaseTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 07/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class String_DatabaseTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
    
    func test_tableNameForNIlEnvironment_isEmpty() {
        XCTAssertEqual(String.tableName(for: nil), "")
    }

    func test_getTypeFromCharacter_isEqualCharacter() {
        XCTAssertEqual(String.getType(from: Character.self), "Character")
    }

    func test_getTypeFromSeries_isEqualSeries() {
        XCTAssertEqual(String.getType(from: Series.self), "Series")
    }

    func test_getTypeFromComic_isEqualComic() {
        XCTAssertEqual(String.getType(from: Comic.self), "Comic")
    }
    
    func test_getTypeFromCharacterSummary_isEqualCharacterSummary() {
        XCTAssertEqual(String.getType(from: CharacterSummary.self), "CharacterSummary")
    }
    
    func test_getTypeFromSeriesSummary_isEqualSeriesSummary() {
        XCTAssertEqual(String.getType(from: SeriesSummary.self), "SeriesSummary")
    }
    
    func test_getTypeFromComicSummary_isEqualComicSummary() {
        XCTAssertEqual(String.getType(from: ComicSummary.self), "ComicSummary")
    }
    
}
