//
//  CreateComicProtocol.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import NIO

protocol CreateComicProtocol {

    func createComic(_ comic: Comic, on eventLoop: EventLoop, in table: String) throws

}

extension CreateComicProtocol {

    func createComic(
        _ comic: Comic,
        on eventLoop: EventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next(),
        in table: String = String.tableName(for: "TEST")
    ) throws {
        let useCase = ComicCreateUseCaseFactoryMock().makeUseCase()
        let criteria = CreateItemCriteria(item: comic, on: eventLoop, in: table)
        let feature = useCase.create(with: criteria)
        try feature.wait()
    }
    
}
