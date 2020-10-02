//
//  CharacterUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 04/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public final class CharacterUseCase<APIWrapper: RepositoryAPIWrapper, CacheService: Cacheable>: UseCase where APIWrapper.Item == Character, CacheService.Item == Character {

    private let characterRepository: Repository<APIWrapper, CacheService>

    init(characterRepository: Repository<APIWrapper, CacheService>) {
        self.characterRepository = characterRepository
    }

    public func create(_ character: Character) -> EventLoopFuture<Void> {
        characterRepository.create(character)
    }

    public func getItem(
        withID itemID: String,
        fromDataSource dataSource: DataSourceLayer
    ) -> EventLoopFuture<Character> {
        characterRepository.getItem(
            withID: itemID,
            fromDataSource: dataSource
        )
    }

    public func getAllItems(
        fromDataSource dataSource: DataSourceLayer
    ) -> EventLoopFuture<[Character]> {
        characterRepository.getAllItems(fromDataSource: dataSource)
    }

    public func getMetadata(
        withID characterID: String,
        fromDataSource dataSource: DataSourceLayer
    ) -> EventLoopFuture<Character> {
        characterRepository.getMetadata(
            withID: characterID,
            fromDataSource: dataSource
        )
    }

    public func getAllMetadata(
        withIDs ids: Set<String>,
        fromDataSource dataSource: DataSourceLayer
    ) -> EventLoopFuture<[Character]> {
        characterRepository.getAllMetadata(
            withIDs: ids,
            fromDataSource: dataSource
        )
    }

}
