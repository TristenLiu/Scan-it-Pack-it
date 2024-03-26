//
//  SchematicView.swift
//  ManualInput
//
//  Created by Daniellia Sumigar on 3/2/24.
//

import SwiftUI
import SceneKit

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

class ViewModel: ObservableObject {

    func fetch() {
        guard let url = URL(string: "http://127.0.0.1:5000") else {
            return
        }
        
        // Sample input JSON
        let jsonData = """
            {
                "bin_dimensions": {
                    "width": 10,
                    "height": 10,
                    "depth": 10
                },
                "items": [
                    {
                        "partno": "1",
                        "name": "Item 1",
                        "typeof": "cube",
                        "width": 3,
                        "height": 3,
                        "depth": 3,
                        "weight": 1,
                        "level": 1,
                        "loadbear": 100,
                        "updown": true
                    },
                    {
                        "partno": "2",
                        "name": "Item 2",
                        "typeof": "cube",
                        "width": 2,
                        "height": 2,
                        "depth": 2,
                        "weight": 1,
                        "level": 1,
                        "loadbear": 100,
                        "updown": true
                    },
                    {
                        "partno": "3",
                        "name": "Item 3",
                        "typeof": "cube",
                        "width": 4,
                        "height": 4,
                        "depth": 4,
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
                        "height": 5,
                        "depth": 8,
                        "weight": 1,
                        "level": 1,
                        "loadbear": 100,
                        "updown": true
                    },
                    {
                        "partno": "5",
                        "name": "Item 5",
                        "typeof": "cube",
                        "width": 6,
                        "height": 6,
                        "depth": 6,
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
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            do {
                let packing_data = try JSONDecoder().decode(PackingData.self, from: data)
                DispatchQueue.main.async {
                    print(packing_data)
                }
            } catch {
                print("Failed to decode JSON:", error)
            }
        }
        
        task.resume()
    }
}

struct SchematicView: View {
    
    var body: some View {
        VStack {
            SceneView(scene: createScene(), options: [.autoenablesDefaultLighting, .allowsCameraControl])
                .frame(width: UIScreen.main.bounds.width,
                       height: UIScreen.main.bounds.height / 2)
            .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height/2)
                .padding(0.0)
            
        }
    }
    
}

// Manually define input data:
var containerSize1: (width: CGFloat, height: CGFloat, length: CGFloat) = (20, 20, 20)

var sizes_1: [(width: CGFloat, height: CGFloat, length: CGFloat)] = [
    (10, 15, 20),
    (10, 20, 10),
    (10, 5, 5),
    (10, 20, 10),
    (10, 5, 15)
]

var positions: [(x: Float, y: Float, z: Float)] = [
    (0, 0, 0),
    (10, 0, 0),
    (0, 15, 15),
    (10, 0, 10),
    (0, 15, 0)
]

var colors: [UIColor] = [
    (UIColor.systemYellow),
    (UIColor.systemPink),
    (UIColor.systemBrown),
    (UIColor.systemCyan),
    (UIColor.systemPurple)
]

func createScene() -> SCNScene {
    // Creating the schematic:
    let scene = SCNScene()
    
    let combinedNode = createAndAddBoxes(containerSize: containerSize1, sizes: sizes_1, positions: positions, colors: colors)
    scene.rootNode.addChildNode(combinedNode)

    
    return scene
}

// CUSTOM Metal Shader - Generate the wireframe texture
    let sm = "float u = _surface.diffuseTexcoord.x; \n" +
    "float v = _surface.diffuseTexcoord.y; \n" +
    "int u100 = int(u * 100); \n" +
    "int v100 = int(v * 100); \n" +
    "if (u100 % 99 == 0 || v100 % 99 == 0) { \n" +
    "  // do nothing \n" +
    "} else { \n" +
    "    discard_fragment(); \n" +
    "} \n"

func createAndAddBoxes(containerSize: (width: CGFloat, height: CGFloat, length: CGFloat), sizes: [(width: CGFloat, height: CGFloat, length: CGFloat)], positions: [(x: Float, y: Float, z: Float)], colors: [UIColor]) -> SCNNode {
    let parentNode = SCNNode()
    
    let container = SCNBox(width: containerSize.width, height: containerSize.height, length: containerSize.length, chamferRadius: 0)
    
    container.firstMaterial?.diffuse.contents = UIColor.black
 
    container.firstMaterial?.shaderModifiers = [SCNShaderModifierEntryPoint.surface: sm]
    container.firstMaterial?.isDoubleSided = true
    let containerNode = SCNNode(geometry: container)
    
    containerNode.position = SCNVector3(0 + Float(containerSize.width / 2), 0 + Float(containerSize.height / 2), 0 + Float(containerSize.length / 2))
    
    parentNode.addChildNode(containerNode)
        
    for i in 0..<min(sizes.count, positions.count, colors.count) {
        let size = sizes[i]
        let position = positions[i]
        let color = colors[i]
        
        // Create SCNBox
        let box = SCNBox(width: size.width, height: size.height, length: size.length, chamferRadius: 0.0)
        let material = SCNMaterial()
        material.diffuse.contents = color
        material.transparency = 0.7
        box.materials = [material]
        
        // Create SCNNode with the box geometry
        let boxNode = SCNNode(geometry: box)

        let fadeInAction = SCNAction.fadeIn(duration: 1)
        let moveAction = SCNAction.move(to: SCNVector3(position.x + Float(size.width / 2), position.y + Float(size.height / 2), position.z + Float(size.length / 2)), duration: 0.5)
        

        let fadeInMoveSequence = SCNAction.sequence([SCNAction.wait(duration: Double(i) * 1.0), fadeInAction, moveAction])
                
        boxNode.runAction(fadeInMoveSequence)

        parentNode.addChildNode(boxNode)
                
        }
            
    return parentNode
}


#Preview {
    SchematicView()
}
