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
    @Query(sort: \Borrower.nextDueDate)  var borrowers: [Borrower]
    
    @Query(filter: #Predicate<Borrower> { $0.totalDebtAmount > 0 })
    private var activeBorrowers: [Borrower]
    @State private var totalDebt:Double? = 0.0
    @State private var showAddHutang:Bool = false
    @State private var thisWeekMonthYear: String = ""
    @State private var nextWeekMonthYear: String = ""
    @State private var thisWeekBorrowers: [Borrower] = []
    @State private var nextWeekBorrowers: [Borrower] = []
    @State private var otherBorrowers: [Borrower] = []
    var body: some View {
        NavigationStack(){
            ScrollView(){
                Spacer().frame(height: 30)
                Section{
                    ZStack{
                        VStack(){
                            Spacer()
                        }.padding().frame(maxWidth: .infinity, maxHeight: .infinity).background(Color("Primary").ignoresSafeArea()).clipShape(.rect(bottomLeadingRadius: 20, bottomTrailingRadius: 20))
                        HeaderCardView(totalDebt: $totalDebt, tagihanTerdekat: borrowers.first?.nextDueDate, totalUtang: activeBorrowers.count).onAppear{
                            totalDebt = activeBorrowers.reduce(0) { $0 + $1.totalDebtAmount }
                        }
                    }.frame(maxWidth: .infinity)
                }.listRowInsets(EdgeInsets())
                ListCardView(title: "Minggu Ini", month: thisWeekMonthYear, dataBorrower: $thisWeekBorrowers)
                ListCardView(title: "Minggu Depan",month: nextWeekMonthYear, dataBorrower: $nextWeekBorrowers )
                ListCardView(title: "Utang Lainnya", month: nil,  dataBorrower: $otherBorrowers)
            }.onAppear(){
                if let thisWeek = getMonthYear(forWeekOffset: 0) {
                                thisWeekMonthYear = thisWeek
                            }
                            if let nextWeek = getMonthYear(forWeekOffset: 1) {
                                nextWeekMonthYear = nextWeek
                            }
            groupDataByDate()
            } .listStyle(.plain).listRowSeparator(.automatic).background(Color("bgGray"))
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
            AddDebtView().onDisappear(){
                totalDebt = activeBorrowers.reduce(0) { $0 + $1.totalDebtAmount }
                groupDataByDate()
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
    func groupDataByDate(){
        let calendar = Calendar.current
        let today = Date()
         
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: today)!.start
         
        let startOfNextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: startOfWeek)!
         
        let startOfFollowingWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: startOfNextWeek)!
         
        thisWeekBorrowers = activeBorrowers.filter { borrower in
            borrower.nextDueDate >= startOfWeek && borrower.nextDueDate < startOfNextWeek
        }
        
        nextWeekBorrowers = activeBorrowers.filter { borrower in
            borrower.nextDueDate >= startOfNextWeek && borrower.nextDueDate < startOfFollowingWeek
        }
        
        otherBorrowers = activeBorrowers.filter { borrower in
            borrower.nextDueDate >= startOfFollowingWeek
        }
    }
    func getMonthYear(forWeekOffset weekOffset: Int) -> String? {
        let calendar = Calendar.current
        let today = Date()
        if let targetWeek = calendar.date(byAdding: .weekOfYear, value: weekOffset, to: today),
           let weekInterval = calendar.dateInterval(of: .weekOfYear, for: targetWeek) {
            let startOfWeek = weekInterval.start
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM yyyy"
            dateFormatter.locale = Locale(identifier: "id_ID")
            return dateFormatter.string(from: startOfWeek)
        }
        return nil
    }
}

#Preview {
    HomeView()
}

 

