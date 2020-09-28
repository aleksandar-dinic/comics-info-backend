//
//  AttributeValueAnyTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import SotoDynamoDB
import XCTest

final class AttributeValueAnyTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testB_whenMapToAny_isEqualToGivenData() throws {
        // Given
        let givenData = Data(buffer: ByteBuffer(string: "Data"))
        let attributeValue = DynamoDB.AttributeValue.b(givenData)

        // When
        let anyData = attributeValue.value

        // Then
        let data = try XCTUnwrap(anyData as? Data)
        XCTAssertEqual(data, givenData)
    }

    func testBool_whenMapToAny_isEqualToGivenBool() throws {
        // Given
        let givenBool = true
        let attributeValue = DynamoDB.AttributeValue.bool(givenBool)

        // When
        let anyData = attributeValue.value

        // Then
        let data = try XCTUnwrap(anyData as? Bool)
        XCTAssertEqual(data, givenBool)
    }

    func testBS_whenMapToAny_isEqualToGivenDataList() throws {
        // Given
        let givenDataList = [
            Data(buffer: ByteBuffer(string: "Data1")),
            Data(buffer: ByteBuffer(string: "Data2"))
        ]
        let attributeValue = DynamoDB.AttributeValue.bs(givenDataList)

        // When
        let anyData = attributeValue.value

        // Then
        let data = try XCTUnwrap(anyData as? [Data])
        XCTAssertEqual(data, givenDataList)
    }

    func testL_whenMapToAny_isEqualToGivenDataList() throws {
        // Given
        let givenList = [
            DynamoDB.AttributeValue.bool(true),
            DynamoDB.AttributeValue.s("String")
        ]
        let attributeValue = DynamoDB.AttributeValue.l(givenList)

        // When
        let anyData = attributeValue.value

        // Then
        let data = try XCTUnwrap(anyData as? [DynamoDB.AttributeValue])
        XCTAssertEqual(data, givenList)
    }

    func testM_whenMapToAny_isEqualToGivenDict() throws {
        // Given
        let givenDict = [
            "Key1": DynamoDB.AttributeValue.s("Value1"),
            "Key2": DynamoDB.AttributeValue.n("1"),
        ]
        let attributeValue = DynamoDB.AttributeValue.m(givenDict)

        // When
        let anyData = attributeValue.value

        // Then
        let data = try XCTUnwrap(anyData as? [String: Any])
        XCTAssertEqual(data.count, givenDict.count)
    }

    func testN_whenMapToAny_isEqualToGivenInt() throws {
        // Given
        let givenInt = 42
        let attributeValue = DynamoDB.AttributeValue.n(String(givenInt))

        // When
        let anyData = attributeValue.value

        // Then
        let data = try XCTUnwrap(anyData as? Int)
        XCTAssertEqual(data, givenInt)
    }

    func testN_whenMapToAny_isEqualToGivenDouble() throws {
        // Given
        let givenDouble = 42.42
        let attributeValue = DynamoDB.AttributeValue.n(String(givenDouble))

        // When
        let anyData = attributeValue.value

        // Then
        let data = try XCTUnwrap(anyData as? Double)
        XCTAssertEqual(data, givenDouble)
    }

    func testNS_whenMapToAny_isEqualToGivenIntList() throws {
        // Given
        let givenIntList = [1, 2, 3, 4, 5]
        let attributeValue = DynamoDB.AttributeValue.ns(givenIntList.map(String.init))

        // When
        let anyData = attributeValue.value

        // Then
        let data = try XCTUnwrap(anyData as? [Int])
        XCTAssertEqual(data, givenIntList)
    }

    func testNS_whenMapToAny_isEqualToGivenDoubleList() throws {
        // Given
        let givenDoubleList = [1.1, 2.2, 3.3, 4.4, 5.5]
        let attributeValue = DynamoDB.AttributeValue.ns(givenDoubleList.map { String($0) })

        // When
        let anyData = attributeValue.value

        // Then
        let data = try XCTUnwrap(anyData as? [Double])
        XCTAssertEqual(data, givenDoubleList)
    }

    func testNull_whenMapToAny_isNull() throws {
        // Given
        let attributeValue = DynamoDB.AttributeValue.null(true)

        // When
        let anyData = attributeValue.value

        // Then
        let data = try XCTUnwrap(anyData as? Bool)
        XCTAssertTrue(data)
    }

    func testS_whenMapToAny_isGivenString() throws {
        // Given
        let givenString = "String"
        let attributeValue = DynamoDB.AttributeValue.s(givenString)

        // When
        let anyData = attributeValue.value

        // Then
        let data = try XCTUnwrap(anyData as? String)
        XCTAssertEqual(data, givenString)
    }

    func testSS_whenMapToAny_isGivenStringList() throws {
        // Given
        let givenListString: Set<String> = ["String1", "String2", "String3", "String4"]
        let attributeValue = DynamoDB.AttributeValue.ss(Array(givenListString))

        // When
        let anyData = attributeValue.value

        // Then
        let data = try XCTUnwrap(anyData as? Set<String>)
        XCTAssertEqual(data, givenListString)
    }

}
