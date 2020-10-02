//
//  CharacterGetItemAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 30/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct CharacterGetItemAPIWrapper {

    private let repositoryAPIService: RepositoryAPIService
    private let decoderService: DecoderService

    init(
        repositoryAPIService: RepositoryAPIService,
        decoderService: DecoderService
    ) {
        self.repositoryAPIService = repositoryAPIService
        self.decoderService = decoderService
    }

    func getItem(withID itemID: String) -> EventLoopFuture<Character> {
        repositoryAPIService.getItem(withID: getDatabase(itemID))
            .flatMapThrowing { try handleQuery($0, id: itemID) }
            .flatMapErrorThrowing { throw handleError($0) }
    }

    private func getDatabase(_ itemID: String) -> String {
        "\(String.characterType)#\(itemID)"
    }

    private func handleQuery(_ items: [DatabaseItem], id: String) throws -> Character {
        var characterDatabase: CharacterDatabase?

        for item in items {
            guard characterDatabase == nil else { break }
            characterDatabase = try? decoderService.decode(from: item)
        }

        guard var character = characterDatabase else {
            throw APIError.itemNotFound(withID: id, itemType: Character.self)
        }

        var series = [SeriesSummary]()
        for item in items {
            guard let seriesSummary: SeriesSummary = try? decoderService.decode(from: item) else { continue }
            series.append(seriesSummary)
        }

        character.seriesSummary = !series.isEmpty ? series : nil

        return Character(from: character)
    }

    private func handleError(_ error: Error) -> Error {
        guard let databaseError = error as? DatabaseError else { return error }

        switch databaseError {
        case .itemDoesNotHaveID:
            return APIError.requestError

        case let .itemAlreadyExists(withID: id):
            return APIError.itemAlreadyExists(withID: id, itemType: Character.self)

        case let .itemNotFound(withID: id):
            return APIError.itemNotFound(withID: id, itemType: Character.self)

        case let .itemsNotFound(withIDs: ids):
            return APIError.itemsNotFound(withIDs: ids, itemType: Character.self)
        }
    }

}
