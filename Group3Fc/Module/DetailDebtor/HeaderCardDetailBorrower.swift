//
//  HeaderCardDetailDebtor.swift
//  Group3Fc
//
//  Created by Mario Pandapotan Simarmata on 23/03/25.
//

import SwiftUI

struct HeaderCardDetailDebtor:View {
//    @StateObject var viewModel = DetailDebtorViewModel()

    var name: String
    var totalDebtAmount: Double
    var body: some View {
        
        VStack(alignment: .leading){
            VStack(alignment: .leading, spacing: 12){
                HStack(alignment: .top, spacing: 4) {
                    Text("Total Sisa Utang").foregroundColor(ConstantColors.textSecondary).font(.caption)
                    Text(name).foregroundColor(ConstantColors.textSecondary).font(.caption)
                }
                Text("Rp \(Int(totalDebtAmount < 0 ? totalDebtAmount * -1 : totalDebtAmount * 1 ))")
                    .foregroundColor(ConstantColors.blueShade).font(.title).fontWeight(.bold)
                HStack{
                    VStack(alignment: .leading){
                        Text("Tagihan terdekat").font(.caption2).foregroundColor(ConstantColors.greyTextShade).multilineTextAlignment(.trailing)
                        Text("Selasa, 26 Feb 2025").font(.footnote).multilineTextAlignment(.trailing).foregroundColor(ConstantColors.primary).fontWeight(.bold)
                    }
                    Spacer()
                }
            }.frame(maxWidth: .infinity).padding().background(.white).cornerRadius(16).shadow(color: Color.black.opacity(0.4), radius: 1, x: 0, y: 1)
        }
    }
}

