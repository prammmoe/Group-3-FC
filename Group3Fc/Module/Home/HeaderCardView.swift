//
//  HeaderCardView.swift
//  Group3Fc
//
//  Created by Filza Rizki Ramadhan on 25/03/25.
//

import SwiftUI

struct HeaderCardView: View {
    @Binding var totalDebt: Double?
    @State var tagihanTerdekat: Date?
    @State var totalUtang: Int
    var formattedDate: String {
            guard let date = tagihanTerdekat else { return "Belum ada tagihan" }
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "id_ID")
            formatter.dateFormat = "EEEE, dd MMM yyyy"
            return formatter.string(from: date)
    }
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text("Dashboard").font(.largeTitle).fontWeight(.bold).foregroundColor(.white)
                Spacer()
            }
            VStack(alignment: .leading, spacing: 12){
                Text("Total Sisa Utang").foregroundColor(Color("textSecondary")).font(.caption)
                Text(abs(totalDebt ?? 0.0), format: .currency(code: "IDR")).foregroundColor(Color("BlueShade")).font(.title).fontWeight(.bold)
                HStack{
                    HStack(spacing:4){
                        Text("Kamu punya").font(.caption).foregroundColor(.primary)
                        Text("\(totalUtang)").font(.caption).foregroundColor(Color("Secondary")).fontWeight(.bold)
                        Text("Utang Aktif!").font(.caption).foregroundColor(.primary).fontWeight(.bold)
                    }.padding(.horizontal,8).padding(.vertical, 4).background(Color("blueTint")).overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("Secondary"), lineWidth: 1))
                    Spacer()
                    VStack(alignment: .trailing){
                        Text("Tagihan terdekat").font(.caption2).foregroundColor(.gray).multilineTextAlignment(.trailing)
                        Text(formattedDate).font(.footnote).multilineTextAlignment(.trailing).foregroundColor(Color("Primary")).fontWeight(.bold)
                    }
                }
            }.frame(maxWidth: .infinity).padding().background(.white).cornerRadius(16).shadow(color: Color.black.opacity(0.4), radius: 4, x: 0, y: 4)
            Spacer().frame(height: 16)
        }.padding().frame(maxWidth: .infinity)
    }
}
 
