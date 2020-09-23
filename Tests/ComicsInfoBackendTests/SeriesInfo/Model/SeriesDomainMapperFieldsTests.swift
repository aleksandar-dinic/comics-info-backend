//
//  SeriesDomainMapperFieldsTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import struct SeriesInfo.Series
@testable import struct Domain.Series
import XCTest

final class SeriesDomainMapperFieldsTests: XCTestCase {

    private var series: SeriesInfo.Series!
    private var identifier: String!
    private var popularity: Int!
    private var title: String!
    private var seriesDescription: String!
    private var startYear: Int!
    private var endYear: Int!
    private var thumbnail: String!
    private var charactersID: Set<String>!
    private var nextIdentifier: String!
    private var sut: Domain.Series!

    override func setUpWithError() throws {
        identifier = "1"
        popularity = 0
        title = "Title"
        thumbnail = "thumbnail"
        seriesDescription = "description"
        startYear = 1
        endYear = 2
        charactersID = ["1"]
        nextIdentifier = "2"
        series = SeriesInfo.Series(
            identifier: identifier,
            popularity: popularity,
            title: title,
            description: seriesDescription,
            startYear: startYear,
            endYear: endYear,
            thumbnail: thumbnail,
            charactersID: charactersID,
            nextIdentifier: nextIdentifier
        )
        sut = Domain.Series(from: series)
    }

    override func tearDownWithError() throws {
        identifier = nil
        popularity = nil
        title = nil
        thumbnail = nil
        seriesDescription = nil
        startYear = nil
        endYear = nil
        charactersID = nil
        nextIdentifier = nil
        series = nil
        sut = nil
    }

    func testSereisIdentifier_whenInitFromSereis_isEqualToSereisIdentifier() {
        XCTAssertEqual(sut.identifier, identifier)
    }

    func testSereisPopularity_whenInitFromSereis_isEqualToSereisPopularity() {
        XCTAssertEqual(sut.popularity, popularity)
    }

    func testSereisTitle_whenInitFromSereis_isEqualToSereisName() {
        XCTAssertEqual(sut.title, title)
    }

    func testSereisThumbnail_whenInitFromSereis_isEqualToSereisThumbnail() {
        XCTAssertEqual(sut.thumbnail, thumbnail)
    }

    func testSereisDescription_whenInitFromSereis_isEqualToSereisDescription() {
        XCTAssertEqual(sut.description, seriesDescription)
    }

    func testSereisStartYear_whenInitFromSereis_isEqualToStartYear() {
        XCTAssertEqual(sut.startYear, startYear)
    }

    func testSereisEndYear_whenInitFromSereis_isEqualToEndYear() {
        XCTAssertEqual(sut.endYear, endYear)
    }

    func testSereisCharactersID_whenInitFromSereis_isEqualToCharactersID() {
        XCTAssertEqual(sut.charactersID, charactersID)
    }

    func testSereisNextIdentifier_whenInitFromSereis_isEqualToNextIdentifier() {
        XCTAssertEqual(sut.nextIdentifier, nextIdentifier)
    }

}
