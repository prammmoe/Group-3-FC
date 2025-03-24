//
//  HistoryPaymentCard.swift
//  Group3Fc
//
//  Created by Mario Pandapotan Simarmata on 23/03/25.
//
import SwiftUI

struct HistoryPaymentCard: View {
    var index:Int
    var amount: Int
    var date: String
    var notes: String?
    var lastIndex: Int
    
    
    @StateObject var viewModel = DetailDebtorViewModel()
    var body: some View{
        HStack {
            Image(systemName: (amount > 0 ?"arrow.up.circle":"arrow.down.circle"))
                .font(.system(size: 24))
                .foregroundStyle(amount > 0 ?ConstantColors.greenAmount: ConstantColors.redAmount)
            
            VStack(alignment: .leading) {
                Text(date).font(.subheadline)
                if let notes = notes {
                    Text(notes)
                        .font(.footnote)
                        .foregroundStyle(.greyTextShade)
                }
            }
            
            Spacer()
            
            Text((amount > 0 ?"+":"-")+" Rp \(viewModel.formatToThousandSeparator(amount))")
                .font(.subheadline)
                .foregroundColor(amount > 0 ? ConstantColors.greenAmount:ConstantColors.redAmount)
        }
        .frame(height: 60)
        .padding(.horizontal)
        .background(Color.white)
        .clipShape(
            CustomCorners(
                radius: 12,
                corners: index == 0 ? [.topLeft, .topRight] :
                    index == lastIndex ? [.bottomLeft, .bottomRight] : []
            )
        )
        .overlay(
            Rectangle()
                .frame(height: index == lastIndex ? 0 : 1)
                .foregroundColor(.gray.opacity(0.3)),
            alignment: .bottom
        )
    }
}
