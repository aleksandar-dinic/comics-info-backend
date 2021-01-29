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

    func test_getTypeFromCharacter_isEqualCharacter() throws {
        XCTAssertEqual(String.getType(from: Character.self), "Character")
    }

    func test_getTypeFromSeries_isEqualSeries() throws {
        XCTAssertEqual(String.getType(from: Series.self), "Series")
    }

    func test_getTypeFromComic_isEqualComic() throws {
        XCTAssertEqual(String.getType(from: Comic.self), "Comic")
    }
    
    func test_getTypeFromCharacterSummarySeries_isEqualCharacterSummarySeries() throws {
        XCTAssertEqual(String.getType(from: CharacterSummary<Series>.self), "CharacterSummary<Series>")
    }
    
    func test_getTypeFromCharacterSummaryComic_isEqualCharacterSummaryComic() throws {
        XCTAssertEqual(String.getType(from: CharacterSummary<Comic>.self), "CharacterSummary<Comic>")
    }

    func test_getTypeFromSeriesSummaryCharacter_isEqualSeriesSummaryCharacter() throws {
        XCTAssertEqual(String.getType(from: SeriesSummary<Character>.self), "SeriesSummary<Character>")
    }
    
    func test_getTypeFromSeriesSummaryComic_isEqualSeriesSummaryComic() throws {
        XCTAssertEqual(String.getType(from: SeriesSummary<Comic>.self), "SeriesSummary<Comic>")
    }
    
    func test_getTypeFromComicSummaryCharacter_isEqualComicSummaryCharacter() throws {
        XCTAssertEqual(String.getType(from: ComicSummary<Character>.self), "ComicSummary<Character>")
    }
    
    func test_getTypeFromComicSummarySeries_isEqualComicSummarySeries() throws {
        XCTAssertEqual(String.getType(from: ComicSummary<Series>.self), "ComicSummary<Series>")
    }
    
    
}
