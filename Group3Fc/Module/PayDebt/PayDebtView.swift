//
//  PayDebtView.swift
//  Group3Fc
//
//  Created by Mario Pandapotan Simarmata on 22/03/25.
//
import SwiftUI
import SwiftData

struct PayDebtView: View {
  
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @StateObject private var payDebtViewModel: PayDebtViewModel

    @State private var showAlert: Bool = false
    var borrower: Borrower
    
    init(modelContext: ModelContext, borrower: Borrower) {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(resource: .primary)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(resource: .primary)]
        self.borrower = borrower
        _payDebtViewModel = StateObject(wrappedValue: PayDebtViewModel(borrower: borrower, modelContext: modelContext))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                HStack {
                    Text("Jumlah Bayar")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(ConstantColors.blueShade)
                    
                    TextField("Rp 0", text: $payDebtViewModel.paidAmountText)
                        .frame(height: 40)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                        .onChange(of: payDebtViewModel.paidAmountText) { _ in
                            payDebtViewModel.formatCurrencyInput()
                            payDebtViewModel.updateRemainingDebt(paidAmount: payDebtViewModel.amount)
                        }
                }.tint(ConstantColors.blueShade)
                    .frame(height: 44)
                
                if !(payDebtViewModel.isPaymentOverpaid || payDebtViewModel.amount == payDebtViewModel.getTotalRemainingDebt) {
                    HStack (spacing: 8) {
                        Text("Tanggal Tagih")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(ConstantColors.blueShade)
                        
                        HStack {
                            Image(systemName: "calendar.badge.clock")
                                .foregroundStyle(ConstantColors.primary
                                ).font(.title3)
                            
                            DatePicker("",
                                       selection: $payDebtViewModel.date,
                                       displayedComponents: .date
                            ).accentColor(.blueShade)
                                .tint(.blueShade)
                        }
                        
                     
                        
                    }.padding(.vertical, 16)
                    
                }
                
            }.padding(.vertical,8).background(ConstantColors.greyFormBackground)
            
            Button {
                if payDebtViewModel.amount > 0 && !payDebtViewModel.isPaymentOverpaid {
                    payDebtViewModel.payDebt(
                        borrower: borrower,
                        amount: payDebtViewModel.amount,
                        newDueDate: payDebtViewModel.date,
                        dateCreated: Date()
                    )
                    
                    dismiss()
                } else {
                    showAlert = true
                }
            } label: {
                Text("Bayar")
                    .foregroundStyle(.white)
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity)
                    .background(ConstantColors.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Jumlah Tidak Valid"), message: Text("Pastikan jumlah tidak kosong dan tidak melebihi jumlah utang"), dismissButton: .default(Text("Oke")))
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Batal").foregroundColor(ConstantColors.white)
                    }
                }
            }
            .navigationTitle("Bayar Utang")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    
}
#Preview {
    PayDebtView(
        modelContext: try! ModelContainer(for: Borrower.self).mainContext,
        borrower: Borrower(name: "John Doe", nextDueDate: Date(), debts: []
                          )
    )
}

