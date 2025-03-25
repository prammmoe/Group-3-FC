//
//  HeaderCardDetailDebtor.swift
//  Group3Fc
//
//  Created by Mario Pandapotan Simarmata on 23/03/25.
//

import SwiftUI

struct HeaderCardDetailDebtor:View {
    var name: String
    var totalDebtAmount: Double
    var nextDueDate: String
    
    var body: some View {
        
        VStack(alignment: .leading){
            VStack(alignment: .leading, spacing: 20){
                VStack (alignment: .leading) {
                    HStack(alignment: .top, spacing: 4) {
                        Text("Total sisa utang")
                            .foregroundColor(ConstantColors.blueShade)
                            .font(.caption)
                
                        Text(name)
                            .foregroundColor(ConstantColors.blueShade)
                            .font(.caption)
                    }
                    
                    Text("Rp \(Int(totalDebtAmount < 0 ? totalDebtAmount * -1 : totalDebtAmount * 1 ))")
                        .foregroundColor(ConstantColors.blueShade)
                        .font(.title).fontWeight(.bold)
                }
                
                
                HStack{
                    VStack(alignment: .leading){
                        Text("Tagihan").font(.caption2)
                            .foregroundColor(ConstantColors.greyTextShade)
                            .multilineTextAlignment(.trailing)
                            .fontWeight(.regular)
                        
                        HStack (alignment: .bottom){
                            Image(systemName: "calendar.badge.clock")
                                .foregroundStyle(Color(.secondary))
                                .font(.subheadline)
                            
                            Text(nextDueDate)
                                .font(.callout)
                                .multilineTextAlignment(.trailing)
                                .foregroundColor(ConstantColors.primary)
                                .fontWeight(.regular)
                        }
                    }
                    
                    Spacer()
                }
            }.frame(maxWidth: .infinity)
                .padding()
                .background(.white)
                .cornerRadius(16)
        }
    }
}

#Preview {
    HeaderCardDetailDebtor(name: "Mario", totalDebtAmount: 43000,nextDueDate: "24 Mar 2025")
}

