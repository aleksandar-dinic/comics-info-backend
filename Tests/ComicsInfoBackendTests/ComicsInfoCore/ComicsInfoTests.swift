//
//  ComicsInfoTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 11/08/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

//@testable import ComicsInfo
//@testable import ComicsInfoCore
//import AWSLambdaRuntime
//import XCTest
//
//final class ComicsInfoTests: XCTestCase {
//
//    private var localServer: LocalServer!
//    private var sut: ComicsInfo!
//
//    override func setUpWithError() throws {
//        localServer = LocalServer(enabled: true)
//        sut = ComicsInfo(localServer: localServer)
//    }
//
//    override func tearDownWithError() throws {
//        localServer = nil
//        sut = nil
//    }
//
////    func test_whenRunCreate_noThrowError() throws {
////        XCTAssertNoThrow(try sut.run(handler: .create))
////    }
////
////    func test_whenRunRead_noThrowError() throws {
////        XCTAssertNoThrow(try sut.run(handler: .read))
////    }
////
////    func test_whenRunList_noThrowError() throws {
////        XCTAssertNoThrow(try sut.run(handler: .list))
////    }
////
////    func test_whenUpdateList_noThrowError() throws {
////        XCTAssertNoThrow(try sut.run(handler: .update))
////    }
//
//    func test_whenRunWithNilHandler_throwHandlerUnknown() throws {
//        XCTAssertThrowsError(try sut.run()) {
//            XCTAssertEqual($0.localizedDescription, ComicInfoError.handlerUnknown.localizedDescription)
//        }
//    }
//
//}
