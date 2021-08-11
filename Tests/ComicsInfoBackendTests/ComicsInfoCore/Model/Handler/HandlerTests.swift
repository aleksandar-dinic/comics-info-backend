//
//  HandlerTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 11/08/2021.
//

@testable import ComicsInfoCore
import XCTest

final class HandlerTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
    
    // Unknow
    
    func testUnknowCreate_whenInitHandler_isNil() throws {
        // Given
        let handlerString = "unknow.create"
        
        // When
        let handler = Handler(for: handlerString)
        
        // Then
        XCTAssertNil(handler)
    }
    
    func testCharacterUnknow_whenInitHandler_isNil() throws {
        // Given
        let handlerString = "character.unknow"
        
        // When
        let handler = Handler(for: handlerString)
        
        // Then
        XCTAssertNil(handler)
    }
    
    // Character

    func testCharacterCreate_whenInitHandler_isEqualToCharacterCreate() throws {
        // Given
        let handlerString = "character.create"
        
        // When
        let handler = Handler(for: handlerString)
        
        // Then
        XCTAssertEqual(handler, Handler.character(operation: .create))
    }
    
    func testCharacterRead_whenInitHandler_isEqualToCharacterRead() throws {
        // Given
        let handlerString = "character.read"
        
        // When
        let handler = Handler(for: handlerString)
        
        // Then
        XCTAssertEqual(handler, Handler.character(operation: .read))
    }
    
    func testCharacterList_whenInitHandler_isEqualToCharacterList() throws {
        // Given
        let handlerString = "character.list"
        
        // When
        let handler = Handler(for: handlerString)
        
        // Then
        XCTAssertEqual(handler, Handler.character(operation: .list))
    }
    
    func testCharacterUpdate_whenInitHandler_isEqualToCharacterUpdate() throws {
        // Given
        let handlerString = "character.update"
        
        // When
        let handler = Handler(for: handlerString)
        
        // Then
        XCTAssertEqual(handler, Handler.character(operation: .update))
    }

    func testCharacterDelete_whenInitHandler_isEqualToCharacterDelete() throws {
        // Given
        let handlerString = "character.delete"
        
        // When
        let handler = Handler(for: handlerString)
        
        // Then
        XCTAssertEqual(handler, Handler.character(operation: .delete))
    }
    
    // Series

    func testSeriesCreate_whenInitHandler_isEqualToSeriesCreate() throws {
        // Given
        let handlerString = "series.create"
        
        // When
        let handler = Handler(for: handlerString)
        
        // Then
        XCTAssertEqual(handler, Handler.series(operation: .create))
    }
    
    func testSeriesRead_whenInitHandler_isEqualToSeriesRead() throws {
        // Given
        let handlerString = "series.read"
        
        // When
        let handler = Handler(for: handlerString)
        
        // Then
        XCTAssertEqual(handler, Handler.series(operation: .read))
    }
    
    func testSeriesList_whenInitHandler_isEqualToSeriesList() throws {
        // Given
        let handlerString = "series.list"
        
        // When
        let handler = Handler(for: handlerString)
        
        // Then
        XCTAssertEqual(handler, Handler.series(operation: .list))
    }
    
    func testSeriesUpdate_whenInitHandler_isEqualToSeriesUpdate() throws {
        // Given
        let handlerString = "series.update"
        
        // When
        let handler = Handler(for: handlerString)
        
        // Then
        XCTAssertEqual(handler, Handler.series(operation: .update))
    }

    func testSeriesDelete_whenInitHandler_isEqualToSeriesDelete() throws {
        // Given
        let handlerString = "series.delete"
        
        // When
        let handler = Handler(for: handlerString)
        
        // Then
        XCTAssertEqual(handler, Handler.series(operation: .delete))
    }
    
    // Comic

    func testComicCreate_whenInitHandler_isEqualToComicCreate() throws {
        // Given
        let handlerString = "comic.create"
        
        // When
        let handler = Handler(for: handlerString)
        
        // Then
        XCTAssertEqual(handler, Handler.comic(operation: .create))
    }
    
    func testComicRead_whenInitHandler_isEqualToComicRead() throws {
        // Given
        let handlerString = "comic.read"
        
        // When
        let handler = Handler(for: handlerString)
        
        // Then
        XCTAssertEqual(handler, Handler.comic(operation: .read))
    }
    
    func testComicList_whenInitHandler_isEqualToComicList() throws {
        // Given
        let handlerString = "comic.list"
        
        // When
        let handler = Handler(for: handlerString)
        
        // Then
        XCTAssertEqual(handler, Handler.comic(operation: .list))
    }
    
    func testComicUpdate_whenInitHandler_isEqualToComicUpdate() throws {
        // Given
        let handlerString = "comic.update"
        
        // When
        let handler = Handler(for: handlerString)
        
        // Then
        XCTAssertEqual(handler, Handler.comic(operation: .update))
    }

    func testComicDelete_whenInitHandler_isEqualToComicDelete() throws {
        // Given
        let handlerString = "comic.delete"
        
        // When
        let handler = Handler(for: handlerString)
        
        // Then
        XCTAssertEqual(handler, Handler.comic(operation: .delete))
    }

    
}
