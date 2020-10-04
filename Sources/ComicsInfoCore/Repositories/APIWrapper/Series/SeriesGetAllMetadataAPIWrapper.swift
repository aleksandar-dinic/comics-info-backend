//
//  SeriesGetAllMetadataAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 04/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

struct SeriesGetAllMetadataAPIWrapper: GetAllMetadataAPIWrapper {

    typealias Item = Series

    let repositoryAPIService: RepositoryAPIService
    let decoderService: DecoderService

}
