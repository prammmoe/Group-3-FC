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
            HStack(spacing: 8){
                VStack(spacing: 2){
                    Text(borrower.nextDueDate.formatted(.dateTime.weekday())).font(.caption2).fontWeight(.bold).foregroundColor(.black)
                    VStack{
                        VStack{
                            Spacer()
                        }.frame(width: .infinity,height: 8)
                        VStack{
                            Text(borrower.nextDueDate.formatted(.dateTime.day())).font(.headline)
                        }.padding(.horizontal,8).padding(.vertical, 6).overlay(
                            Rectangle().stroke(Color.gray, lineWidth: 1),
                            alignment: .top
                        )
                    }.background(Color("blueTint")).cornerRadius(9).overlay(
                        RoundedRectangle(cornerRadius: 9)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                }
                Divider().background(ConstantColors.greyBackground)
                Text(borrower.name).font(.subheadline).fontWeight(.bold)
            }
            Spacer()
            HStack(spacing: 12){
                VStack(alignment: .trailing){
                    Text("Tersisa").font(.caption2).foregroundColor(.gray)
                    Text(borrower.totalDebtAmount, format: .currency(code: "IDR")).font(.body).fontWeight(.bold).foregroundColor(Color("Primary"))
                }
                Image(systemName: "chevron.right").font(.system(size: 12.5, weight: .bold)).foregroundColor(.gray)
            }
         
        }.padding(16).background(.white).cornerRadius(12).shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
    }
}
 
