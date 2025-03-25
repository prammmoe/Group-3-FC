//
//  PayDebtViewModel.swift
//  Group3Fc
//
//  Created by Pramuditha Muhammad Ikhwan on 23/03/25.
//

import SwiftData
import Foundation

// TODO: Pikir lagi penamaan variable biar ga membingungkan
class PayDebtViewModel: ObservableObject {
    private var modelContext: ModelContext
    @Published var borrower: Borrower?
    
    @Published var borrowers: [Borrower] = []
    @Published var debts: [Debt] = []
    //    @Published var totalDebt: Double = 0
    @Published var totalPaid: Double = 0
    
    // Initial state-nya adalah 0
    @Published var remainingDebt: Double = 0
    @Published var isPaymentOverpaid: Bool = false
    
    // Dummy total debt untuk testing fitur
    // Asumsi ini dari borrower
//    @Published var totalDebt: Double = 1000000
    
    init(borrower: Borrower, modelContext: ModelContext) {
        self.modelContext = modelContext
        
        // Di sini sudah jadi sesuai total yang ada di DB
        self.remainingDebt = getTotalRemainingDebt
        self.borrower = borrower
    }
    
    // MARK: Function to get total remaining debt amount
    var getTotalRemainingDebt: Double {
        return borrower?.totalDebtAmount ?? 0
    }
    
    // MARK: Function untuk validasi pembayaran tanpa mengubah nilai utang
    func updateRemainingDebt(paidAmount: Double) {
        let totalRemainingDebt = getTotalRemainingDebt
        
        let potentialRemainingDebt = totalRemainingDebt - paidAmount
        
        // Cek apakah nilai pembayaran melebihi total utang
        isPaymentOverpaid = paidAmount > totalRemainingDebt
        
        // Kalkulasi temporary, bukan final value
        remainingDebt = max(potentialRemainingDebt, 0.0)
    }
    
    func payDebt (borrower: Borrower, amount: Double,newDueDate: Date?, dateCreated: Date ){
        guard amount > 0 else {
            print("Pembayaran tidak valid")
            return
        }
        
        let newDebt = Debt(amount: amount, dateCreated: dateCreated, notes: nil)
        borrower.debts.append(newDebt)
        borrower.totalDebtAmount -= amount
        
        try? modelContext.save()
    }
    
    
    func makeDebtPayment(borrower: Borrower, amount: Double, newDueDate: Date?) {
        print("Total debt tadinya adalah: \(remainingDebt)")
        
        guard amount > 0 else {
            print("Pembayaran tidak valid")
            return
        }
        
        var paidAmount = amount
        
        // Urutkan utang dari yang paling lama
        borrower.debts.sort { $0.dateCreated > $1.dateCreated }
        
        // Iterasi setiap utang
        for debt in borrower.debts {
            if paidAmount <= 0 {
                break
            }
            
            // Jika utang lebih besar dari yang dibayar, maka kurangi
            if debt.amount > paidAmount {
                debt.amount -= paidAmount
                paidAmount = 0
            } else {
                // Jika pembayaran lebih besar, kurangi dan hapus data utang
                paidAmount -= debt.amount
                modelContext.delete(debt)
            }
        }
        
        // Perbarui nextDueDate jika ada utang tersisa
        if let newDueDate = newDueDate {
            borrower.nextDueDate = newDueDate
        } else if let nextDebt = borrower.debts.min(by: { $0.dateCreated < $1.dateCreated }) {
            borrower.nextDueDate = nextDebt.dateCreated
        } else {
            borrower.nextDueDate = Date.distantFuture
        }
        
        // Save changes
        try? modelContext.save()
        
        print("Total debt setelah pembayaran: \(borrower.totalDebtAmount)")
        print("Tanggal pembayaran selanjutnya: \(borrower.nextDueDate)")
        
        // Reset isPaymentOverpaid
        isPaymentOverpaid = false
        
    }
    
    // Helper func to get All Debts of one person
    private func getAllDebts() -> [Debt] {
        return borrowers.flatMap { $0.debts }
    }
}

