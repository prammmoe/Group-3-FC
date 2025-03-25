//
//  HomeBorrowerCard.swift
//  Group3Fc
//
//  Created by Mario Pandapotan Simarmata on 25/03/25.
//

import SwiftUI

struct HomeBorrowerCard:View {
    let borrower: Borrower
    var body: some View {
        HStack(){
            HStack(spacing: 16){
                VStack(spacing: 2){
                    Text(borrower.nextDueDate.formatted(.dateTime.weekday()
                        .locale(Locale(identifier: "id_ID"))
                        )
                    )
                    .font(.caption2).fontWeight(.bold)
                    .foregroundColor(ConstantColors.black)
                    
                    VStack{
                        VStack{
                            Spacer()
                        }.frame(width: .infinity,height: 6)
                        
                        VStack{
                            Text(borrower.nextDueDate.formatted(.dateTime.day()))
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundStyle(ConstantColors.black)
                        }.padding(.horizontal,8)
                            .padding(.vertical, 6)
                            .overlay(Rectangle().stroke(
                                Color.gray, lineWidth: 1),
                                     alignment: .top)
                        
                    }.background(ConstantColors.blueTint)
                        .cornerRadius(9)
                        .overlay( RoundedRectangle(
                            cornerRadius: 6)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    
                }
                Divider().background(ConstantColors.greyBackground)
                
                Text(borrower.name)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(ConstantColors.black)
                
            }
            Spacer()
            
            HStack(spacing: 12){
                VStack(alignment: .trailing){
                    Text("Tersisa")
                        .font(.caption2)
                        .foregroundColor(ConstantColors.greyTextShade)
                    
                    Text(borrower.totalDebtAmount, format: .currency(code: "IDR"))
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(ConstantColors.primary)
                    
                }
                Image(systemName: "chevron.right")
                    .font(.system(size: 12.5, weight: .bold))
                    .foregroundColor(ConstantColors.grey)
                
            }

        }.padding(16)
            .background(.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1),
                    radius: 1, x: 0, y: 1)
    }
}
 
#Preview {
    HomeBorrowerCard(borrower: Borrower(name: "String", nextDueDate: Date(), debts: []))
}
