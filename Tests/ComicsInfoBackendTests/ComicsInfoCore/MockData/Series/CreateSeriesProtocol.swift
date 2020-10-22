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

    func createSeries(_ series: Series) throws

}

extension CreateSeriesProtocol {

    func createSeries(_ series: Series) throws {
        let useCase = SeriesUseCaseFactoryMock().makeUseCase()
        let feature = useCase.create(series)
        try feature.wait()
    }

}
