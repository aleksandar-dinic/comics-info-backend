//
//  DateFormatter+DefaultTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 29/01/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class DateFormatter_DefaultTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
    
    func test_defaultDateFormat() {
        // Given
        let defaultFormat = "dd MMMM yyyy HH:mm:ss Z"
        
        // When
        let dateFormatter = DateFormatter.default()
        
        // Then
        XCTAssertEqual(defaultFormat, dateFormatter.dateFormat)
    }
    
    func test_whenInitDefaultStringFromDate_isEqualToGivenString() {
        // Given
        let givenDate = Date(timeIntervalSince1970: 0)
        let givenString = "01 January 1970 00:00:00 +0000"
        
        // When
        let defaultString = DateFormatter.defaultString(from: givenDate)
        
        // Then
        XCTAssertEqual(givenString, defaultString)
    }
    
    func test_whenInitDefaultDateFromString_isEqualToGivenDate() {
        // Given
        let givenDate = Date(timeIntervalSince1970: 0)
        let givenString = "01 January 1970 00:00:00 +0000"
        
        // When
        let defaultDate = DateFormatter.defaultDate(from: givenString)
        
        // Then
        XCTAssertEqual(givenDate, defaultDate)
    }

}
