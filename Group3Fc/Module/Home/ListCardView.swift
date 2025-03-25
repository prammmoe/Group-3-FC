//
//  ListCardView.swift
//  Group3Fc
//
//  Created by Filza Rizki Ramadhan on 25/03/25.
//

import SwiftUI

struct ListCardView: View {
    let title:String
    let month:String?
    @Binding var dataBorrower: [Borrower]
    var body: some View {
        if !dataBorrower.isEmpty{
            Section{
                VStack(spacing: 16){
                    HStack{
                        Text(title).font(.callout).fontWeight(.bold)
                        Spacer()
                        Text(month ?? "").font(.callout).fontWeight(.bold).foregroundColor(Color("Primary"))
                    }.frame(maxWidth: .infinity)
                    VStack(spacing: 12){
                        ForEach(dataBorrower){
                            borrower in
                            NavigationLink (destination: DetailDebtorView(borrower: borrower)) {
                                CardView(borrower: borrower)
                            }
                        }
                    }.frame(maxWidth: .infinity)
                }.frame(maxWidth: .infinity).padding()
            }.listRowInsets(EdgeInsets())
        }
    }
}

 
