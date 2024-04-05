//
//  Item.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 05.04.2024.
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
