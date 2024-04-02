//
//  Dimensions.swift
//  ScanitPackit
//
//  Created by Tristen Liu on 3/29/24.
//

import Foundation
import Combine

class Dimensions: ObservableObject {
    static let shared = Dimensions()
    
    @Published var dimensions: [[String]] = []
    
    func removeDimensions(at index: Int) {
            dimensions.remove(at: index)
        }
}
