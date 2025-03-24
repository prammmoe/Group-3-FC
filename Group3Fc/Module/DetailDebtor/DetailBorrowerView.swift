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
    @StateObject private var viewModel = DetailDebtorViewModel()
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor(resource: .blueShade)
        ]
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HeaderCardDetailDebtor(name: viewModel.borrower!.name)
                        .padding(.horizontal)
                    
                    Text("Riwayat Bayar")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(ConstantColors.black)
                        .padding(.horizontal)
                    
                    LazyVStack(spacing: 0) {
                        ForEach(Array(viewModel.borrower!.debts.enumerated()), id: \.element.id) { index, debt in
                            
                            HistoryPaymentCard(
                                index: index,
                                amount: Int(debt.amount),
                                date: viewModel.formatDate(date: debt.dateCreated),
                                notes: debt.notes,
                                lastIndex: (viewModel.borrower!.debts.count - 1)
                            )
                        }
                    }.padding(.horizontal)
                    
                }.padding(.vertical)
            }
            .background(ConstantColors.greyFormBackground)
            .navigationTitle("Detail Peminjam")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    DetailDebtorView()
}








