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
    @Relationship(deleteRule: .cascade) var debts: [Debt] = []
    
    init(id: UUID, name: String, nextDueDate: Date, debts: [Debt]) {
        self.id = id
        self.name = name
        self.nextDueDate = nextDueDate
        self.debts = debts
    }
    
    // Itung total utang dari daftar Debt
    var totalDebtAmount: Double {
        debts.reduce(0) { $0 + ($1.amount) }
    }
    
    // Itung total pembayaran yang sudah dilakukan
//    var totalPaidAmount: Double {
//        payments.reduce(0) { $0 + $1.amount }
//    }
    
    // Itung sisa utang
//    var remainingDebtAmount: Double {
//        totalDebtAmount - totalPaidAmount
//    }
    
    // Apakah utang udah lunas?
//    var isPaid: Bool {
//        remainingDebtAmount <= 0
//    }
}
