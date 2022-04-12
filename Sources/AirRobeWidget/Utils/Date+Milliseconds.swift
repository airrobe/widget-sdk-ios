//
//  Date+Milliseconds.swift
//  
//
//  Created by King on 4/12/22.
//

import Foundation

extension Date {
    var millisecondsSince1970: String {
        String(Int(self.timeIntervalSince1970.rounded()))
    }

    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
