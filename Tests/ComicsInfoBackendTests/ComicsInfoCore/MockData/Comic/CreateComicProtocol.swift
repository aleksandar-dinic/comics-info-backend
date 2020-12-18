//
//  CreateComicProtocol.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation

protocol CreateComicProtocol {

    func createComic(_ comic: Comic, in table: String) throws

}

extension CreateComicProtocol {

    func createComic(_ comic: Comic, in table: String = String.tableName(for: "TEST")) throws {
        let useCase = ComicUseCaseFactoryMock().makeUseCase()
        let feature = useCase.create(comic, in: table)
        try feature.wait()

    }
}
