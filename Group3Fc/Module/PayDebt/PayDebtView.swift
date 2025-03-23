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
    @StateObject var payDebtViewModel: PayDebtViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var paidAmount: Double = 0
    @State private var remainingDebt: Double = 0
    @State private var isPaymentOverpaid: Bool = false // Conditional to check if the payment exceeds the maximum debt amount
    @State private var date: Date = Date()
    
    let totalDebtAmount: Double = 100000 // Dummy constant to test the total debt
    
    // Init viewModel
    init(modelContext: ModelContext) {
        _payDebtViewModel = StateObject(wrappedValue: PayDebtViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                HStack {
                    Text("Jumlah")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    TextField("Rp", value: $paidAmount, format: .number)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                        .onChange(of: paidAmount) { newValue in
                            payDebtViewModel.updateRemainingDebt(paidAmount: newValue)
                        }
                }
                
                if !isPaymentOverpaid {
                    DatePicker("Tanggal Tagih", selection: $date, displayedComponents: .date)
                        .foregroundStyle(.primary)
                }
            }
            
            Button(action: {
                // TODO: Implementasi logika pembayaran
            }) {
                Text("Bayar")
                    .foregroundStyle(.white)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .background(ConstantColors.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
//                        if paidAmount > 0 {
//                            payDebtViewModel.makeDebtPayment(amount: paidAmount)
//                          
//                        }
                        dismiss()
                    } label: {
//                        Image(systemName: "xmark")
                        Text("Batal")
                    }
                }
            }
        }
        
    }
    
//    private func updateRemainingDebt(paidAmount: Double) {
//        remainingDebt = max(totalDebtAmount - paidAmount, 0.0)
//        isPaymentOverpaid = paidAmount >= totalDebtAmount
//    }
}

#Preview {
    PayDebtView(modelContext: sharedModelContainer.mainContext)
}
