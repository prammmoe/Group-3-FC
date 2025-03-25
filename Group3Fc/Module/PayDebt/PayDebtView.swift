//
//  PayDebtView.swift
//  Group3Fc
//
//  Created by Mario Pandapotan Simarmata on 22/03/25.
//
import SwiftUI
import SwiftData

struct PayDebtView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    var borrower: Borrower
    @StateObject private var viewModel: PayDebtViewModel
    
    @State private var paidAmount: Double = 0
    @State private var date: Date = Date()
        
    // Init viewModel and navbar color.
    init(modelContext: ModelContext, borrower: Borrower) {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(resource: .blueShade)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(resource: .blueShade)]
        self.borrower = borrower
        _viewModel = StateObject(wrappedValue: PayDebtViewModel(borrower: borrower, modelContext: modelContext))
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
                            // Hanya untuk validasi, bukan mengubah total utang
                            viewModel.updateRemainingDebt(paidAmount: newValue)
                        }
                }
                // Async check if the payment overpaid was true and paid amount equals total debt, then hide the datepicker
                if !(viewModel.isPaymentOverpaid || paidAmount == viewModel.getTotalRemainingDebt) {
                    DatePicker("Tanggal Tagih", selection: $date, displayedComponents: .date)
                        .foregroundStyle(.primary)
                } else if viewModel.isPaymentOverpaid {
                    Text("Jumlah pembayaran melebihi total utang!")
                        .foregroundStyle(.red)
                }
            }
            
            Button {
                if paidAmount > 0 && !viewModel.isPaymentOverpaid {
                    viewModel.makeDebtPayment(
                        borrower: borrower,
                        amount: paidAmount,
                        newDueDate: date
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
            // MARK: Disabled case
            // Kalau amount yang mau dibayar 0 atau amountnya lebih dari total debt maka button-nya akan disabled
            .disabled(paidAmount <= 0 || viewModel.isPaymentOverpaid)
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

//#Preview {
//    PayDebtView(modelContext: sharedModelContainer.mainContext)
//}
