//
//  LoggerProvider.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 19/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation

public protocol LoggerProvider {

    func logRequest<T: Encodable>(_ logger: Logger, request: T)
    func logResponse<T: Encodable>(_ logger: Logger, response: Result<T, Error>)

}

public extension LoggerProvider {

    func logRequest<T: Encodable>(_ logger: Logger, request: T) {
        guard let data = try? JSONEncoder().encode(request) else { return }
        guard let message = String(data: data, encoding: .utf8) else { return }

        logger.log(level: .info, "\(message)")
    }

    func logResponse<T: Encodable>(_ logger: Logger, response: Result<T, Error>) {
        switch response {
        case let .success(response):
            guard let data = try? JSONEncoder().encode(response) else { return }
            guard let message = String(data: data, encoding: .utf8) else { return }

            logger.log(level: .info, "\(message)")

        case let .failure(error):
            logger.log(level: .error, "\(error)")
        }
    }

}
