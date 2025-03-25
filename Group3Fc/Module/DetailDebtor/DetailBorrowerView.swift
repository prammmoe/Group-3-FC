//
//  DetailDebtorView.swift
//  Group3Fc
//
//  Created by Mario Pandapotan Simarmata on 22/03/25.
//

import SwiftUI
import SwiftUI

struct DetailDebtorView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: DetailDebtorViewModel
    
    @State private var presentSheet: Bool = false
    
    var borrower: Borrower
    init(borrower: Borrower) {
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor(resource: .blueShade)
        ]
        self.borrower = borrower
        _viewModel = StateObject(wrappedValue: DetailDebtorViewModel(borrower: borrower))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HeaderCardDetailDebtor(name: viewModel.borrower!.name,totalDebtAmount: viewModel.borrower!.totalDebtAmount)
                        .padding(.horizontal)
                    
                    Text("Riwayat Bayar")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(ConstantColors.black)
                        .padding(.horizontal)
                    
                    if (viewModel.borrower!.debts.count == 0) {
                        VStack (alignment: .center) {
                            HistoryPaymentCardEmptyState()
                        }
                        .frame(maxWidth: .infinity).padding()
                        
                    }else {
                        LazyVStack(spacing: 0) {
                            ForEach(Array(viewModel.borrower!.debts.sorted(by: { $0.dateCreated > $1.dateCreated }).enumerated()), id: \.element.id) { index, debt in
                                if viewModel.borrower!.debts.count == 1 {
                                    HistoryPaymentCardOne(
                                        index: index,
                                        amount: Int(debt.amount),
                                        date: viewModel.formatDate(date: debt.dateCreated),
                                        notes: debt.notes,
                                        lastIndex: (viewModel.borrower!.debts.count - 1)
                                    )
                                    
                                } else {
                                    HistoryPaymentCard(
                                        index: index,
                                        amount: Int(debt.amount),
                                        date: viewModel.formatDate(date: debt.dateCreated),
                                        notes: debt.notes,
                                        lastIndex: (viewModel.borrower!.debts.count - 1)
                                    )
                                }
                                
                            }

                        }.padding(.horizontal)
                    }
                    
                    
                }.padding(.vertical)
            }
            .background(ConstantColors.greyFormBackground)
            .navigationTitle("Detail Peminjam")
            .navigationBarTitleDisplayMode(.inline)
            
        }.toolbar {
            ToolbarItem {
                Button {
                    presentSheet = true
                } label: {
                    Text("Bayar")
                }
            }
        }
        .sheet(isPresented: $presentSheet) {
            PayDebtView(modelContext: modelContext, borrower: borrower)
        }
    }
}

#Preview {
    DetailDebtorView(
        borrower:
            Borrower(id: UUID(), name: "Ninja", nextDueDate: Date(), debts: [
                Debt(amount: 5000, dateCreated: Date(), notes: nil),
                //                Debt(amount: 5000, dateCreated: Date(), notes: nil),
            ]
                    )
    )
}







