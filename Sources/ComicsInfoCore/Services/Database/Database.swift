//
//  Database.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 27/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol Database {

    func getAll(fromTable table: DatabaseTable) -> EventLoopFuture<[[String: Any]]?>

    func get(fromTable table: DatabaseTable, forID ID: String) -> EventLoopFuture<[String: Any]?>

}
