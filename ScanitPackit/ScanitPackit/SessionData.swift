//
//  SessionData.swift
//  ScanitPackit
//
//  Created by Tristen Liu on 4/2/24.
//

import Foundation

struct SessionData: Codable, Identifiable {
    let id: UUID
    let dimensionsList: [[String]]
    let saveDate: Date
    let numberOfBoxes: Int
    
    init(dimensionsList: [[String]], saveDate: Date, numberOfBoxes: Int, id: UUID = UUID()) {
            self.dimensionsList = dimensionsList
            self.saveDate = saveDate
            self.numberOfBoxes = numberOfBoxes
            self.id = id
        }
}

extension SessionData {
    func save() {
        // find file system and create URL
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let saveURL = documentsDirectory.appendingPathComponent("SessionData-\(self.id.uuidString).json")

        do {
            // Convert struct to Data and Write to file system
            let data = try JSONEncoder().encode(self)
            try data.write(to: saveURL, options: .atomicWrite)
            print("Saved session to \(saveURL)")
        } catch {
            print("Failed to save session: \(error)")
        }
    }
}