//
//  HomeHeaderCard.swift
//  Group3Fc
//
//  Created by Mario Pandapotan Simarmata on 25/03/25.
//

import SwiftUI

struct HeaderCard:View {
    @Binding var totalDebt: Double
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text("Dashboard")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(ConstantColors.white)
                
                Spacer()
                
            }
            VStack(alignment: .leading, spacing: 12){
                Text("Total Sisa Utang")
                    .foregroundColor(ConstantColors.blueShade)
                    .font(.caption)
                
                Text(totalDebt, format: .currency(code: "IDR"))
                    .foregroundColor(ConstantColors.blueShade)
                    .font(.title)
                    .fontWeight(.bold)
                
                HStack{
                    HStack(spacing:4){
                        Text("Kamu punya")
                            .font(.caption)
                            .foregroundColor(ConstantColors.primary)
                        
                        Text("3")
                            .font(.caption)
                            .foregroundColor(ConstantColors.secondary)
                            .fontWeight(.bold)
                        
                        Text("Utang Aktif!")
                            .font(.caption)
                            .foregroundColor(ConstantColors.primary)
                            .fontWeight(.bold)
                        
                    }.padding(.horizontal,8)
                        .padding(.vertical, 4)
                        .background(ConstantColors.blueTint)
                        .overlay(RoundedRectangle(
                            cornerRadius: 8)
                            .stroke(Color("Secondary"), lineWidth: 1))
                    
                    Spacer()
                    
                    VStack(alignment: .trailing){
                        Text("Tagihan terdekat")
                            .font(.caption2)
                            .foregroundColor(ConstantColors.greyTextShade)
                            .multilineTextAlignment(.trailing)
                        
                        Text("Selasa, 26 Feb 2025")
                            .font(.footnote)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(ConstantColors.primary)
                            .fontWeight(.bold)
                        
                    }
                }
            }.frame(maxWidth: .infinity)
                .padding()
                .background(ConstantColors.white)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.4),
                        radius: 4, x: 0, y: 4
                )
            
            Spacer().frame(height: 16)
            
        }.padding()
            .frame(maxWidth: .infinity)
    }
}

