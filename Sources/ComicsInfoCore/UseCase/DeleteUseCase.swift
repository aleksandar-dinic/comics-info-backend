//
//  DeleteUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 06/04/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public protocol DeleteUseCase {

    associatedtype Item: ComicInfoItem

    var deleteRepository: DeleteRepository { get }
    
}
