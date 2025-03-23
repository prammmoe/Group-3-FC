//
//  DetailDebtorViewModel.swift
//  Group3Fc
//
//  Created by Mario Pandapotan Simarmata on 22/03/25.
//
import Foundation

class DetailDebtorViewModel:ObservableObject {
    
    func formatToThousandSeparator(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "." // Gunakan titik sebagai pemisah ribuan
        formatter.locale = Locale(identifier: "id_ID") // Menggunakan format Indonesia
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}
