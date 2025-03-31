//
//  PayDebtViewModel.swift
//  Group3Fc
//
//  Created by Pramuditha Muhammad Ikhwan on 23/03/25.
//

import SwiftData
import Foundation

class PayDebtViewModel: ObservableObject {
    private var modelContext: ModelContext
    @Published var borrower: Borrower?
    
    @Published var borrowers: [Borrower] = []
    @Published var debts: [Debt] = []
    @Published var totalPaid: Double = 0
    
    @Published var remainingDebt: Double = 0
    @Published var isPaymentOverpaid: Bool = false
    
    @Published var paidAmountText: String = ""
    @Published var amount: Double = 0.0
    @Published var date: Date = Date()


    init(borrower: Borrower, modelContext: ModelContext) {
        self.modelContext = modelContext
        self.remainingDebt = getTotalRemainingDebt
        self.borrower = borrower
    }
    
    var getTotalRemainingDebt: Double {
        return borrower?.totalDebtAmount ?? 0
    }
    
    func updateRemainingDebt(paidAmount: Double) {
        let totalRemainingDebt = getTotalRemainingDebt
        
        let potentialRemainingDebt = totalRemainingDebt - paidAmount
        
        isPaymentOverpaid = paidAmount > totalRemainingDebt
        
        remainingDebt = max(potentialRemainingDebt, 0.0)
    }
    
    func payDebt (borrower: Borrower, amount: Double,newDueDate: Date?, dateCreated: Date ){
        guard amount > 0 else {
            print("Pembayaran tidak valid")
            return
        }
        
        if borrower.totalDebtAmount > 0 {
            let newDebt = Debt(amount: amount, dateCreated: dateCreated, notes: nil)
            borrower.debts.append(newDebt)
            borrower.totalDebtAmount -= amount
            borrower.nextDueDate = newDueDate!
            
            try? modelContext.save()
            isPaymentOverpaid = false
        }
    }
    
    
    func makeDebtPayment(borrower: Borrower, amount: Double, newDueDate: Date?) {
        print("Total debt tadinya adalah: \(remainingDebt)")
        
        guard amount > 0 else {
            print("Pembayaran tidak valid")
            return
        }
        
        var paidAmount = amount
        
        borrower.debts.sort { $0.dateCreated > $1.dateCreated }
        
        for debt in borrower.debts {
            if paidAmount <= 0 {
                break
            }
            
            if debt.amount > paidAmount {
                debt.amount -= paidAmount
                paidAmount = 0
            } else {
                paidAmount -= debt.amount
                modelContext.delete(debt)
            }
        }
        
        if let newDueDate = newDueDate {
            borrower.nextDueDate = newDueDate
        } else if let nextDebt = borrower.debts.min(by: { $0.dateCreated < $1.dateCreated }) {
            borrower.nextDueDate = nextDebt.dateCreated
        } else {
            borrower.nextDueDate = Date.distantFuture
        }
        
        try? modelContext.save()
        
        print("Total debt setelah pembayaran: \(borrower.totalDebtAmount)")
        print("Tanggal pembayaran selanjutnya: \(borrower.nextDueDate)")
        
        isPaymentOverpaid = false
        
    }
    
    private func getAllDebts() -> [Debt] {
        return borrowers.flatMap { $0.debts }
    }
    
    func formatCurrencyInput() {
        let cleaned = paidAmountText.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        if let number = Double(cleaned) {
            amount = number
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.locale = Locale(identifier: "id_ID")
            formatter.groupingSeparator = "."
            
            if let formatted = formatter.string(from: NSNumber(value: number)) {
                paidAmountText = "Rp. \(formatted)"
            }
        } else {
            paidAmountText = ""
            amount = 0.0
        }
    }
    
}

