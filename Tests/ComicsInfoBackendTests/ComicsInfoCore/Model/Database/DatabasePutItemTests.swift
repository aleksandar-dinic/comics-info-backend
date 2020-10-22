//
//  DatabasePutItemTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 15/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import SotoDynamoDB
import XCTest

final class DatabasePutItemTests: XCTestCase {

    private var sut: DatabasePutItem!

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testTableName_isEqualToGivenTableName() {
        // Given
        let givenTablename = "character"

        // When
        sut = DatabasePutItem(table: givenTablename)

        // Then
        XCTAssertEqual(sut.table, givenTablename)
    }

    func testDefaultAttributes_isEmptyTrue() {
        // Given

        // When
        sut = DatabasePutItem(table: "")

        // Then
        XCTAssertTrue(sut.attributes.isEmpty)
    }

    func testAttributes_isEqualToGivenAttributes() {
        // Given
        let givenAttributes: [String: Any] = ["Name": "Name", "Popularity": 0]

        // When
        sut = DatabasePutItem(givenAttributes, table: "")

        // Then
        XCTAssertEqual(sut.attributes.count, givenAttributes.count)
    }

    func testDefaultConditionExpression() {
        // Given
        let defaultConditionExpression = "attribute_not_exists(itemID) AND attribute_not_exists(summaryID)"

        // When
        sut = DatabasePutItem(table: "")

        // Then
        XCTAssertEqual(sut.conditionExpression, defaultConditionExpression)
    }

    func testConditionExpression_isEqualToGivenConditionExpression() {
        // Given
        let givenConditionExpression = "Given Condition Expression"

        // When
        sut = DatabasePutItem(table: "", conditionExpression: givenConditionExpression)

        // Then
        XCTAssertEqual(sut.conditionExpression, givenConditionExpression)
    }

    func testAttributeValues_isEqualToGivenAttributes() {
        // Given
        let givenAttributes: [String: Any] = ["Name": "Name", "Popularity": 0]

        // When
        sut = DatabasePutItem(givenAttributes, table: "")

        // Then
        XCTAssertEqual(sut.attributeValues, ["Popularity": DynamoDB.AttributeValue.n("0"),
                                             "Name": DynamoDB.AttributeValue.s("Name")])
    }

}
