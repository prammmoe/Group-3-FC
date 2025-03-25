//
//  addHutang.swift
//  Group3Fc
//
//  Created by Filza Rizki Ramadhan on 22/03/25.
//

import SwiftUI
import SwiftData
struct AddDebtView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    @State var name:String = ""
    @State private var amountText: String = ""
    @State private var amount: Double = 0.0
    @State var nextDueDate = Date()
    @State var dateCreated = Date()
    @State private var refreshTrigger = false
    @State private var notes:String = ""
    @State private var showAlert: Bool = false
    @State private var suggestedBorrowers: [Borrower] = []
    
    
    var body: some View {
        NavigationStack{
            ScrollView(){
                VStack(alignment: .leading, spacing: 16){
                    Text("Tambah Utang")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(ConstantColors.primary)
                    
                    VStack(){
                        HStack{
                            Text("Nama").font(.subheadline)
                            
                            Spacer()
                            Spacer()
                            
                            TextField("Masukkan nama", text: $name)
                                .frame(maxWidth: UIScreen.main.bounds.width * 0.5)
                                .font(.subheadline)
                                .multilineTextAlignment(.trailing)
                                .onChange(of: name) { oldValue, newValue in
                                    if !newValue.isEmpty && newValue != oldValue {
                                        suggestedBorrowers = findMatchingBorrowers(for: newValue, context: context)
                                    } else {
                                        suggestedBorrowers = []
                                    }
                                }
                            
                        }.padding(.vertical, 16)
                                                
                        if !suggestedBorrowers.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(suggestedBorrowers, id: \.id) { borrower in
                                        Button(action: {
                                            name = borrower.name
                                            suggestedBorrowers = []
                                        }) {
                                            Text(borrower.name)
                                                .font(.subheadline)
                                                .padding(6)
                                                .background(Color.gray.opacity(0.2))
                                                .cornerRadius(8)
                                        }
                                    }
                                }
                            }.padding(.horizontal)
                        }
                        
                        Divider()
                        
                        HStack{
                            Text("Jumlah").font(.subheadline)
                            
                            Spacer()
                            Spacer()
                            
                            TextField("Rp.0", text: $amountText)
                                .keyboardType(.numberPad)
                                .frame(maxWidth: UIScreen.main.bounds.width * 0.5)
                                .font(.subheadline)
                                .multilineTextAlignment(.trailing)
                                .onChange(of: amountText) { _ in
                                                    formatCurrencyInput()
                                }
                            
                        }.padding(.vertical, 16)
                        
                        Divider()
                        
                        HStack{
                            Text("Tanggal Tagih").font(.subheadline)
                            
                            Spacer()
                            Spacer()
                            
                            DatePicker("",selection: $nextDueDate,displayedComponents: [.date])
                                .labelsHidden()
                                .accentColor(.blueShade).tint(.blueShade)
                            
                        }.padding(.vertical, 16)
                        
                        Divider()
                        
                        HStack{
                            Text("Tanggal Utang").font(.subheadline)
                            
                            Spacer()
                            Spacer()
                            
                            DatePicker("", selection: $dateCreated,displayedComponents: [.date])
                                .labelsHidden()
                                .accentColor(.blueShade).tint(.blueShade)
                            
                        }.padding(.vertical, 16)
                        
                    }.padding(.horizontal, 16)
                        .background(.white)
                        .cornerRadius(8)
                    
                    VStack(alignment: .leading){
                        Text("Catatan").font(.subheadline)
                        
                        TextEditor(text: $notes)
                            .font(.subheadline)
                            .frame(height: 150)
                        
                    }.padding()
                        .background(.white)
                        .cornerRadius(8)
                }
            }.padding()
                .frame(maxWidth: .infinity)
                .background(ConstantColors.greyBackground)
                .toolbar{
                    ToolbarItemGroup(placement: .topBarLeading){
                        Button(action: {
                            dismiss()
                        }){
                            Text("Batal").font(.body).foregroundColor(ConstantColors.white)
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing){
                        Button(action: {
                            if !(name.isEmpty && amount.isZero) {
                                addBorrower(for: name,
                                            amount: amount,
                                            nextDueDate: nextDueDate,
                                            dateCreated: dateCreated,
                                            notes: notes,
                                            context: context
                                )
                                
                                refreshTrigger.toggle()
                                dismiss()
                            } else {
                                showAlert = true
                            }
                        }){
                            Text("Simpan")
                                .font(.body)
                                .foregroundColor(ConstantColors.primary)
                        }
                    }
                }
        }
    }
    private func findMatchingBorrowers(for name: String, context: ModelContext) -> [Borrower] {
            // Return empty array if name is empty
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
    func addBorrower(for name: String, amount: Double, nextDueDate:Date, dateCreated: Date, notes: String,context: ModelContext){
        let fetchData = FetchDescriptor<Borrower>(predicate: #Predicate { $0.name == name })
        do {
            let existingName = try context.fetch(fetchData)
            if let borrower = existingName.first{
                let newDebt = Debt(amount: (-amount), dateCreated: dateCreated, notes: notes)
                borrower.debts.append(newDebt)
                borrower.totalDebtAmount += amount
                if nextDueDate < borrower.nextDueDate {
                    borrower.nextDueDate = nextDueDate
                }
            }else{
                let borrower = Borrower(id: UUID(),name: name, nextDueDate: nextDueDate, debts: [])
                let newDebt = Debt(amount: (-amount), dateCreated: dateCreated, notes: notes)
                borrower.debts.append(newDebt)
                borrower.totalDebtAmount += amount
                context.insert(borrower)
            }
            try context.save()
        }
        catch{
            print("error: \(error.localizedDescription)")
        }
        
        
    }
    private func formatCurrencyInput() {
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
}


#Preview {
    AddDebtView()
}

