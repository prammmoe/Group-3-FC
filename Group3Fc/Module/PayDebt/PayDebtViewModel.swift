//
//  PayDebtViewModel.swift
//  Group3Fc
//
//  Created by Pramuditha Muhammad Ikhwan on 23/03/25.
//

import SwiftData
import Foundation

// TODO: Pikir lagi penamaan variable biar ga membingungkan

@MainActor
class PayDebtViewModel: ObservableObject {
    private var modelContext: ModelContext
    
    @Published var borrowers: [Borrower] = []
    @Published var debts: [Debt] = []
    //    @Published var totalDebt: Double = 0
    @Published var totalPaid: Double = 0
    @Published var remainingDebt: Double = 0
    @Published var isPaymentOverpaid: Bool = false
    
    // Dummy total debt untuk testing fitur
    // Asumsi ini dari borrower
    @Published var totalDebt: Double = 1000000
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.remainingDebt = totalDebt // Pakai remaining debt untuk menghitung setiap
        // pengurangan dari total debt
    }
    
    // MARK: Function to check if the amount to be paid > total debt amount
    //    func checkAmountValid(amount: Double) -> Bool {
    //        return amount <= totalDebt
    //    }
    
    // MARK: Function untuk validasi pembayaran tanpa mengubah nilai utang
    func updateRemainingDebt(paidAmount: Double) {
        let potentialRemainingDebt = totalDebt - paidAmount
        isPaymentOverpaid = paidAmount > totalDebt
        
        // Kalkulasi temporary, bukan final value
        remainingDebt = max(potentialRemainingDebt, 0.0)
    }
    
    // MARK: Function to get total debt amount from one borrower
    func getTotalDebt() -> Double {
        return getAllDebts().reduce(0) { $0 + ($1.amount) }
    }
    
    // MARK: Function to pay debt
    /// Positive income (karena bayar utang)
    /// Di function ini harusnya nanti ga cuma append pembayaran utang saja, tapi update totalUtang yang ada di entity borrower
    func makeDebtPayment(amount: Double) {
        // Cek total debt berapa di awal
        print("Total debt tadinya adalah: \(totalDebt)")
        
        // Valid condition: amount lebih dari 0 dan amount kurang dari sama dengan total utang
        guard amount > 0, amount <= totalDebt else {
            print("Pembayaran tidak valid")
            return
        } // masih nested check
        
        
        // Bikin variable newPayment untuk menyimpan transaksi pembayaran
        let newPayment = Debt(amount: amount, dateCreated: Date())
        
        // Append setiap ada payment baru
        debts.append(newPayment)
        
        // Perbarui isi totalDebt setiap ada pembayaran
        totalDebt -= amount
        
        // Perbarui remaining debt ke nilai terakhir dari total debt
        remainingDebt = totalDebt
        
        // TODO: update borrower entity & insert datanya ke borrower entity
        
        // Insert payment baru ke database
        modelContext.insert(newPayment)
        
        // Save changes
        try? modelContext.save()
        
        print("Habis payment, sisa utangnya adalah: \(remainingDebt)")
        
        // Reset isPaymentOverpaid
        isPaymentOverpaid = false
        
    }
    
    // Helper func to get All Debts of one person
    private func getAllDebts() -> [Debt] {
        return borrowers.flatMap { $0.debts }
    }
}

