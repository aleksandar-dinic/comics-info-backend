//
//  ResponseMessageTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 29/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class ResponseMessageTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testMessage_whenInitResponseMessage_isEqualToGivenMessage() {
        // Given
        let givenMessage = "Given Message"
        
        // When
        let response = ResponseMessage(givenMessage)
        
        // Then
        XCTAssertEqual(response.message, givenMessage)
    }
    
}
