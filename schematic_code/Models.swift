//
//  Models.swift
//  ScanitPackit
//
//  Created by Daniellia Sumigar on 3/26/24.
//

import Foundation

struct PackingData: Hashable, Decodable {
    let bin: String
    let fitted_items: [Fitted_Items]
    let residual_volume: Double
    let space_utilization: String
    let unfitted_items: [Unfitted_Items]
    let unpack_item_volume: Double
    let used_time: Double
    
}

struct Fitted_Items: Hashable, Decodable {
    let dimensions: [String]
    let partno: String
    let position: [String]
    let rotation_type: Int
    let volume: String
    let weight: String
}

struct Unfitted_Items: Hashable, Decodable {
    let dimensions: [String]
    let partno: String
    let volume: String
    let weight: String
}
