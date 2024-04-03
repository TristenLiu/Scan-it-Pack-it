//
//  ViewModel.swift
//  ScanitPackit
//
//  Created by Daniellia Sumigar on 3/23/24.
//

import Foundation

class ViewModel: ObservableObject {
    @Published var packing_data: PackingData?

    func fetch(with dimensionsList: Dimensions) {
        guard let url = URL(string: "https://scanit-packit-51bb1a0d2371.herokuapp.com/") else {
            return
        }
        
        var jsonItems: [[String: Any]] = []
        
        // Create JSON items from dimensionsList
        for (index, dimensions) in dimensionsList.dimensions.dropFirst().enumerated() {
            
            let item: [String: Any] = [
                "partno": "\(index + 1)",
                "name": "Item \(index + 1)",
                "typeof": "cube",
                "width": dimensions[0],
                "height": dimensions[1],
                "depth": dimensions[2],
                "weight": 1,
                "level": 1,
                "loadbear": 100,
                "updown": true
            ]
            jsonItems.append(item)
        }
        
        let jsonObject: [String: Any] = [
            "bin_dimensions": [
                "width": dimensionsList.dimensions[0][0], // Assuming width is at index 0
                "height": dimensionsList.dimensions[0][1], // Assuming height is at index 1
                "depth": dimensionsList.dimensions[0][2] // Assuming depth is at index 2
            ],
            "items": jsonItems
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "Unknown error")
                    return
                }
                
                do {
                    let packing_data = try JSONDecoder().decode(PackingData.self, from: data)
                    DispatchQueue.main.async {
                        self?.packing_data = packing_data
                        print(packing_data)
                    }
                    
                } catch {
                    print("Failed to decode JSON:", error)
                }
            }
            
            // Start API call
            task.resume()
        } catch {
            print("Failed to serialize JSON:", error)
        }
    }
}
