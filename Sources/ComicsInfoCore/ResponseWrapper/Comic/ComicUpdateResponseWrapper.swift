//
//  ComicUpdateResponseWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Comic
import Foundation
import NIO

public struct ComicUpdateResponseWrapper: UpdateResponseWrapper {

    private let comicUseCase: ComicUpdateUseCase

    public init(comicUseCase: ComicUpdateUseCase) {
        self.comicUseCase = comicUseCase
    }

    public func handleUpdate(
        on eventLoop: EventLoop,
        request: Request,
        environment: String?
    ) -> EventLoopFuture<Response> {
        guard let data = request.body?.data(using: .utf8) else {
            let response = Response(statusCode: .badRequest)
            return eventLoop.submit { response }
        }

        let table = String.tableName(for: environment)
        do {
            let item = try JSONDecoder().decode(Domain.Comic.self, from: data)
            return comicUseCase.update(Comic(from: item), on: eventLoop, in: table)
                .map { Response(with: ResponseStatus("\(type(of: item.self)) updated"), statusCode: .ok) }
                .flatMapErrorThrowing { self.catch($0, statusCode: .forbidden) }

        } catch {
            let response = Response(with: ResponseStatus(error.localizedDescription), statusCode: .badRequest)
            return eventLoop.submit { response }
        }
    }

}
