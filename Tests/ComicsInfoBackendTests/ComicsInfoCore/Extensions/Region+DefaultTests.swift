//
//  Region+DefaultTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 07/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import SotoDynamoDB
import XCTest

final class Region_DefaultTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testRegion_whenGetFromLambdaEnvironment_regionIsEuCentral1() throws {
        // Given
        let eucentral1 = Region.eucentral1
        
        // When
        let region = Region.getFromEnvironment()
        
        // Then
        XCTAssertEqual(region, eucentral1)
    }
    
    func testRegion_whenGetEnvironment_regionIsEqualToGivenRegion() throws {
        // Given
        let givenRegion = Region.eucentral1
        
        // When
        let region = Region.getFromEnvironment("eu-central-1")
        
        // Then
        XCTAssertEqual(region, givenRegion)
    }

}
