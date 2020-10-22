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

    func test_getTypeFromCharacter_isEqualCharacter() throws {
        XCTAssertEqual(String.getType(from: Character.self), "character")
    }

    func test_getTypeFromSeries_isEqualSeries() throws {
        XCTAssertEqual(String.getType(from: Series.self), "series")
    }

    func test_getTypeFromComic_isEqualComic() throws {
        XCTAssertEqual(String.getType(from: Comic.self), "comic")
    }

}
