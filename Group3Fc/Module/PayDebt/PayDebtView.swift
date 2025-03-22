//
//  PayDebtView.swift
//  Group3Fc
//
//  Created by Mario Pandapotan Simarmata on 22/03/25.
//

import SwiftUI

struct PayDebtView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var debtAmount: Double = 0
    @State private var remainingDebt: Double = 0
    @State private var isPaymentOverpaid: Bool = false
    @State private var date: Date = Date()
    
    let totalDebtAmount: Double = 100000
    
    var body: some View {
        NavigationStack {
            Form {
                HStack {
                    Text("Jumlah")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    TextField("Rp", value: $debtAmount, format: .number)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                        .onChange(of: debtAmount) { newValue in
                            updateRemainingDebt(paidAmount: newValue)
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
                    .background(ConstantColors.Primary)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
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
        remainingDebt = max(totalDebtAmount - paidAmount, 0.0)
        isPaymentOverpaid = paidAmount >= totalDebtAmount
    }
}

#Preview {
    PayDebtView()
}
