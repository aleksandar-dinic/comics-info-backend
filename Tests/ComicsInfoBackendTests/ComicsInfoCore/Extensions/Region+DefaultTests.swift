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

    func test_regionDefault_isEucentral1() throws {
        XCTAssertEqual(Region.default, .eucentral1)
    }

}
