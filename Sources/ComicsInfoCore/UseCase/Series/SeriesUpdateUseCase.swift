//
//  SeriesUpdateUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public final class SeriesUpdateUseCase<APIWrapper: UpdateRepositoryAPIWrapper>: UpdateUseCase where APIWrapper.Item == Series {

    public let repository: UpdateRepository<APIWrapper>

    public init(repository: UpdateRepository<APIWrapper>) {
        self.repository = repository
    }

}
