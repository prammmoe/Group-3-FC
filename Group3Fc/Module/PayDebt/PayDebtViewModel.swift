//
//  PayDebtViewModel.swift
//  Group3Fc
//
//  Created by Pramuditha Muhammad Ikhwan on 23/03/25.
//

import SwiftData
import Foundation

@MainActor
class PayDebtViewModel: ObservableObject {
    private var modelContext: ModelContext
        
    @Published var borrowers: [Borrower] = []
    @Published var debts: [Debt] = []
    @Published var totalDebt: Double = 0
    @Published var totalPaid: Double = 0
    @Published var remainingDebt: Double = 0
    @Published var isPaymentOverpaid: Bool = false
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: Function to check if the amount to be paid > total debt amount
//    func checkAmountValid(amount: Double) -> Bool {
//        return amount <= totalDebt
//    }
    
    // MARK: Function to update remaining debt
    func updateRemainingDebt(paidAmount: Double) {
        totalDebt = getTotalDebt()
        self.remainingDebt = max(totalDebt - paidAmount, 0.0)
        self.isPaymentOverpaid = paidAmount > totalDebt
    }
    
    // MARK: Function to get total debt amount from one borrower
    func getTotalDebt() -> Double {
        return getAllDebts().reduce(0) { $0 + ($1.amount) }
    }
    
    // MARK: Function to pay debt
    // Positive income (karena bayar utang)
    func makeDebtPayment(amount: Double, notes: String?) {
        // kalau mau bayar, harus cek dulu apakah dia langsung lunas atau
        // engga. kalau engga, nanti dikurangi totalDebt-nya aja terus diupdate
        
        // Cek apakah amount > 0
        guard amount > 0 else { return }
        
        // Bikin variable newPayment untuk menyimpan transaksi pembayaran
        let newPayment = Debt(amount: amount, dateCreated: Date(), notes: notes)
        
        // Append transaksi ke payments
        debts.append(newPayment)
    }
    
    // Helper func to get All Debts of one person
    private func getAllDebts() -> [Debt] {
        return borrowers.flatMap { $0.debts }
    }
    
    // Helper func to get specific borrower according to specific debt
    
    
//    // Init dummy
//    init() {
//        self.debts = [
//            Debt(name: "John", amount: 1000, date: Date(timeIntervalSinceNow: -3600), notes: "Lunch with team", isPaid: false),
//            Debt(name: "Jane", amount: 500, date: Date(timeIntervalSinceNow: -7200), notes: "Coffee with team", isPaid: false)
//        ]
//    }
    
    
}

