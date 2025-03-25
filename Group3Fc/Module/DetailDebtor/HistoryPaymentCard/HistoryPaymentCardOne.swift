//
//  HistoryPaymentCardOne.swift
//  Group3Fc
//
//  Created by Mario Pandapotan Simarmata on 24/03/25.
//
import SwiftUI

struct HistoryPaymentCardOne: View {
    var index:Int
    var amount: Int
    var date: String
    var notes: String?
    var lastIndex: Int
    
    var body: some View{
        HStack {
            Image(systemName: (amount > 0 ?"arrow.up.circle":"arrow.down.circle"))
                .font(.system(size: 24))
                .foregroundStyle(amount > 0 ?ConstantColors.greenAmount: ConstantColors.redAmount)
            
            VStack(alignment: .leading) {
                Text(date).font(.subheadline)
                if let notes = notes, !notes.isEmpty {
                    Text(notes)
                        .font(.footnote)
                        .foregroundStyle(.greyTextShade)
                }
            }
            
            Spacer()
            
            Text((amount > 0 ?"+":"-")+" Rp \(formatToThousandSeparator(amount))")
                .font(.subheadline)
                .foregroundColor(amount > 0 ? ConstantColors.greenAmount:ConstantColors.redAmount)
            
        }.frame(height: 60)
            .padding(.horizontal)
            .background(Color.white)
            .clipShape(
                CustomCorners(
                    radius: 12,
                    corners:  [.topLeft, .topRight, .bottomRight, .bottomLeft] 
                       
                )
            )
            .overlay(
                Rectangle()
                    .frame(height: index == lastIndex ? 0 : 1)
                    .foregroundColor(.gray.opacity(0.3)),
                alignment: .bottom
            )
    }
    
    func formatToThousandSeparator(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.locale = Locale(identifier: "id_ID") 
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}
