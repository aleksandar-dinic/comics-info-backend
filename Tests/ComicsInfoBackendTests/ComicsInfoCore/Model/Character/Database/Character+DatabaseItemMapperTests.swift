//
//  Character+DatabaseItemMapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 12/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class Character_DatabaseItemMapperTests: XCTestCase {

    private var characterDatabase: CharacterDatabase!
    private var sut: Character!

    override func setUpWithError() throws {
        characterDatabase = CharacterDatabase(
            itemID: "character#1",
            summaryID: "character#1",
            itemName: "character",
            popularity: 0,
            name: "Name",
            description: "Description",
            thumbnail: "Thumbnail",
            seriesSummary: [SeriesSummaryMock.seriesSummary],
            comicsSummary: [ComicSummaryMock.comicSummary]
        )
        sut = Character(from: characterDatabase)
    }

    override func tearDownWithError() throws {
        characterDatabase = nil
        sut = nil
    }

    func testID_whenInitFromCharacterDatabase_isEqualToCharacterDatabaseID() {
        XCTAssertEqual(sut.id, characterDatabase.id)
    }

    func testPopularity_whenInitFromCharacterDatabase_isEqualToCharacterDatabasePopularity() {
        XCTAssertEqual(sut.popularity, characterDatabase.popularity)
    }

    func testName_whenInitFromCharacterDatabase_isEqualToCharacterDatabaseName() {
        XCTAssertEqual(sut.name, characterDatabase.name)
    }

    func testThumbnail_whenInitFromCharacterDatabase_isEqualToCharacterDatabaseThumbnail() {
        XCTAssertEqual(sut.thumbnail, characterDatabase.thumbnail)
    }

    func testDescription_whenInitFromCharacterDatabase_isEqualToCharacterDatabaseDescription() {
        XCTAssertEqual(sut.description, characterDatabase.description)
    }

    func testSeries_whenInitFromCharacterDatabase_isEqualToCharacterDatabaseSeriesSummary() {
        XCTAssertEqual(sut.series?.compactMap { $0.id }, characterDatabase.seriesSummary?.compactMap { $0.id })
    }

    func testComics_whenInitFromCharacterDatabase_isEqualToCharacterDatabaseComicsSummary() {
        XCTAssertEqual(sut.comics?.compactMap { $0.id }, characterDatabase.comicsSummary?.compactMap { $0.id })
    }

}
