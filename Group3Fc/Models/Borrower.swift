//
//  Borrower.swift
//  Group3Fc
//
//  Created by Pramuditha Muhammad Ikhwan on 23/03/25.
//

import SwiftData
import Foundation

@Model
class Borrower {
    @Attribute(.unique) var id: UUID
    @Attribute(.unique) var name: String
    var nextDueDate: Date
    var totalDebtAmount: Double = 0
    @Relationship(deleteRule: .cascade) var debts: [Debt] = []
    
    init(id: UUID = UUID(), name: String, nextDueDate: Date, debts: [Debt]) {
        self.id = id
        self.name = name
        self.nextDueDate = nextDueDate
        self.debts = debts
    }
     
}
