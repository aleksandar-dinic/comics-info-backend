//
//  DatabaseDecoderTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 16/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class DatabaseDecoderTests: XCTestCase {

    enum CodingKeys: CodingKey {
        case key
    }

    private var sut: DatabaseDecoder!

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testDecodedData_whenDecode_isEqualToGivenData() throws {
        // Given
        let givenData = "Given Data"
        let databaseItem = DatabasePutItem([CodingKeys.key.stringValue: givenData], table: "")
        sut = DatabaseDecoder(from: databaseItem)

        // When
        let decodedData = try sut.decode(String.self, forKey: CodingKeys.key)

        // Then
        XCTAssertEqual(decodedData, givenData)
    }

    func test_whenDecodeWithMissingKey_throwsKeyNotFound() throws {
        // Given
        let databaseItem = DatabasePutItem(table: "")
        sut = DatabaseDecoder(from: databaseItem)
        var thrownError: Error?

        // When
        XCTAssertThrowsError(try sut.decode(String.self, forKey: CodingKeys.key)) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .keyNotFound(let key, _) = error as? DecodingError {
            XCTAssertEqual(key.stringValue, CodingKeys.key.stringValue)
        } else {
            XCTFail("Expected '.keyNotFound' but got \(error)")
        }
    }

    func test_whenDecodeWithMismatchType_throwsTypeMismatch() throws {
        // Given
        let givenData = "Given Data"
        let databaseItem = DatabasePutItem([CodingKeys.key.stringValue: givenData], table: "")
        sut = DatabaseDecoder(from: databaseItem)
        var thrownError: Error?

        // When
        XCTAssertThrowsError(try sut.decode(Int.self, forKey: CodingKeys.key)) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .typeMismatch(let type, _) = error as? DecodingError {
            XCTAssertTrue(type == Int.self)
        } else {
            XCTFail("Expected '.typeMismatch' but got \(error)")
        }
    }
    
    func test_whenDecodeWithDataCorrupted_throwsDataCorrupted() throws {
        // Given
        let givenData = "Invalid Data format"
        let databaseItem = DatabasePutItem([CodingKeys.key.stringValue: givenData], table: "")
        sut = DatabaseDecoder(from: databaseItem)
        var thrownError: Error?

        // When
        XCTAssertThrowsError(try sut.decode(Date.self, forKey: CodingKeys.key)) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .dataCorrupted = error as? DecodingError {
            XCTAssertTrue(error is DecodingError)
        } else {
            XCTFail("Expected '.dataCorupted' but got \(error)")
        }
    }

}
