//
//  CreateCharacterProtocol.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import NIO

protocol CreateCharacterProtocol {

    func createCharacter(_ character: Character, on eventLoop: EventLoop, in table: String) throws -> Character

}

extension CreateCharacterProtocol {

    @discardableResult
    func createCharacter(
        _ character: Character,
        on eventLoop: EventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next(),
        in table: String = String.tableName(for: "TEST")
    ) throws -> Character {
        let useCase = CharacterCreateUseCaseFactoryMock().makeUseCase()
        let criteria = CreateItemCriteria(item: character, on: eventLoop, in: table)
        let feature = useCase.create(with: criteria)
        return try feature.wait()
    }

}
