//
//  DetailDebtorViewModel.swift
//  Group3Fc
//
//  Created by Mario Pandapotan Simarmata on 22/03/25.
//

import SwiftData
import Foundation

class DetailDebtorViewModel: ObservableObject {
    @Published var borrower: Borrower?
    @Published var debts: [Debt] = []
    var dateFormatter = DateFormatter()
    
    init() {
        debts = [
            Debt(amount: 200000, dateCreated: Date()),
            Debt(amount: -300000, dateCreated: Date(),notes: "Bayar Makan"),
            Debt(amount: -300000, dateCreated: Date(),notes: "Pinjam Duit"),
        ]
        borrower = Borrower(id: UUID(), name: "Mario", nextDueDate: Date(), debts: debts)
    }
    
    func formatToThousandSeparator(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "." // Gunakan titik sebagai pemisah ribuan
        formatter.locale = Locale(identifier: "id_ID") // Menggunakan format Indonesia
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
    
    func formatDate(date: Date)-> String {
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: date)
    }
}
