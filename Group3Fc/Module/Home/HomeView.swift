//
//  Home.swift
//  PiutangApp
//
//  Created by Filza Rizki Ramadhan on 21/03/25.
//

import SwiftUI
import SwiftData
struct HomeView: View {
    @Environment(\.modelContext) private var context
    
    @Query(filter: #Predicate<Borrower> { $0.totalDebtAmount > 0 })
    private var borrowers: [Borrower]
    
    @State var totalDebt: Double = 0.0
    @State private var showAddHutang:Bool = false
    
    var body: some View {
        NavigationStack(){
            ScrollView(){
                Spacer().frame(height: 30)
                Section{
                    ZStack{
                        VStack(){
                            Spacer()
                        }.padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(ConstantColors.primary.ignoresSafeArea())
                            .clipShape(.rect(bottomLeadingRadius: 20, bottomTrailingRadius: 20))
                        
                        HeaderCard(totalDebt: $totalDebt )
                            .onAppear {
                                totalDebt = borrowers.reduce(0) { $0 + $1.totalDebtAmount }
                                print("Borrowers count onAppear: \(totalDebt)")
                            }
                           
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
                            ForEach(borrowers){
                                borrower in
                                NavigationLink (destination: DetailDebtorView(borrower: borrower)) {
                                    HomeBorrowerCard(borrower: borrower)
                                }
                            }
                        }.frame(maxWidth: .infinity)
                        
                    }.frame(maxWidth: .infinity)
                        .padding()
                    
                }.listRowInsets(EdgeInsets())
                
            }.listStyle(.plain)
                .listRowSeparator(.automatic)
                .background(ConstantColors.greyBackground)
            
        }
        .toolbar {
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
            AddDebtView()
                .onDisappear() {
                totalDebt = borrowers.reduce(0) { $0 + $1.totalDebtAmount }

                print("Borrowers count onAppear: \(totalDebt)")
            }
        }
    }
    
    func getTotalDebtAmount(context: ModelContext) -> Double {
        do {
            let allDebts = try context.fetch(FetchDescriptor<Debt>())
            return allDebts.reduce(0) { $0 + $1.amount }
        } catch {
            print("❌ Gagal mengambil data: \(error.localizedDescription)")
            return 0
        }
    }
}

#Preview {
    HomeView()
}

