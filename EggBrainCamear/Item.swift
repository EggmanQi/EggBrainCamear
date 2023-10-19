//
//  Item.swift
//  EggBrainCamear
//
//  Created by P on 2023/10/19.
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
