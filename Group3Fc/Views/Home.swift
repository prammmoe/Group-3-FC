//
//  Home.swift
//  PiutangApp
//
//  Created by Filza Rizki Ramadhan on 21/03/25.
//

import SwiftUI

struct Home: View {
    @State private var showAddHutang:Bool = false
    var body: some View {
        NavigationStack(){
            ScrollView(){
                Spacer().frame(height: 30)
                Section{
                    ZStack{
                        VStack(){
                            Spacer()
                        }.padding().frame(maxWidth: .infinity, maxHeight: .infinity).background(Color("Primary").ignoresSafeArea()).clipShape(.rect(bottomLeadingRadius: 20, bottomTrailingRadius: 20))
                        HeaderCard()
                    }.frame(maxWidth: .infinity)
                }.listRowInsets(EdgeInsets())
                Section{
                    VStack(spacing: 16){
                        HStack{
                            Text("Utang Aktif").font(.callout).fontWeight(.bold)
                            Spacer()
                            Text("Maret 2025").font(.callout).fontWeight(.bold).foregroundColor(Color("Primary"))
                        }.frame(maxWidth: .infinity)
                        VStack(spacing: 12){
                            Card()
                            Card()
                            Card()
                        }.frame(maxWidth: .infinity)
                    }.frame(maxWidth: .infinity).padding()
                }.listRowInsets(EdgeInsets())
                Section{
                    VStack(spacing: 16){
                        HStack{
                            Text("Utang Aktif").font(.callout).fontWeight(.bold)
                            Spacer()
                            Text("Maret 2025").font(.callout).fontWeight(.bold).foregroundColor(Color("Primary"))
                        }.frame(maxWidth: .infinity)
                        VStack(spacing: 12){
                            Card()
                            Card()
                            Card()
                        }.frame(maxWidth: .infinity)
                    }.frame(maxWidth: .infinity).padding()
                }.listRowInsets(EdgeInsets())
                
            }.listStyle(.plain).listRowSeparator(.automatic).background(Color("bgGray"))
           
            
        }.toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                HStack{
                    Button(action: {}){
                        Image(systemName: "arrow.up.arrow.down.circle").resizable().frame(width: 24, height: 24).foregroundColor(Color("Primary"))
                    }
                   
                    Spacer()
                    Button(action:{
                        showAddHutang = true
                    }){
                        Image(systemName: "plus.circle").frame(width: 24, height: 24).foregroundColor(Color("Primary"))
                    }
                }
            }
        }
        .sheet(isPresented: $showAddHutang) {
            addHutang()
        }
    }
}

#Preview {
    Home()
}


struct HeaderCard:View {
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text("Dashboard").font(.largeTitle).fontWeight(.bold).foregroundColor(.white)
                Spacer()
            }
            VStack(alignment: .leading, spacing: 12){
                Text("Total Sisa Utang").foregroundColor(Color("textSecondary")).font(.caption)
                Text("Rp 720.000").foregroundColor(Color("textPrimary")).font(.title).fontWeight(.bold)
                HStack{
                    HStack(spacing:4){
                        Text("Kamu punya").font(.caption).foregroundColor(.primary)
                        Text("3").font(.caption).foregroundColor(Color("textYellow")).fontWeight(.bold)
                        Text("Utang Aktif!").font(.caption).foregroundColor(.primary).fontWeight(.bold)
                    }.padding(.horizontal,8).padding(.vertical, 4).background(Color("bgGray")).overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("textYellow"), lineWidth: 1))
                    Spacer()
                    VStack(alignment: .trailing){
                        Text("Tagihan terdekat").font(.caption2).foregroundColor(.gray).multilineTextAlignment(.trailing)
                        Text("Selasa, 26 Feb 2025").font(.footnote).multilineTextAlignment(.trailing).foregroundColor(Color("Primary")).fontWeight(.bold)
                    }
                }
            }.frame(maxWidth: .infinity).padding().background(.white).cornerRadius(16).shadow(color: Color.black.opacity(0.4), radius: 4, x: 0, y: 4)
            Spacer().frame(height: 16)
        }.padding().frame(maxWidth: .infinity)
    }
}

