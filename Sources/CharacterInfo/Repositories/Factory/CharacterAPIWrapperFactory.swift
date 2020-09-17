//
//  CharacterAPIWrapperFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 01/09/2020.
//

import Foundation

protocol CharacterAPIWrapperFactory {

    var characterAPIService: CharacterAPIService { get }
    var characterDecoderService: CharacterDecoderService { get }

    func makeCharacterAPIWrapper() -> CharacterAPIWrapper

}

extension CharacterAPIWrapperFactory {

    public func makeCharacterAPIWrapper() -> CharacterAPIWrapper {
        CharacterAPIWrapper(
            characterAPIService: characterAPIService,
            characterDecoderService: characterDecoderService
        )
    }

}
