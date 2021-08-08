//
//  DeleteUseCaseFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 26/04/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

public protocol DeleteUseCaseFactory: DeleteRepositoryBuilder  {

    associatedtype UseCaseType: DeleteUseCase

    func makeUseCase() -> UseCaseType

}
