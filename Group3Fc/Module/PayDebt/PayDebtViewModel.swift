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
    @Published var totalPaid: Double = 0
    
    // Initial state-nya adalah 0
    @Published var remainingDebt: Double = 0
    @Published var isPaymentOverpaid: Bool = false
    
    init(borrower: Borrower, modelContext: ModelContext) {
        self.borrower = borrower
        self.modelContext = modelContext
        // Di sini sudah jadi sesuai total yang ada di DB
        self.remainingDebt = getTotalRemainingDebt
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
    
    func makeDebtPayment(borrower: Borrower, amount: Double, newDueDate: Date?) {
        print("Total debt tadinya adalah: \(borrower.totalDebtAmount)")
        
        guard amount > 0, borrower.totalDebtAmount > 0 else {
            print("Pembayaran tidak valid")
            return
        }
        
        var paidAmount = amount
        
        // Urutkan utang dari yang paling lama (tertua)
        let sortedDebts = borrower.debts.sorted { $0.dateCreated < $1.dateCreated }
        
        // Iterasi setiap utang
        for debt in sortedDebts {
            if paidAmount <= 0 {
                break
            }
            
            if debt.amount > paidAmount {
                debt.amount -= paidAmount
                paidAmount = 0
            } else {
                paidAmount -= debt.amount
                modelContext.delete(debt)
                // Langsung hapus dari array untuk menghindari reference yang tidak valid
                borrower.debts.removeAll { $0.id == debt.id }
            }
        }
        
        // Perbarui remaining debt
        remainingDebt = borrower.totalDebtAmount
        
        // Cek apakah semua utang udah lunas
        if borrower.debts.isEmpty {
            print("Semua utang lunas, menghapus borrower: \(borrower.name)")
            modelContext.delete(borrower)
        } else {
            // Update next due date
            if let newDueDate = newDueDate {
                borrower.nextDueDate = newDueDate
            }
        }
        
        // Save changes
        do {
            try modelContext.save()
            print("Perubahan berhasil disimpan")
        } catch {
            print("Gagal menyimpan perubahan:", error.localizedDescription)
        }
        
        // Debug
        printStatusAfterPayment()
    }

    private func printStatusAfterPayment() {
        print("Daftar borrower setelah pembayaran:")
        do {
            let borrowers = try modelContext.fetch(FetchDescriptor<Borrower>())
            if borrowers.isEmpty {
                print("- Tidak ada borrower tersisa")
            } else {
                for b in borrowers {
                    print("- \(b.name), Total Utang: \(b.totalDebtAmount), Next Due: \(b.nextDueDate)")
                }
            }
        } catch {
            print("Gagal mengambil daftar borrower:", error.localizedDescription)
        }
    }
    
    // Helper func to get All Debts of one person
    private func getAllDebts() -> [Debt] {
        return borrowers.flatMap { $0.debts }
    }
}

