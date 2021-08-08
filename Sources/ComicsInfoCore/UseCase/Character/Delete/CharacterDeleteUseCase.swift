//
//  CharacterDeleteUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 29/04/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation
import NIO

public final class CharacterDeleteUseCase: DeleteUseCase {
    
    public typealias Item = Character
    
    public let deleteRepository: DeleteRepository
    let characterUseCase: CharacterUseCase

    public init(deleteRepository: DeleteRepository, characterUseCase: CharacterUseCase) {
        self.deleteRepository = deleteRepository
        self.characterUseCase = characterUseCase
    }
    
    public func getItem(
        withID ID: String,
        on eventLoop: EventLoop,
        from table: String,
        logger: Logger?
    ) -> EventLoopFuture<Item> {
        characterUseCase.getItem(
            on: eventLoop,
            withID: ID,
            fields: nil,
            from: table,
            logger: logger,
            dataSource: .database
        )
    }
    
}
