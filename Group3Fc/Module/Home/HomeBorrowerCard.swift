//
//  HomeBorrowerCard2.swift
//  Group3Fc
//
//  Created by Mario Pandapotan Simarmata on 31/03/25.
//

import SwiftUI

struct HomeBorrowerCard: View {
    let borrower: Borrower
    
    var body: some View {
        HStack {
            HStack (spacing: 16){
                VStack(spacing: 2){
                    Text(borrower.nextDueDate.formatted(.dateTime.weekday()
                        .locale(Locale(identifier: "id_ID"))
                        )).font(.caption2)
                        .foregroundStyle(ConstantColors.black)
                    
                    VStack (spacing: 0){
                        HStack { Spacer()
                            Circle().frame(width: 4,height: 4)
                            Spacer()
                            Circle().frame(width: 4,height: 4)
                            Spacer()
                        }.frame(width:45, height: 10)
                            .foregroundStyle(ConstantColors.white)
                            .background(ConstantColors.primary)
                        
                        HStack {
                            Text(borrower.nextDueDate.formatted(.dateTime.day()))
                              .font(.body)
                              .foregroundStyle(ConstantColors.black)
                              .frame( maxHeight: .infinity)
                        }.frame(maxWidth: .infinity)
                            .background(ConstantColors.greyBackground)
                        
                    }.frame(width: 45,height: 45)
                        .clipShape(RoundedRectangle(cornerRadius: 6))

                    
                }

                Divider().frame(maxHeight: 60)
                
                Text(borrower.name)
                    .font(.headline)
                    .foregroundStyle(ConstantColors.black)

            }.frame(maxWidth: .infinity,alignment: .leading)
            
            HStack(spacing: 12){
                VStack(alignment: .trailing){
                    Text("Tersisa")
                        .font(.caption2)
                        .foregroundColor(ConstantColors.greyTextShade)
                    
                    Text(borrower.totalDebtAmount, format: .currency(code: "IDR"))                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.blueShade)
                    
                }
                Image(systemName: "chevron.right")
                    .font(.system(size: 12.5, weight: .bold))
                    .foregroundColor(ConstantColors.grey)
                
            }
        }
            .frame(height:80)
            .padding(.vertical,8)
            .padding(.horizontal, 16)
            .background(ConstantColors.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: Color.black.opacity(0.1),
                    radius: 1, x: 0, y: 1)

    }
}

#Preview {
    HomeBorrowerCard(borrower: Borrower(name: "String", nextDueDate: Date(), debts: []))
}
