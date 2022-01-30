//
//  MyCharactersResponseWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 16/01/2022.
//

import struct Domain.MyCharacter
import Foundation
import NIO

public struct MyCharactersResponseWrapper: ErrorResponseWrapper {

    private let useCase: MyCharactersUseCase

    public init(useCase: MyCharactersUseCase) {
        self.useCase = useCase
    }

    public func handleCreate(
        on eventLoop: EventLoop,
        request: Request,
        environment: String?
    ) -> EventLoopFuture<Response> {
        do {
            let request = try CreateMyCharacterRequest(
                request: request,
                environment: environment,
                eventLoop: eventLoop
            )
            
            return useCase.createMyCharacter(with: request)
                .map { Response(with: Domain.MyCharacter(from: $0), statusCode: .created) }
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
        guard let characterID = try? request.getIDFromPathParameters() else {
            return handleList(
                on: eventLoop,
                request: request,
                environment: environment
            )
        }
        
        do {
            let token = try request.getTokenFromHeaders()
            let table = String.tableName(for: environment)

            return useCase.getMyCharacter(
                withID: characterID,
                token: token,
                in: table,
                on: eventLoop
            )
                .map { Response(with: Domain.MyCharacter(from: $0), statusCode: .ok) }
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
            let token = try request.getTokenFromHeaders()
            let table = String.tableName(for: environment)

            return useCase.getMyCharacters(
                token: token,
                from: table,
                on: eventLoop
            )
                .map { Response(with: $0.map { Domain.MyCharacter(from: $0) }, statusCode: .ok) }
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
            let request = try UpdateMyCharacterRequest(
                request: request,
                environment: environment,
                eventLoop: eventLoop
            )
            
            return useCase.updateMyCharacter(with: request)
                .map { Response(with: Domain.MyCharacter(from: $0), statusCode: .ok) }
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
            let characterID = try request.getIDFromPathParameters()
            let token = try request.getTokenFromHeaders()
            let table = String.tableName(for: environment)
            
            return useCase.delete(
                withID: characterID,
                token: token,
                in: table,
                on: eventLoop
            )
                .map { Response(with: Domain.MyCharacter(from: $0), statusCode: .ok) }
                .flatMapErrorThrowing { self.catch($0, statusCode: .forbidden) }
        } catch {
            return eventLoop.submit { self.catch(error, statusCode: .badRequest) }
        }
    }
    
}
