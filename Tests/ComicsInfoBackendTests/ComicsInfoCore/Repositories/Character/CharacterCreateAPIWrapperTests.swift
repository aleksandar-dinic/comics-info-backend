//
//  CharacterCreateAPIWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 20/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class CharacterCreateAPIWrapperTests: XCTestCase, CreateSeriesProtocol, CreateComicProtocol {

    private var sut: CharacterCreateAPIWrapper!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        sut = CharacterCreateAPIWrapperMock.make()
        table = String.tableName(for: "TEST")
    }

    override func tearDownWithError() throws {
        sut = nil
        table = nil
    }

    // MARK: - Create

    func test_whenCrateCharacter_characterIsCreated() throws {
        // Given

        // When
        let feature = sut.create(CharacterMock.makeCharacter(), in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }

    func test_whenCrateTheSameCharacterTwice_throwsItemAlreadyExists() throws {
        // Given
        var feature = sut.create(CharacterMock.makeCharacter(), in: table)
        try feature.wait()
        var thrownError: Error?

        // When
        feature = sut.create(CharacterMock.makeCharacter(), in: table)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemAlreadyExists(let id, let itemType) = error as? APIError {
            XCTAssertEqual(id, "1")
            XCTAssertTrue(itemType == Character.self)
        } else {
            XCTFail("Expected '.itemAlreadyExists' but got \(error)")
        }
    }

}
