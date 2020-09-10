//
//  CharacterAPIServiceMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 02/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import NIO

final class CharacterAPIServiceMock: CharacterAPIService {

    private let items: [[String: Any]]?

    init(_ items: [[String: Any]]? = nil) {
        self.items = items
    }

    func getAllCharacters(on eventLoop: EventLoop) -> EventLoopFuture<[[String: Any]]?> {
        let promise = eventLoop.makePromise(of: [[String: Any]]?.self)

        eventLoop.execute { [weak self] in
            guard let items = self?.items else {
                return promise.fail(APIError.charactersNotFound)
            }

            promise.succeed(items)
        }

        return promise.futureResult
    }

    func getCharacter(withID characterID: String, on eventLoop: EventLoop) -> EventLoopFuture<[String: Any]?> {
        let promise = eventLoop.makePromise(of: [String: Any]?.self)

        eventLoop.execute { [weak self] in
            guard let item = self?.items?.first(where: { $0[.identifier] as? String == characterID }) else {
                return promise.fail(APIError.characterNotFound)
            }
            promise.succeed(item)
        }

        return promise.futureResult
    }

}
