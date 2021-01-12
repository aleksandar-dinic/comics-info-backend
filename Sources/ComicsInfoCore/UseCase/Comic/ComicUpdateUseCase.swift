//
//  ComicUpdateUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

public final class ComicUpdateUseCase<APIWrapper: UpdateRepositoryAPIWrapper>: UpdateUseCase where APIWrapper.Item == Comic {

    public let repository: UpdateRepository<APIWrapper>

    public init(repository: UpdateRepository<APIWrapper>) {
        self.repository = repository
    }

}
