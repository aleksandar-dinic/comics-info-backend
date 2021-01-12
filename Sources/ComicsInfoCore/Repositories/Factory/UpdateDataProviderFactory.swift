//
//  UpdateDataProviderFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol UpdateDataProviderFactory {

    associatedtype APIWrapper: UpdateRepositoryAPIWrapper

    var repositoryAPIWrapper: APIWrapper { get }

    func makeDataProvider() -> UpdateDataProvider<APIWrapper>

}

extension UpdateDataProviderFactory {

    public func makeDataProvider() -> UpdateDataProvider<APIWrapper> {
        UpdateDataProvider(repositoryAPIWrapper: repositoryAPIWrapper)
    }

}
