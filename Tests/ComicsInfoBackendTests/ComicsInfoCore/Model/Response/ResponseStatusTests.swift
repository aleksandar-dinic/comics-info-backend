//
//  ResponseStatusTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 29/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class ResponseStatusTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testStatus_whenInitResponseStatus_isEqualToGivenStatus() {
        // Given
        let givenStatus = "Given Status"
        
        // When
        let responseStatus = ResponseStatus(givenStatus)
        
        // Then
        XCTAssertEqual(responseStatus.status, givenStatus)
    }
    
}
