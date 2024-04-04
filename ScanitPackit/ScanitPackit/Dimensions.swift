//
//  Dimensions.swift
//  ScanitPackit
//
//  Created by Tristen Liu on 3/29/24.
//

import Foundation
import Combine

enum RoundingOption: Double, CaseIterable, Identifiable {
    case none = 0
    case quarter = 0.25
    case half = 0.5
    case one = 1.0
    
    var id: Double { self.rawValue }
    
    var description: String {
        switch self {
        case .none: return "None"
        case .quarter: return "0.25"
        case .half: return "0.5"
        case .one: return "1.0"
        }
    }
}

enum MeasurementUnit: String, CaseIterable, Identifiable {
    case inches = "Inches"
    case cm = "CM"
    
    var id: String { self.rawValue }
}

class Dimensions: ObservableObject {
    static let shared = Dimensions()
    
    @Published var dimensions: [[Float]] = []
    @Published var selectedRoundingOption: RoundingOption = .none
    @Published var measurementUnit: MeasurementUnit = .cm
    
    func removeDimensions(at index: Int) {
            dimensions.remove(at: index)
        }
    
    func convertDimensions(_ dimensions: [Float]) -> [Float] {
        switch measurementUnit {
        case .inches:
            return dimensions.map { $0 / 2.54 }
        case .cm:
            return dimensions
        }
    }
}
