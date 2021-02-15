//
//  MockDB.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 27/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct MockDB {

    private static var items = [String: Data]()
    
    let eventLoop: EventLoop

    init(eventLoop: EventLoop, items: [String: Data]) {
        self.eventLoop = eventLoop
        
        for (_, el) in items.enumerated() {
            MockDB[el.key] = el.value
        }
    }

    static func removeAll() {
        MockDB.items.removeAll()
    }
    
    static var values: Dictionary<String, Data>.Values {
        items.values
    }
    
    static var enumerated: EnumeratedSequence<[String : Data]> {
        items.enumerated()
    }
    
    static subscript(key: String) -> Data? {
        get {
            items[key]
        }
        set {
            items[key] = newValue
        }
    }

}
