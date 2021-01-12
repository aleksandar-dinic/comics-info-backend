//
//  ComicUpdateResponseWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public struct ComicUpdateResponseWrapper<APIWrapper: UpdateRepositoryAPIWrapper>: UpdateResponseWrapper where APIWrapper.Item == Comic {

    private let comicUseCase: ComicUpdateUseCase<APIWrapper>

    public init(comicUseCase: ComicUpdateUseCase<APIWrapper>) {
        self.comicUseCase = comicUseCase
    }

    public func handleUpdate(
        on eventLoop: EventLoop,
        request: Request,
        environment: String?
    ) -> EventLoopFuture<Response> {
        guard let data = request.body?.data(using: .utf8) else {
            let response = Response(statusCode: .badRequest)
            return eventLoop.makeSucceededFuture(response)
        }

        let table = String.tableName(for: environment)
        do {
            let item = try JSONDecoder().decode(Comic.self, from: data)
            return comicUseCase.update(item, in: table)
                .map { Response(with: ResponseStatus("\(type(of: item.self)) updated"), statusCode: .ok) }
                .flatMapError { self.catch($0, on: eventLoop, statusCode: .forbidden) }

        } catch {
            let response = Response(with: ResponseStatus(error.localizedDescription), statusCode: .badRequest)
            return eventLoop.makeSucceededFuture(response)
        }
    }

}
