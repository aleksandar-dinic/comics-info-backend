//
//  CharacterUpdateAPIWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class CharacterUpdateAPIWrapperTests: XCTestCase, CreateCharacterProtocol, CreateSeriesProtocol, CreateComicProtocol {

    private var sut: CharacterUpdateAPIWrapper!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        sut = CharacterUpdateAPIWrapperMock.make(items: [:])
        table = String.tableName(for: "TEST")
    }

    override func tearDownWithError() throws {
        sut = nil
        table = nil
    }

    // MARK: - Update

    func test_whenUpdateCharacter_characterIsUpdated() throws {
        // Given
        try createCharacter(CharacterMock.makeCharacter(name: "Old Name"))

        // When
        let feature = sut.update(CharacterMock.makeCharacter(), in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }

}
