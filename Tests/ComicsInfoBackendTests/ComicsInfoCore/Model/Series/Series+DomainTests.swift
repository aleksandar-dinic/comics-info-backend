//
//  Series+DomainTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 15/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import struct ComicsInfoCore.Series
@testable import struct Domain.Series
import XCTest

final class Series_DomainTests: XCTestCase {

    private var givenSeries: ComicsInfoCore.Series!
    private var sut: Domain.Series!

    override func setUpWithError() throws {
        givenSeries = SeriesMock.series
        sut = Domain.Series(from: givenSeries)
    }

    override func tearDownWithError() throws {
        givenSeries = nil
        sut = nil
    }

    func testIdentifier_whenInitFromSeries_isEqualToSeriesID() {
        XCTAssertEqual(sut.identifier, givenSeries.id)
    }

    func testPopularity_whenInitFromCharacter_isEqualToCharacterPopularity() {
        XCTAssertEqual(sut.popularity, givenSeries.popularity)
    }

    func testTitle_whenInitFromSeries_isEqualToSeriesName() {
        XCTAssertEqual(sut.title, givenSeries.title)
    }

    func testThumbnail_whenInitFromSeries_isEqualToSeriesThumbnail() {
        XCTAssertEqual(sut.thumbnail, givenSeries.thumbnail)
    }

    func testDescription_whenInitFromSeries_isEqualToSeriesDescription() {
        XCTAssertEqual(sut.description, givenSeries.description)
    }

    func testStartYear_whenInitFromSeries_isEqualToSeriesStartYear() {
        XCTAssertEqual(sut.startYear, givenSeries.startYear)
    }

    func testEndYear_whenInitFromSeries_isEqualToSeriesEndYear() {
        XCTAssertEqual(sut.endYear, givenSeries.endYear)
    }
    
    func testAliases_whenInitFromSeries_isEqualToSeriesAliases() {
        XCTAssertEqual(sut.aliases, givenSeries.aliases)
    }

    func testNextIdentifier_whenInitFromSeries_isEqualToSeriesNextIdentifier() {
        XCTAssertEqual(sut.nextIdentifier, givenSeries.nextIdentifier)
    }

    func testCharacters_whenInitFromSeries_isEqualToSeriesCharacters() {
        XCTAssertEqual(
            sut.characters?.compactMap { $0.identifier },
            givenSeries.characters?.compactMap { $0.id }.sorted(by: >)
        )
    }

    func testComics_whenInitFromSeries_isEqualToSeriesComics() {
        XCTAssertEqual(
            sut.comics?.compactMap { $0.identifier },
            givenSeries.comics?.compactMap { $0.id }.sorted(by: >)
        )
    }

}
