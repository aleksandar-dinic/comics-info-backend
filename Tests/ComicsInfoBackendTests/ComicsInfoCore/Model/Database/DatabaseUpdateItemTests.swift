//
//  DatabaseUpdateItemTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 15/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import SotoDynamoDB
import XCTest

final class DatabaseUpdateItemTests: XCTestCase {

    private var sut: DatabaseUpdateItem!
    private var itemID: String!
    private var summaryID: String!
    private var givenTablename: String!

    override func setUpWithError() throws {
        itemID = ""
        summaryID = ""
        givenTablename = ""
    }

    override func tearDownWithError() throws {
        sut = nil
        itemID = nil
        summaryID = nil
        givenTablename = nil
    }

    func testTableName_isEqualToGivenTableName() {
        // Given
        givenTablename = "character"

        // When
        sut = DatabaseUpdateItem(table: givenTablename, itemID: itemID, summaryID: summaryID)

        // Then
        XCTAssertEqual(sut.table, givenTablename)
    }

    func testItemID_isEqualToGivenItemID() {
        // Given
        itemID = "Given Item ID"

        // When
        sut = DatabaseUpdateItem(table: givenTablename, itemID: itemID, summaryID: summaryID)

        // Then
        XCTAssertEqual(sut.table, givenTablename)
    }

    func testSummaryID_isEqualToGivenSummaryID() {
        // Given
        summaryID = "Given Summary ID"

        // When
        sut = DatabaseUpdateItem(table: givenTablename, itemID: itemID, summaryID: summaryID)

        // Then
        XCTAssertEqual(sut.table, givenTablename)
    }

    func testDefaultAttributes_isEmptyTrue() {
        // Given

        // When
        sut = DatabaseUpdateItem(table: givenTablename, itemID: itemID, summaryID: summaryID)

        // Then
        XCTAssertTrue(sut.attributes.isEmpty)
    }

    func testAttributes_isEqualToGivenAttributes() {
        // Given
        let givenAttributes: [String: Any] = ["Name": "Name", "Popularity": 0]

        // When
        sut = DatabaseUpdateItem(givenAttributes, table: givenTablename, itemID: itemID, summaryID: summaryID)

        // Then
        XCTAssertEqual(sut.attributes.count, givenAttributes.count)
    }

    func testDefaultConditionExpression() {
        // Given
        let defaultConditionExpression = "attribute_exists(itemID) AND attribute_exists(summaryID)"

        // When
        sut = DatabaseUpdateItem(table: givenTablename, itemID: itemID, summaryID: summaryID)

        // Then
        XCTAssertEqual(sut.conditionExpression, defaultConditionExpression)
    }

    func testConditionExpression_isEqualToGivenConditionExpression() {
        // Given
        let givenConditionExpression = "Given Condition Expression"

        // When
        sut = DatabaseUpdateItem(
            table: givenTablename,
            itemID: itemID,
            summaryID: summaryID,
            conditionExpression: givenConditionExpression
        )

        // Then
        XCTAssertEqual(sut.conditionExpression, givenConditionExpression)
    }

    func testAttributeValues_isEqualToGivenAttributes() {
        // Given
        let givenAttributes: [String: Any] = ["Name": "Name", "Popularity": 0]

        // When
        sut = DatabaseUpdateItem(givenAttributes, table: givenTablename, itemID: itemID, summaryID: summaryID)

        // Then
        XCTAssertEqual(sut.attributeValues, [":Popularity": DynamoDB.AttributeValue.n("0"),
                                             ":Name": DynamoDB.AttributeValue.s("Name")])
    }

    func testKey_isEqualToGivenItemIDAndSummaryID() {
        // Given
        itemID = "Given Item ID"
        summaryID = "Given Summary ID"

        // When
        sut = DatabaseUpdateItem(table: givenTablename, itemID: itemID, summaryID: summaryID)

        // Then
        XCTAssertEqual(sut.key, ["itemID": DynamoDB.AttributeValue.s("Given Item ID"),
                                 "summaryID": DynamoDB.AttributeValue.s("Given Summary ID")])
    }

    func testAttributeNames_isEqualToGivenAttributeNames() {
        // Given
        let givenAttributes: [String: Any] = ["Name": "Name", "Popularity": 0]

        // When
        sut = DatabaseUpdateItem(givenAttributes, table: givenTablename, itemID: itemID, summaryID: summaryID)

        // Then
        XCTAssertEqual(sut.attributeNames, ["#Popularity": "Popularity", "#Name": "Name"])
    }

    func testUpdateExpression() {
        // Given
        let givenAttributes: [String: Any] = ["Name": "Name"]

        // When
        sut = DatabaseUpdateItem(givenAttributes, table: givenTablename, itemID: itemID, summaryID: summaryID)

        // Then
        XCTAssertEqual(sut.updateExpression, "SET #Name = :Name")
    }

}
