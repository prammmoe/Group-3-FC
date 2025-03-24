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

     init(borrower: Borrower) {
         self.borrower = borrower
         self.fetchDebts()
     }

     func fetchDebts() {
         guard let borrower = borrower else { return }
         self.debts = borrower.debts.sorted { $0.dateCreated > $1.dateCreated } 
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
