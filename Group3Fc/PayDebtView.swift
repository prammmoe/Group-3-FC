//
//  PayDebtView.swift
//  Group3Fc
//
//  Created by Pramuditha Muhammad Ikhwan on 22/03/25.
//

import SwiftUI

struct PayDebtView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var debtAmount: Double = 0
    @State private var remainingDebt: Double = 0
    @State private var isPaymentOverpaid: Bool = false
    @State private var date: Date = Date()
    
    // Constant to test the DatePicker logic
    let totalDebtAmount: Double = 100000
    
    var body: some View {
        NavigationStack {
            Form {
                HStack {
                    Text("Jumlah").frame(width: nil, height: nil, alignment: .topLeading)
                    TextField("Rp", value: $debtAmount, format: .number) // Sementara .number dulu
                        .autocapitalization(.words)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                        .onChange(of: debtAmount) { newValue in
                            updateRemainingDebt(paidAmount: newValue)
                        }
                }
                if !isPaymentOverpaid {
                    //                    Text("Sisa utang: Rp \(remainingDebt, specifier: "%.2f")")
                    //                        .foregroundColor(.gray)
                    DatePicker("Tanggal Tagih", selection: $date, displayedComponents: .date)
                        .foregroundStyle(.primary)
                    // TODO: nambah logic disable
                }
                
            }
            
            Button {
                // TODO: implement logic viewModel bayar
            } label: {
                Text("Bayar")
                    .foregroundStyle(.white)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .background(Color("textPrimary"))
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding()
        }
        .navigationTitle("Bayar Utang")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Batal") {
                    dismiss()
                }
            }
        }
    }
    
    private func updateRemainingDebt(paidAmount: Double) {
        let newRemainingDebt = max(totalDebtAmount - paidAmount, 0.0)
        remainingDebt = newRemainingDebt
        isPaymentOverpaid = paidAmount >= totalDebtAmount
    }
}

// Function to calculate remaining debt
func calculateRemainingDebt(totalDebtAmount: Double, paidAmount: Double) -> Double {
    return max(totalDebtAmount - paidAmount, 0.0)
}

// Function to check if the payment overpaid
// Used to perform conditional alert if it's overpaid
func isPaymentOverpaid(totalDebtAmount: Double, paidAmount: Double) -> Bool {
    return paidAmount >= totalDebtAmount
}

#Preview {
    PayDebtView()
}
