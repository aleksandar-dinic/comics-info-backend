//
//  DomainMyCharacter+MyCharacter.swift
//  
//
//  Created by Aleksandar Dinic on 1/29/22.
//

import struct Domain.MyCharacter
import struct Domain.SeriesSummary
import Foundation

extension Domain.MyCharacter {

    init(from myCharacter: MyCharacter) {
        self.init(
            identifier: myCharacter.characterID,
            popularity: myCharacter.popularity,
            name: myCharacter.name,
            thumbnail: myCharacter.thumbnail,
            description: myCharacter.description,
            realName: myCharacter.realName,
            aliases: myCharacter.aliases,
            birth: myCharacter.birth,
            mySeries: myCharacter.mySeries?.map { Domain.SeriesSummary(from: $0) }
        )
    }

}
