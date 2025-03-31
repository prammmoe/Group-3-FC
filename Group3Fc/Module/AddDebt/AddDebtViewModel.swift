//
//  AddDebtViewModel.swift
//  Group3Fc
//
//  Created by Filza Rizki Ramadhan on 25/03/25.
//

import SwiftData
import Foundation

class AddDebtViewModel: ObservableObject{
    @Published var name: String = ""
    @Published var amountText: String = ""
    @Published var amount: Double = 0.0
    @Published var nextDueDate = Date()
    @Published var dateCreated = Date()
    @Published var notes: String = ""
    
    
    @Published var suggestedBorrowers: [Borrower] = []
    
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        
        return formatter.string(from: date)
    }
    
    func findMatchingBorrowers(for name: String, context: ModelContext) -> [Borrower] {
        guard !name.isEmpty else { return [] }
        
        let fetchData = FetchDescriptor<Borrower>(
            predicate: #Predicate {
                $0.name.localizedStandardContains(name)
            }
        )
        
        do {
            return try context.fetch(fetchData)
        } catch {
            print("Error fetching data: \(error)")
            return []
        }
    }
    
    func formatCurrencyInput() {
        let cleaned = amountText.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        if let number = Double(cleaned) {
            amount = number
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.locale = Locale(identifier: "id_ID")
            formatter.groupingSeparator = "."
            
            if let formatted = formatter.string(from: NSNumber(value: number)) {
                amountText = "Rp. \(formatted)"
            }
        } else {
            amountText = ""
            amount = 0.0
        }
    }
    
    func addBorrower(for name: String, amount: Double, nextDueDate:Date, dateCreated: Date, notes: String,context: ModelContext){
        let fetchData = FetchDescriptor<Borrower>(predicate: #Predicate { $0.name == name })
        do {
            let existingName = try context.fetch(fetchData)
            if let borrower = existingName.first{
                let newDebt = Debt(amount: (-amount), dateCreated: dateCreated, notes: notes)
                borrower.debts.append(newDebt)
                borrower.totalDebtAmount += amount
                borrower.nextDueDate = nextDueDate
                
            }else{
                let borrower = Borrower(id: UUID(),name: name, nextDueDate: nextDueDate, debts: [])
                let newDebt = Debt(amount: (-amount), dateCreated: dateCreated, notes: notes)
                borrower.debts.append(newDebt)
                borrower.totalDebtAmount += amount
                borrower.nextDueDate = nextDueDate
                context.insert(borrower)
            }
            try context.save()
        }
        catch{
            print("error: \(error.localizedDescription)")
        }
        
        
    }
}
