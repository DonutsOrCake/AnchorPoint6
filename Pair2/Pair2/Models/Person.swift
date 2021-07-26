//
//  Person.swift
//  Pair2
//
//  Created by Bryson Jones on 7/26/21.
//

import Foundation

class Person: Codable {
    let name: String
    let timestamp: Date
    
    init(name: String, timestamp: Date = Date()) {
        self.name = name
        self.timestamp = timestamp
    }
}

extension Person: Equatable {
    static func == (lhs: Person, rhs: Person) -> Bool {
        lhs.name == rhs.name && lhs.timestamp == rhs.timestamp
    }
    
    
}
