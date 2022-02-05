//
//  MyComicsResponseWrapper.swift
//  
//
//  Created by Aleksandar Dinic on 2/5/22.
//

import struct Domain.ComicSummary
import Foundation
import NIO

public struct MyComicsResponseWrapper: ErrorResponseWrapper {

    private let useCase: MyComicsUseCase

    public init(useCase: MyComicsUseCase) {
        self.useCase = useCase
    }

    public func handleCreate(
        on eventLoop: EventLoop,
        request: Request,
        environment: String?
    ) -> EventLoopFuture<Response> {
        do {
            let request = try CreateMyComicRequest(
                request: request,
                environment: environment,
                eventLoop: eventLoop
            )
            
            return useCase.createMyComic(with: request)
                .map { Response(with: Domain.ComicSummary(from: $0), statusCode: .created) }
                .flatMapErrorThrowing { self.catch($0, statusCode: .forbidden) }

        } catch {
            return eventLoop.submit { self.catch(error, statusCode: .badRequest) }
        }
    }
    
    public func handleGet(
        on eventLoop: EventLoop,
        request: Request,
        environment: String?
    ) -> EventLoopFuture<Response> {
        guard let comicID = try? request.getIDFromPathParameters() else {
            return handleList(
                on: eventLoop,
                request: request,
                environment: environment
            )
        }
        
        do {
            let request = try ReadMyComicRequest(
                comicID: comicID,
                request: request,
                environment: environment,
                eventLoop: eventLoop
            )

            return useCase.getMyComic(with: request)
                .map { Response(with: Domain.ComicSummary(from: $0), statusCode: .ok) }
                .flatMapErrorThrowing { self.catch($0, statusCode: .forbidden) }
        } catch {
            return eventLoop.submit { self.catch(error, statusCode: .badRequest) }
        }
    }
    
    private func handleList(
        on eventLoop: EventLoop,
        request: Request,
        environment: String?
    ) -> EventLoopFuture<Response> {
        do {
            let request = try ListMyComicRequest(
                request: request,
                environment: environment,
                eventLoop: eventLoop
            )

            return useCase.getMyComics(with: request)
                .map { Response(with: $0.map { Domain.ComicSummary(from: $0) }, statusCode: .ok) }
                .flatMapErrorThrowing { self.catch($0, statusCode: .forbidden) }
        } catch {
            return eventLoop.submit { self.catch(error, statusCode: .badRequest) }
        }
    }
    
    public func handleUpdate(
        on eventLoop: EventLoop,
        request: Request,
        environment: String?
    ) -> EventLoopFuture<Response> {
        do {
            let request = try UpdateMyComicRequest(
                request: request,
                environment: environment,
                eventLoop: eventLoop
            )
            
            return useCase.updateMyComic(with: request)
                .map { Response(with: Domain.ComicSummary(from: $0), statusCode: .ok) }
                .flatMapErrorThrowing { self.catch($0, statusCode: .forbidden) }

        } catch {
            return eventLoop.submit { self.catch(error, statusCode: .badRequest) }
        }
    }
    
    public func handleDelete(
        on eventLoop: EventLoop,
        request: Request,
        environment: String?
    ) -> EventLoopFuture<Response> {
        do {
            let request = try DeleteMyComicRequest(
                request: request,
                environment: environment,
                eventLoop: eventLoop
            )
            
            return useCase.delete(with: request)
                .map { Response(with: Domain.ComicSummary(from: $0), statusCode: .ok) }
                .flatMapErrorThrowing { self.catch($0, statusCode: .forbidden) }
        } catch {
            return eventLoop.submit { self.catch(error, statusCode: .badRequest) }
        }
    }
    
}
