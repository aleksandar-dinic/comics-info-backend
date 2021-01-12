//
//  CreateSeriesProtocol.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation

protocol CreateSeriesProtocol {

    func createSeries(_ series: Series, in table: String) throws

}

extension CreateSeriesProtocol {

    func createSeries(_ series: Series, in table: String = String.tableName(for: "TEST")) throws {
        let useCase = SeriesCreateUseCaseFactoryMock().makeUseCase()
        let feature = useCase.create(series, in: table)
        try feature.wait()
    }

}
