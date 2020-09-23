//
//  CharacterAPIServiceMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 02/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import CharacterInfo
import Foundation
import NIO

final class CharacterAPIServiceMock: CharacterAPIService {

    private let eventLoop: EventLoop
    private var items: [[String: Any]]?

    init(
        on eventLoop: EventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next(),
        items: [[String: Any]]? = nil
    ) {
        self.eventLoop = eventLoop
        self.items = items
    }

    func create(_ character: Character) -> EventLoopFuture<Void> {
        let promise = eventLoop.makePromise(of: Void.self)

        eventLoop.execute { [weak self] in
            let mirror = Mirror(reflecting: character)
            var item = [String: Any]()

            for child in mirror.children {
                guard let label = child.label else { continue }

                if case Optional<Any>.none = child.value { continue }
                item[label] = child.value
            }

            self?.items?.append(item)
            promise.succeed(())
        }

        return promise.futureResult
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
