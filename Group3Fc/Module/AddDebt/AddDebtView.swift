//
//  addHutang.swift
//  Group3Fc
//
//  Created by Filza Rizki Ramadhan on 22/03/25.
//

import SwiftUI
import SwiftData
struct AddDebtView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @State private var name:String = ""
    @State private var amount:Double = 0
    @State private var nextDueDate = Date()
    @State private var dateCreated = Date()
    @State private var refreshTrigger = false
    @State private var notes:String = ""
    var body: some View {
        NavigationView{
            ScrollView(){
                VStack(alignment: .leading, spacing: 16){
                    Text("Tambah Utang").font(.largeTitle).fontWeight(.bold).foregroundColor(Color("Primary"))
                    VStack(){
                        HStack{
                            Text("Nama").font(.subheadline)
                            Spacer()
                            Spacer()
                            TextField("Masukkan nama", text: $name)
                                .frame(maxWidth: UIScreen.main.bounds.width * 0.5).font(.subheadline).multilineTextAlignment(.trailing)
                        }.padding(.vertical, 16)
                        Divider()
                        HStack{
                            Text("Jumlah").font(.subheadline)
                            Spacer()
                            Spacer()
                            TextField("Rp.0", value: $amount, formatter: NumberFormatter()) .keyboardType(.numberPad)
                                .frame(maxWidth: UIScreen.main.bounds.width * 0.5).font(.subheadline).multilineTextAlignment(.trailing)
                        }.padding(.vertical, 16)
                        Divider()
                        HStack{
                            Text("Tanggal Tagih").font(.subheadline)
                            Spacer()
                            Spacer()
                            DatePicker(
                                    "",
                                    selection: $nextDueDate,       displayedComponents: [.date]
                                ).labelsHidden()
                        }.padding(.vertical, 16)
                        Divider()
                        HStack{
                            Text("Tanggal Utang").font(.subheadline)
                            Spacer()
                            Spacer()
                            DatePicker(
                                    "",
                                    selection: $dateCreated,       displayedComponents: [.date]
                                ).labelsHidden()
                        }.padding(.vertical, 16)
                    }.padding(.horizontal, 16).background(.white).cornerRadius(8)
                    VStack(alignment: .leading){
                        Text("Catatan").font(.subheadline)
                        TextEditor(text: $notes).font(.subheadline).frame(height: 150)
                    }.padding().background(.white).cornerRadius(8)
                }
            }.padding().frame(maxWidth: .infinity).background(Color("greyBackground"))
                .toolbar{
                    ToolbarItemGroup(placement: .topBarLeading){
                        Button(action: {
                            dismiss()
                        }){
                            Text("Batal").font(.body).foregroundColor(.black)
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing){
                        Button(action: {
                            addBorrower(for: name, amount: amount, nextDueDate: nextDueDate, dateCreated: dateCreated, notes: notes, context: context)
                            refreshTrigger.toggle()
                            dismiss()
                        }){
                            Text("Simpan").font(.body).foregroundColor(Color("Primary"))
                        }
                    }
                }
        }
        
    }
    
    private func addBorrower(for name: String, amount: Double, nextDueDate:Date, dateCreated: Date, notes: String,context: ModelContext){
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
                let newDebt = Debt(amount: amount, dateCreated: dateCreated, notes: notes)
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
}

#Preview {
    AddDebtView()
}

