//
//  ComicTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 29/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class ComicTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testTitle_isEqualToName() {
        // Given
        let comic = ComicFactory.make()
        
        // When
        
        // Then
        XCTAssertEqual(comic.title, comic.name)
    }

}
