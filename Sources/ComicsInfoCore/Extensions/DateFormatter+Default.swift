//
//  DateFormatter+Default.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 12/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    static func `default`() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "dd MMMM yyyy HH:mm:ss Z"
        return formatter
    }
    
    static func defaultString(from date: Date) -> String {
        let formatter = DateFormatter.default()
        return formatter.string(from: date)
    }
    
    static func defaultDate(from string: String) -> Date? {
        let formatter = DateFormatter.default()
        return formatter.date(from: string)
    }
    
}
