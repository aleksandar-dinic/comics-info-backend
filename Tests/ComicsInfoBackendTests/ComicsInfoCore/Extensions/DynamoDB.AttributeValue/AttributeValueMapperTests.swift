//
//  AttributeValueMapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import SotoDynamoDB
import XCTest

final class AttributeValueMapperTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testData_whenMapToAttributeValue_isEqualToGivenAttributeValue() {
        // Given
        let givenData = Data(buffer: ByteBuffer(string: "Data"))
        let givenAttributeValue = DynamoDB.AttributeValue.b(givenData)

        // When
        let attributeValue = givenData.attributeValue

        // Then
        XCTAssertEqual(attributeValue, givenAttributeValue)
    }

    func testBool_whenMapToAttributeValue_isEqualToGivenAttributeValue() {
        // Given
        let givenBool = true
        let givenAttributeValue = DynamoDB.AttributeValue.bool(givenBool)

        // When
        let attributeValue = givenBool.attributeValue

        // Then
        XCTAssertEqual(attributeValue, givenAttributeValue)
    }

    func testDataList_whenMapToAttributeValue_isEqualToGivenAttributeValue() {
        // Given
        let givenDataList = [
            Data(buffer: ByteBuffer(string: "Data1")),
            Data(buffer: ByteBuffer(string: "Data2"))
        ]
        let givenAttributeValue = DynamoDB.AttributeValue.bs(givenDataList)

        // When
        let attributeValue = givenDataList.attributeValue

        // Then
        XCTAssertEqual(attributeValue, givenAttributeValue)
    }

    func testInt_whenMapToAttributeValue_isEqualToGivenAttributeValue() {
        // Given
        let givenInt = 42
        let givenAttributeValue = DynamoDB.AttributeValue.n(String(givenInt))

        // When
        let attributeValue = givenInt.attributeValue

        // Then
        XCTAssertEqual(attributeValue, givenAttributeValue)
    }

    func testDouble_whenMapToAttributeValue_isEqualToGivenAttributeValue() {
        // Given
        let givenDouble = 42.42
        let givenAttributeValue = DynamoDB.AttributeValue.n(String(givenDouble))

        // When
        let attributeValue = givenDouble.attributeValue

        // Then
        XCTAssertEqual(attributeValue, givenAttributeValue)
    }

    func testIntList_whenMapToAttributeValue_isEqualToGivenAttributeValue() {
        // Given
        let givenIntList = [1, 2, 3, 4, 5]
        let givenAttributeValue = DynamoDB.AttributeValue.ns(givenIntList.map(String.init))

        // When
        let attributeValue = givenIntList.attributeValue

        // Then
        XCTAssertEqual(attributeValue, givenAttributeValue)
    }

    func testDoubleList_whenMapToAttributeValue_isEqualToGivenAttributeValue() {
        // Given
        let givenDoubleList = [1.1, 2.2, 3.3, 4.4, 5.5]
        let givenAttributeValue = DynamoDB.AttributeValue.ns(givenDoubleList.map { String($0) })

        // When
        let attributeValue = givenDoubleList.attributeValue

        // Then
        XCTAssertEqual(attributeValue, givenAttributeValue)
    }

    func testIntSet_whenMapToAttributeValue_isEqualToGivenAttributeValue() {
        // Given
        let givenIntSet: Set = [1]
        let givenAttributeValue = DynamoDB.AttributeValue.ns(givenIntSet.map(String.init))

        // When
        let attributeValue = givenIntSet.attributeValue

        // Then
        XCTAssertEqual(attributeValue, givenAttributeValue)
    }

    func testDoubleSet_whenMapToAttributeValue_isEqualToGivenAttributeValue() {
        // Given
        let givenDoubleSet: Set = [1.1]
        let givenAttributeValue = DynamoDB.AttributeValue.ns(givenDoubleSet.map { String($0) })

        // When
        let attributeValue = givenDoubleSet.attributeValue

        // Then
        XCTAssertEqual(attributeValue, givenAttributeValue)
    }

    func testIsNull_whenMapToAttributeValue_isEqualToGivenAttributeValue() {
        // Given
        let givenNil: Int? = nil
        let givenAttributeValue = DynamoDB.AttributeValue.null(true)

        // When
        let attributeValue = givenNil.attributeValue

        // Then
        XCTAssertEqual(attributeValue, givenAttributeValue)
    }

    func testString_whenMapToAttributeValue_isEqualToGivenAttributeValue() {
        // Given
        let givenString = "String"
        let givenAttributeValue = DynamoDB.AttributeValue.s(givenString)

        // When
        let attributeValue = givenString.attributeValue

        // Then
        XCTAssertEqual(attributeValue, givenAttributeValue)
    }

    func testListString_whenMapToAttributeValue_isEqualToGivenAttributeValue() {
        // Given
        let givenListString = ["String1", "String2", "String3", "String4"]
        let givenAttributeValue = DynamoDB.AttributeValue.ss(givenListString)

        // When
        let attributeValue = givenListString.attributeValue

        // Then
        XCTAssertEqual(attributeValue, givenAttributeValue)
    }

    func testListBool_whenMapToAttributeValue_isEqualToGivenAttributeValue() {
        // Given
        let givenListBool = [true, true, false, true]
        let givenAttributeValue = DynamoDB.AttributeValue.l([
            DynamoDB.AttributeValue.bool(true),
            DynamoDB.AttributeValue.bool(true),
            DynamoDB.AttributeValue.bool(false),
            DynamoDB.AttributeValue.bool(true)
        ])

        // When
        let attributeValue = givenListBool.attributeValue

        // Then
        XCTAssertEqual(attributeValue, givenAttributeValue)
    }

    func testDict_whenMapToAttributeValue_isEqualToGivenAttributeValue() {
        // Given
        let givenDict = ["Key1": "Value1", "Key2": "Value2"]
        let givenAttributeValue = DynamoDB.AttributeValue.m([
            "Key1": DynamoDB.AttributeValue.s("Value1"),
            "Key2": DynamoDB.AttributeValue.s("Value2")
        ])

        // When
        let attributeValue = givenDict.attributeValue

        // Then
        XCTAssertEqual(attributeValue, givenAttributeValue)
    }

}
