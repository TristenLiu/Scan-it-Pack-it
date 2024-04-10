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
    case inches = "in"
    case cm = "cm"
    
    var id: String { self.rawValue }
}

class Dimensions: ObservableObject {
    static let shared = Dimensions()
    
    @Published var containerDims: [[Float]] = [[0,0,0]]
    @Published var boxDims: [[Float]] = [] {
        didSet {
//            roundDimensions()
        }
    }
    @Published var selectedRoundingOption: RoundingOption = .none {
        didSet {
//            roundDimensions()
        }
    }
    @Published var measurementUnit: MeasurementUnit = .cm
    
    var containerCount: Int {
        return containerDims.count
    }
    
    func removeCDims(at index: Int) {
        containerDims.remove(at: index)
    }
    
    func removeBDims(at index: Int) {
        boxDims.remove(at: index)
    }
    
//    private func roundDimensions() {
//        boxDims = boxDims.map { dimensionSet in
//            boxDims.map { dimension in
//                roundDimension(dimension, roundingOption: selectedRoundingOption)
//            }
//        }
//    }
    
//    private func roundDimension(_ dimension: Float, roundingOption: RoundingOption) -> Float {
//        switch roundingOption {
//        case .none:
//            return dimension
//        case .quarter, .half, .one:
//            // convert to inches if unit is in inches
//            let dimensionInTargetUnit: Float = self.measurementUnit == .inches ? dimension / 2.54 : dimension
//            let roundingInterval = roundingOption.rawValue
//            let roundedValue = round(Double(dimensionInTargetUnit) / roundingInterval) * roundingInterval
//            
//            // convert back to cm for data storage if unit is in inches
//            let roundedDimension: Float = self.measurementUnit == .inches ? Float(roundedValue) * 2.54 : Float(roundedValue)
//
//            return Float(roundedValue)
//        }
//    }
    
    func convertDimensions(_ dimensions: [Float]) -> [Float] {
        switch measurementUnit {
        case .inches:
            return dimensions.map { $0 / 2.54 }
        case .cm:
            return dimensions
        }
    }
}
