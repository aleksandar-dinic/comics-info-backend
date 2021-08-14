//
//  ProcessInfo+EnvironmentTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 07/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class ProcessInfo_EnvironmentTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

//    func testIsLocalServerEnabled_whenKeyIsDefault_assertTrue() {
//        // Given
//
//        // When
//        let isLocalServer = ProcessInfo.isLocalServerEnabled()
//
//        // Then
//        XCTAssertTrue(isLocalServer)
//    }
    
    func testIsLocalServerEnabled_when_assertFalse() {
        // Given
        let dummyKey = "DummyKey"
        
        // When
        let isLocalServer = ProcessInfo.isLocalServerEnabled(dummyKey)
        
        // Then
        XCTAssertFalse(isLocalServer)
    }

}
