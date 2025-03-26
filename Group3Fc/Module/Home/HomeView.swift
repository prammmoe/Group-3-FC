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
    @State private var nextDueDate: Date?
    @State private var thisWeekMonthYear: String = ""
    @State private var nextWeekMonthYear: String = ""
    @State private var thisWeekBorrowers: [Borrower] = []
    @State private var nextWeekBorrowers: [Borrower] = []
    @State private var otherBorrowers: [Borrower] = []
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(resource: .primary)
        let backItemAppearance = UIBarButtonItemAppearance()
        backItemAppearance.normal.titleTextAttributes = [.foregroundColor : UIColor.white]
        appearance.backButtonAppearance = backItemAppearance
        let image = UIImage(systemName: "chevron.backward")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        appearance.setBackIndicatorImage(image, transitionMaskImage: image)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = .white
    }
    var body: some View {
        NavigationStack(){
            ScrollView(){
                Section{
                    ZStack{
                        VStack(){
                            Spacer()
                        }.padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(ConstantColors.primary.ignoresSafeArea())
                            .clipShape(.rect(bottomLeadingRadius: 20, bottomTrailingRadius: 20))
                        
                        HeaderCard(totalDebt: $totalDebt,
                                   tagihanTerdekat: $nextDueDate,
                                   totalUtang: activeBorrowers.count
                        )
                        .onAppear{
                            totalDebt = borrowers.reduce(0) { $0 + $1.totalDebtAmount }
                            nextDueDate = activeBorrowers.sorted { $0.nextDueDate < $1.nextDueDate }.first?.nextDueDate
                        }
                        
                    }.frame(maxWidth: .infinity)
                    
                }.listRowInsets(EdgeInsets())
                
                HomeListView(title: "Minggu Ini",
                             month: thisWeekMonthYear,
                             dataBorrower: $thisWeekBorrowers)
                HomeListView(title: "Minggu Depan",
                             month: nextWeekMonthYear,
                             dataBorrower: $nextWeekBorrowers )
                HomeListView(title: "Utang Lainnya",
                             month: nil,
                             dataBorrower: $otherBorrowers)
                
            }.onAppear(){
                if let thisWeek = getMonthYear(forWeekOffset: 0) {
                    thisWeekMonthYear = thisWeek
                }
                if let nextWeek = getMonthYear(forWeekOffset: 1) {
                    nextWeekMonthYear = nextWeek
                }
                groupDataByDate()
            }
            .listStyle(.plain)
            .listRowSeparator(.automatic)
            .background(ConstantColors.greyBackground)
            
        }
        .navigationTitle("Dashboard")
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                HStack{
                    
                    Spacer()
                    
                    Button(action:{
                        showAddHutang = true
                    })
                    {
                        Image(systemName: "plus.circle").frame(width: 24, height: 24).foregroundColor(Color("Primary"))
                    }
                    
                }
            }
        }
        .sheet(isPresented: $showAddHutang) {
            AddDebtView()
                .onDisappear() {
                    totalDebt = borrowers.reduce(0) { $0 + $1.totalDebtAmount }
                    nextDueDate = activeBorrowers.sorted { $0.nextDueDate < $1.nextDueDate }.first?.nextDueDate
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
    func groupDataByDate() {
        let calendar = Calendar.current
        let today = Date()
        
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: today)!.start
        let startOfNextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: startOfWeek)!
        let startOfFollowingWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: startOfNextWeek)!
        
        thisWeekBorrowers = activeBorrowers
            .filter { borrower in
                borrower.nextDueDate >= startOfWeek && borrower.nextDueDate < startOfNextWeek
            }
            .sorted { $0.nextDueDate < $1.nextDueDate }
        
        nextWeekBorrowers = activeBorrowers
            .filter { borrower in
                borrower.nextDueDate >= startOfNextWeek && borrower.nextDueDate < startOfFollowingWeek
            }
            .sorted { $0.nextDueDate < $1.nextDueDate }
        
        otherBorrowers = activeBorrowers
            .filter { borrower in
                borrower.nextDueDate >= startOfFollowingWeek
            }
            .sorted { $0.nextDueDate < $1.nextDueDate }
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

