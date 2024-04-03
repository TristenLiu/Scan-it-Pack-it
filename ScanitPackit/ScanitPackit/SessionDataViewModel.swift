//
//  SessionDataViewModel.swift
//  ScanitPackit
//
//  Created by Tristen Liu on 4/2/24.
//

import Foundation
import SwiftUI
import Combine

class SessionDataViewModel: ObservableObject {
    @Published var SessionDataList: [SessionData] = []

    init() {
        loadSavedSessions()
    }

    private func loadSavedSessions() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            // open file directory and get SessionData URLs
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
            let sessionFiles = fileURLs.filter { $0.lastPathComponent.starts(with: "SessionData-") }
            
            // decode all files into SessionData types
            let sessions = sessionFiles.compactMap { url -> SessionData? in
                guard let data = try? Data(contentsOf: url) else { return nil }
                return try? JSONDecoder().decode(SessionData.self, from: data)
            }
            
            // sort list by date
            self.SessionDataList = sessions.sorted(by: { $0.saveDate > $1.saveDate })
        } catch {
            print("Error loading saved sessions: \(error)")
        }
    }
    
    func deleteSession(at index: Int) {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let session = SessionDataList[index]
            
            let fileURL = documentsDirectory.appendingPathComponent("SessionData-\(session.id.uuidString).json")

            do {
                try FileManager.default.removeItem(at: fileURL)
                SessionDataList.remove(at: index)
                print("Removed session")
            } catch {
                print("Failed to delete session: \(error)")
            }
        }
}
