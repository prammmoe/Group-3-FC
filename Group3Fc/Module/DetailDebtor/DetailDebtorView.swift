//
//  DetailDebtorView.swift
//  Group3Fc
//
//  Created by Mario Pandapotan Simarmata on 22/03/25.
//

import SwiftUI
import SwiftUI

struct DetailDebtorView: View {
    
    @StateObject var viewModel = DetailDebtorViewModel()
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HeaderCardDetailDebtor(name: "Mario")
                        .padding(.horizontal)
                    
                    Text("Riwayat Bayar")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(ConstantColors.black)
                        .padding(.horizontal)
                    
                    LazyVStack(spacing: 0) {
                        ForEach(0..<7, id: \.self) { index in
                            HistoryPaymentCard(index: index, amount: 1000)
                        }
                        
                    }.padding(.horizontal)
                }
                .padding(.vertical)
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








