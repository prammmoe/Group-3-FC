//
//  addHutang.swift
//  Group3Fc
//
//  Created by Filza Rizki Ramadhan on 22/03/25.
//

import SwiftUI

struct addHutang: View {
    @Environment(\.dismiss) var dismiss
    @State var nama:String = ""
    @State var tanggalTagih = Date()
    @State var tanggalUtang = Date()
    @State private var catatan:String = ""
    var body: some View {
        NavigationView{
            ScrollView(){
                VStack(alignment: .leading, spacing: 16){
                    Text("Tambah Utang").font(.largeTitle).fontWeight(.bold).foregroundColor(Color("textPrimary"))
                    VStack(){
                        HStack{
                            Text("Nama").font(.subheadline)
                            Spacer()
                            Spacer()
                            TextField("Masukkan nama", text: $nama)
                                .frame(maxWidth: UIScreen.main.bounds.width * 0.5).font(.subheadline).multilineTextAlignment(.trailing)
                        }.padding(.vertical, 16)
                        Divider()
                        HStack{
                            Text("Jumlah").font(.subheadline)
                            Spacer()
                            Spacer()
                            TextField("Rp.0", text: $nama)
                                .frame(maxWidth: UIScreen.main.bounds.width * 0.5).font(.subheadline).multilineTextAlignment(.trailing)
                        }.padding(.vertical, 16)
                        Divider()
                        HStack{
                            Text("Tanggal Tagih").font(.subheadline)
                            Spacer()
                            Spacer()
                            DatePicker(
                                    "",
                                    selection: $tanggalTagih,       displayedComponents: [.date]
                                ).labelsHidden()
                        }.padding(.vertical, 16)
                        Divider()
                        HStack{
                            Text("Tanggal Utang").font(.subheadline)
                            Spacer()
                            Spacer()
                            DatePicker(
                                    "",
                                    selection: $tanggalUtang,       displayedComponents: [.date]
                                ).labelsHidden()
                        }.padding(.vertical, 16)
                    }.padding(.horizontal, 16).background(.white).cornerRadius(8)
                    VStack(alignment: .leading){
                        Text("Catatan").font(.subheadline)
                        TextEditor(text: $catatan).font(.subheadline).frame(height: 150)
                    }.padding().background(.white).cornerRadius(8)
                }
            }.padding().frame(maxWidth: .infinity).background(Color("bgGray"))
                .toolbar{
                    ToolbarItemGroup(placement: .topBarLeading){
                        Button(action: {
                            dismiss()
                        }){
                            Text("Batal").font(.body)
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing){
                        Text("Simpan").font(.body).foregroundColor(Color("Primary"))
                    }
                }
        }
        
    }
}

#Preview {
    addHutang()
}
