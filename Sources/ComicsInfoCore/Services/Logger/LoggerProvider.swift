//
//  LoggerProvider.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 19/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import SotoCore

public protocol LoggerProvider {

    func log<T: Loggable>(_ logger: Logger, loggable: T) -> T
    func logRequest<T: Encodable>(_ logger: Logger, request: T)
    func logResponse<T: Encodable>(_ logger: Logger, response: Result<T, Error>)
    func logError(_ logger: Logger?, error: Error)

}

public extension LoggerProvider {
    
    @discardableResult
    func log<T: Loggable>(_ logger: Logger, loggable: T) -> T {
        let logs = loggable.getLogs()
        for log in logs {
            logger.log(level: log.level, log.message, metadata: log.metadata, source: log.source)
        }
        return loggable
    }

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
    
    func logError(_ logger: Logger?, error: Error) {
        if let error = error as? AWSClientError {
            logger?.error("\(error.description)")
            
        } else if let error = error as? ComicInfoError {
            logger?.error("\(error.errorDescription ?? "Unknow error with type: \(type(of: error))")")
        
        } else {
            logger?.error("\(error.localizedDescription)")
        }
    }

}
