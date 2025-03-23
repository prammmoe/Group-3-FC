//
//  Debt.swift
//  Group3Fc
//
//  Created by Pramuditha Muhammad Ikhwan on 23/03/25.
//

import SwiftData
import Foundation

@Model
class Debt {
    @Attribute(.unique) var id: UUID
    var amount: Double
    var dateCreated: Date
    var notes: String?
    
    init(id: UUID = UUID(), amount: Double, dateCreated: Date, notes: String? = nil) {
        self.id = id
        self.amount = amount
        self.dateCreated = dateCreated
        self.notes = notes
    }
}
