//
//  HistoryPaymentEmptyState.swift
//  Group3Fc
//
//  Created by Mario Pandapotan Simarmata on 24/03/25.
//
import SwiftUI

struct HistoryPaymentCardEmptyState: View {

    var body: some View{
        VStack(spacing: 8){
            Spacer().frame(height: 50)
            Image(systemName: "pencil.and.list.clipboard")
                .font(.system(size: 80))
                .foregroundStyle(ConstantColors.blueShade)
            
            Text("Tidak ada utang")
                .foregroundStyle(ConstantColors.blueShade)
        }
    }
}

#Preview(){
    HistoryPaymentCardEmptyState()
}
