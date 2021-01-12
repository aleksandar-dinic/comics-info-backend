//
//  CreateCharacterProtocol.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation

protocol CreateCharacterProtocol {

    func createCharacter(_ character: Character, in table: String) throws

}

extension CreateCharacterProtocol {

    func createCharacter(_ character: Character, in table: String = String.tableName(for: "TEST")) throws {
        let useCase = CharacterCreateUseCaseFactoryMock().makeUseCase()
        let feature = useCase.create(character, in: table)
        try feature.wait()
    }

}
