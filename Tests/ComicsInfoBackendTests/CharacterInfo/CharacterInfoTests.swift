//
//  CharacterInfoTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 22/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import CharacterInfo
@testable import ComicsInfoCore
import AWSLambdaRuntime
import XCTest

final class CharacterInfoTests: XCTestCase {

    private var localServer: LocalServer!
    private var sut: CharacterInfo!

    override func setUpWithError() throws {
        localServer = LocalServer(enabled: true)
        sut = CharacterInfo(localServer: localServer)
    }

    override func tearDownWithError() throws {
        localServer = nil
        sut = nil
    }

    func test_whenRunCreate_noThrowError() throws {
        XCTAssertNoThrow(try sut.run(handler: .create))
    }

    func test_whenRunRead_noThrowError() throws {
        XCTAssertNoThrow(try sut.run(handler: .read))
    }

    func test_whenRunList_noThrowError() throws {
        XCTAssertNoThrow(try sut.run(handler: .list))
    }

    func test_whenRunWithNilHandler_throwHandlerUnknown() throws {
        XCTAssertThrowsError(try sut.run()) {
            XCTAssertEqual(($0 as? APIError), .handlerUnknown)
        }
    }

}
