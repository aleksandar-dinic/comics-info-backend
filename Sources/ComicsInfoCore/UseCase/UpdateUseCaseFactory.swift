//
//  UpdateUseCaseFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

public protocol UpdateUseCaseFactory: UpdateRepositoryBuilder  {

    associatedtype UseCaseType: UpdateUseCase

    func makeUseCase() -> UseCaseType

}
