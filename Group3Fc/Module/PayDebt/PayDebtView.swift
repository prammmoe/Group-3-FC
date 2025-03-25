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
    @StateObject private var payDebtViewModel: PayDebtViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var paidAmount: Double = 0
    @State private var date: Date = Date()
    
    var borrower: Borrower
        
    // Init viewModel and navbar color.
    init(modelContext: ModelContext, borrower: Borrower) {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(resource: .blueShade)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(resource: .blueShade)]
        self.borrower = borrower
        _payDebtViewModel = StateObject(wrappedValue: PayDebtViewModel(borrower: borrower, modelContext: modelContext))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                HStack {
                    Text("Jumlah Bayar")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    TextField("Rp", value: $paidAmount, format: .number)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                        .onChange(of: paidAmount) { newValue in
                            payDebtViewModel.updateRemainingDebt(paidAmount: newValue)
                        }
                }

                if !(payDebtViewModel.isPaymentOverpaid || paidAmount == payDebtViewModel.getTotalRemainingDebt) {
                    DatePicker("Tanggal Tagih",
                               selection: $date,
                               displayedComponents: .date
                    ).foregroundStyle(.primary)
                    
                } else if payDebtViewModel.isPaymentOverpaid {
                    Text("Jumlah pembayaran melebihi total utang!")
                        .foregroundStyle(.red)
                }
            }
            
            Button {
                if paidAmount > 0 && !payDebtViewModel.isPaymentOverpaid {
//                    payDebtViewModel.makeDebtPayment(
//                        borrower: borrower,
//                        amount: paidAmount,
//                        newDueDate: date
//                    )
                    
                    payDebtViewModel.payDebt(
                        borrower: borrower,
                        amount: paidAmount,
                        newDueDate: date,
                        dateCreated: Date()
                    )
                    
                    dismiss()
                }
            } label: {
                Text("Bayar")
                    .foregroundStyle(.white)
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity)
                    .background(ConstantColors.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
           .disabled(paidAmount <= 0 || payDebtViewModel.isPaymentOverpaid)
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Batal")
                    }
                }
            }
            .navigationTitle("Bayar Utang")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
