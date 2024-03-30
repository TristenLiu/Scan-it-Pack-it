//
//  ViewModel.swift
//  testPackingData
//
//  Created by Daniellia Sumigar on 3/23/24.
//

import Foundation

class ViewModel: ObservableObject {
    @Published var packing_data: PackingData?

    func fetch() {
        guard let url = URL(string: "https://scanit-packit-51bb1a0d2371.herokuapp.com/") else {
            return
        }
        
        // Sample input JSON
        let jsonData = """
            {
                "bin_dimensions": {
                    "width": 20,
                    "height": 20,
                    "depth": 20
                },
                "items": [
                    {
                        "partno": "1",
                        "name": "Item 1",
                        "typeof": "cube",
                        "width": 10,
                        "height": 15,
                        "depth": 20,
                        "weight": 1,
                        "level": 1,
                        "loadbear": 100,
                        "updown": true
                    },
                    {
                        "partno": "2",
                        "name": "Item 2",
                        "typeof": "cube",
                        "width": 10,
                        "height": 20,
                        "depth": 10,
                        "weight": 1,
                        "level": 1,
                        "loadbear": 100,
                        "updown": true
                    },
                    {
                        "partno": "3",
                        "name": "Item 3",
                        "typeof": "cube",
                        "width": 10,
                        "height": 5,
                        "depth": 5,
                        "weight": 1,
                        "level": 1,
                        "loadbear": 100,
                        "updown": true
                    },
                    {
                        "partno": "4",
                        "name": "Item 4",
                        "typeof": "cube",
                        "width": 10,
                        "height": 20,
                        "depth": 10,
                        "weight": 1,
                        "level": 1,
                        "loadbear": 100,
                        "updown": true
                    },
                    {
                        "partno": "5",
                        "name": "Item 5",
                        "typeof": "cube",
                        "width": 10,
                        "height": 5,
                        "depth": 15,
                        "weight": 1,
                        "level": 1,
                        "loadbear": 100,
                        "updown": true
                    },
                    {
                        "partno": "6",
                        "name": "Item 6",
                        "typeof": "cube",
                        "width": 10,
                        "height": 5,
                        "depth": 15,
                        "weight": 1,
                        "level": 1,
                        "loadbear": 100,
                        "updown": true
                    }
                ]
            }
            
            """.data(using: .utf8)
        
        
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
                    //print(packing_data)
                }
                
            } catch {
                print("Failed to decode JSON:", error)
            }
        }
        
        // Start API call
        task.resume()
    }

}
