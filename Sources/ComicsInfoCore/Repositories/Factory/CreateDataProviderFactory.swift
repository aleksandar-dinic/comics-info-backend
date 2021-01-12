//
//  CreateDataProviderFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 08/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol CreateDataProviderFactory {

    associatedtype APIWrapper: CreateRepositoryAPIWrapper

    var repositoryAPIWrapper: APIWrapper { get }

    func makeDataProvider() -> CreateDataProvider<APIWrapper>

}

extension CreateDataProviderFactory {

    public func makeDataProvider() -> CreateDataProvider<APIWrapper> {
        CreateDataProvider(repositoryAPIWrapper: repositoryAPIWrapper)
    }

}
