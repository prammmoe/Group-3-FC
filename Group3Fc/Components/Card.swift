//
//  Card.swift
//  PiutangApp
//
//  Created by Filza Rizki Ramadhan on 21/03/25.
//

import SwiftUI

struct Card:View {
    var body: some View {
        HStack(){
            HStack(spacing: 8){
                VStack(spacing: 2){
                    Text("Selasa").font(.caption2).fontWeight(.bold).foregroundColor(.black)
                    VStack{
                        VStack{
                            Spacer()
                        }.frame(width: .infinity,height: 8)
                        VStack{
                            Spacer()
                            Text("06").font(.headline)
                            Spacer()
                        }.padding(.horizontal, 10).overlay(
                            Rectangle().stroke(Color.gray, lineWidth: 1),
                            alignment: .top
                        )
                    }.background(Color("blueTint")).cornerRadius(9).overlay(
                        RoundedRectangle(cornerRadius: 9)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                }
                Divider().background(ConstantColors.greyBackground)
                Text("Mario").font(.subheadline).fontWeight(.bold)
            }
            Spacer()
            HStack(spacing: 12){
                VStack(alignment: .trailing){
                    Text("Tersisa").font(.caption2).foregroundColor(.gray)
                    Text("Rp 70.000").font(.body).fontWeight(.bold).foregroundColor(Color("textPrimary"))
                }
                Image(systemName: "chevron.right").font(.system(size: 12.5, weight: .bold)).foregroundColor(.gray)
            }
         
        }.padding(16).background(.white).cornerRadius(12).shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
    }
}

#Preview {
    Card()
}
