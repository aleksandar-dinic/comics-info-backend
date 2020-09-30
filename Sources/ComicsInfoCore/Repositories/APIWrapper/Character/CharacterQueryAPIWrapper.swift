//
//  CharacterQueryAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 30/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct CharacterQueryAPIWrapper {

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
            .flatMapThrowing { try handleQuery($0) }
    }

    private func getDatabase(_ itemID: String) -> String {
        "\(String.characterType)#\(itemID)"
    }

    private func handleQuery(_ items: [[String: Any]]?) throws -> Character {
        guard let items = items else { throw APIError.itemNotFound }

        var characterDatabase: CharacterDatabase?
        var seriesSummary = [SeriesSummary]()

        for item in items {
            if characterDatabase == nil {
                characterDatabase = try? decoderService.decode(from: item)
            }

            if let series: SeriesSummary = try? decoderService.decode(from: item) {
                seriesSummary.append(series)
            }
        }

        guard var character = characterDatabase else {
            throw APIError.itemNotFound
        }
        character.seriesSummary = !seriesSummary.isEmpty ? seriesSummary : nil

        return Character(from: character)
    }

}
