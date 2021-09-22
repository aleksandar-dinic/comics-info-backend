//
//  Date+ToString.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 22/09/2021.
//

import Foundation

extension Date {
    
    func toDefaultString() -> String {
        DateFormatter.default().string(from: self)
    }
    
}
