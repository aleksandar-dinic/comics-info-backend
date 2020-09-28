//
//  RepositoryAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public protocol RepositoryAPIWrapper {

    associatedtype Item: Codable & DatabaseDecodable

    var repositoryAPIService: RepositoryAPIService { get }
    var decoderService: DecoderService { get }
    var encoderService: EncoderService { get }

    init(
        repositoryAPIService: RepositoryAPIService,
        decoderService: DecoderService,
        encoderService: EncoderService
    )

    func create(_ item: Item) -> EventLoopFuture<Void>
    func getAll(on eventLoop: EventLoop) -> EventLoopFuture<[Item]>
    func get(
        withID identifier: Item.ID,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<Item>

}
