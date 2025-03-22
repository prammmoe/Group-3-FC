//
//  Item.swift
//  Group3Fc
//
//  Created by Filza Rizki Ramadhan on 22/03/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
