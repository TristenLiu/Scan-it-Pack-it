//
//  ViewModel.swift
//  ScanitPackit
//
//  Created by Daniellia Sumigar on 3/23/24.
//

import Foundation

class ViewModel: ObservableObject {
    @Published var packing_data: [PackingData]?
    @Published var minimum_container: MinimumContainerData?

    func fetch(with dimensionsList: Dimensions) {
        guard let url = URL(string: "https://scanit-packit-51bb1a0d2371.herokuapp.com/packing/") else {
            return
        }
        
        var jsonItems: [[String: Any]] = []
        
        // Create JSON items from dimensionsList
        for (index, dimensions) in dimensionsList.boxDims.enumerated() {
            // priority toggled on = pack according to order
            if (dimensionsList.priorityToggle) {
                let item: [String: Any] = [
                    "partno": "\(index + 1)",
                    "name": "Item \(index + 1)",
                    "typeof": "cube",
                    "width": dimensions[0],
                    "height": dimensions[1],
                    "depth": dimensions[2],
                    "weight": 1,
                    "level": index,
                    "loadbear": 100,
                    "updown": true
                ]
                jsonItems.append(item)
            } else {
            // priority toggled off = default packing mode
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
            
        }
        
        // Create JSON containers
        var jsonContainers: [[String: Any]] = []
        for (index, dimensions) in dimensionsList.containerDims.enumerated() {
            let container: [String: Any] = [
                "bin": "Container \(index + 1)",
                "bin_name": "Container \(index + 1)",
                "width": dimensions[0], // Assuming width is at index 0
                "height": dimensions[1], // Assuming height is at index 1
                "depth": dimensions[2] // Assuming depth is at index 2
            ]
            jsonContainers.append(container)
        }
        
        let jsonObject: [String: Any] = [
            "bins": jsonContainers,
            "items": jsonItems
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            //print(jsonObject)
            
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
                    let packing_data = try JSONDecoder().decode([PackingData].self, from: data)
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
    
    func findMinimumContainerSize(with dimensionsList: Dimensions) {
        guard let url = URL(string: "https://scanit-packit-51bb1a0d2371.herokuapp.com/find_minimum_container/") else {
            return
        }
        
        var jsonItems: [[String: Any]] = []
        
        for (index, dimensions) in dimensionsList.boxDims.enumerated() {
            let item: [String: Any] = [
                "partno": "\(index + 1)",
                "name": "Item \(index + 1)",
                "typeof": "cube",
                "width": dimensions[0],
                "height": dimensions[1],
                "depth": dimensions[2],
                "weight": 1,
                "level": index,
                "loadbear": 100,
                "updown": true
            ]
            jsonItems.append(item)
            
            let jsonObject: [String: Any] = [
                "items": jsonItems
            ]
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
                //print(jsonObject)
                
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
                        let minimum_container = try JSONDecoder().decode(MinimumContainerData.self, from: data)
                        DispatchQueue.main.async {
                            self?.minimum_container = minimum_container
                            print(minimum_container)
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
}
