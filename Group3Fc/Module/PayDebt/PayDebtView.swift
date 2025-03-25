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
    @State private var showAlert: Bool = false
    
    var borrower: Borrower
        
    // Init viewModel and navbar color.
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
                    
                    TextField("Rp", value: $paidAmount, formatter: NumberFormatter())
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                        .onChange(of: paidAmount) { newValue in
                            payDebtViewModel.updateRemainingDebt(paidAmount: newValue)
                        }
                }
                .padding(.vertical, 16)
                
                HStack {
                    if !(payDebtViewModel.isPaymentOverpaid || paidAmount == payDebtViewModel.getTotalRemainingDebt) {
                        DatePicker("Tanggal Tagih",
                                   selection: $date,
                                   displayedComponents: .date
                        ).accentColor(.blueShade).tint(.blueShade)
                    }
                }
                .padding(.vertical, 16)
                
            }.padding(.vertical,8).background(ConstantColors.greyFormBackground)

            Button {
                if paidAmount > 0 && !payDebtViewModel.isPaymentOverpaid {
                    payDebtViewModel.payDebt(
                        borrower: borrower,
                        amount: paidAmount,
                        newDueDate: date,
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
