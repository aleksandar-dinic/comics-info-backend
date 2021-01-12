//
//  CharacterRepositoryAPIWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 22/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class CharacterRepositoryAPIWrapperTests: XCTestCase, CreateCharacterProtocol {

    private var sut: CharacterRepositoryAPIWrapper!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        sut = CharacterRepositoryAPIWrapperMock.make(tables: [:])
        table = String.tableName(for: "TEST")
    }

    override func tearDownWithError() throws {
        sut = nil
        table = nil
    }

    func test_whenGetMetadata_isEqualToGivenMetadata() throws {
        // Given
        let givenCharacter = CharacterMock.makeCharacter()
        try createCharacter(givenCharacter)

        // When
        let feature = sut.getMetadata(id: givenCharacter.id, from: table)
        let character = try feature.wait()

        // Then
        XCTAssertEqual(character.id, givenCharacter.id)
    }

    func test_whenGetMetadataNotExisting_throwsItemNotFound() throws {
        // Given
        let givenCharacter = CharacterMock.makeCharacter()
        var thrownError: Error?

        // When
        let feature = sut.getMetadata(id: givenCharacter.id, from: table)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemNotFound(let itemID, let itemType) = error as? APIError {
            XCTAssertEqual(itemID, "character#\(givenCharacter.id)")
            XCTAssertTrue(itemType == Character.self)
        } else {
            XCTFail("Expected '.itemNotFound' but got \(error)")
        }
    }

}
