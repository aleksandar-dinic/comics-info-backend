//
//  ErrorResponseWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 09/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public protocol ErrorResponseWrapper {

    func `catch`(_ error: Error, statusCode: HTTPResponseStatus) -> Response

}

extension ErrorResponseWrapper {

    public func `catch`(_ error: Error, statusCode: HTTPResponseStatus = .notFound) -> Response {
        guard let comicInfoError = error as? ComicInfoError else {
            return Response(with: ResponseStatus(error.localizedDescription), statusCode: statusCode)
        }
        
        switch comicInfoError {
        case .invalidFields:
            return Response(with: ResponseStatus(error.localizedDescription), statusCode: .forbidden)
        default:
            return Response(with: ResponseStatus(error.localizedDescription), statusCode: statusCode)
        }
    }

}
