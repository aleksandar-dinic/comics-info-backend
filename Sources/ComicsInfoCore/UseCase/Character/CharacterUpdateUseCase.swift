//
//  CharacterUpdateUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

public final class CharacterUpdateUseCase<APIWrapper: UpdateRepositoryAPIWrapper>: UpdateUseCase where APIWrapper.Item == Character {

    public let repository: UpdateRepository<APIWrapper>

    public init(repository: UpdateRepository<APIWrapper>) {
        self.repository = repository
    }

}
