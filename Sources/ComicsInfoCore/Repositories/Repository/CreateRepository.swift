//
//  CreateRepository.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 08/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public final class CreateRepository<APIWrapper: CreateRepositoryAPIWrapper> {

    private let dataProvider: CreateDataProvider<APIWrapper>

    init(dataProvider: CreateDataProvider<APIWrapper>) {
        self.dataProvider = dataProvider
    }

    public func create(_ item: APIWrapper.Item, in table: String) -> EventLoopFuture<Void> {
        dataProvider.create(item, in: table)
    }

}
