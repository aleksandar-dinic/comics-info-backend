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

    func createCharacter(_ character: Character) throws

}

extension CreateCharacterProtocol {

    func createCharacter(_ character: Character) throws {
        let useCase = CharacterUseCaseFactoryMock().makeUseCase()
        let feature = useCase.create(character)
        try feature.wait()
    }

}
