//
//  SchematicView.swift
//  ScanitPackit
//
//  Created by Daniellia Sumigar on 3/23/24.
//

import SwiftUI
import SceneKit

struct SchematicView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var currentIndex = 0
    @State private var addedNodes = [SCNNode]()
    @State private var boxNames = [String]()
    @State private var unfittedItems = [String]()
    @State private var currentContainerIndex = 0
    @State private var addedContainer = [SCNNode]()
    
    @State private var scene = SCNScene()
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            VStack {
                
                if let packingData = viewModel.packing_data {
                    let parsedData = parseData(packingData: packingData[currentContainerIndex])
                    
                    Text("\(parsedData.8)")
                        .font(.headline)
                        .padding()
                    
                    VStack (alignment: .leading) {
                        Text("Unfitted Items: \(parsedData.1.joined(separator: ", "))")
                            .padding(0.5)
                        
                        Text("Space Utilization: \(parsedData.7)")
                            .padding(0.5)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.5))
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    
                    SceneView(scene: createScene(packingData: packingData[currentContainerIndex]), options: [.autoenablesDefaultLighting, .allowsCameraControl])
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2, alignment: .center)
                    //.position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                        .padding()
                    
                    HStack {
                        Button(action: {
                            if currentIndex > 0 {
                                currentIndex -= 1
                                
                                if addedNodes.isEmpty == false {
                                    addedNodes.last?.removeFromParentNode()
                                    addedNodes.removeLast()
                                    boxNames.removeLast()
                                }
                                
                            }
                        }) {
                            Image(systemName: "arrow.backward")
                        }
                        .disabled(currentIndex == 0)
                        
                        
                        VStack {
                            if currentIndex == 0 {
                                Text("Begin Packing Tutorial")
                            } else {
                                if let boxName = addedNodes.last?.childNodes.first?.name {
                                    Text("Item: \(boxName)")
                                        .foregroundColor(.primary)
                                        .padding(.all)
                                }
                                
                            }
                            
                            
                        }
                        
                        Button(action: {
                            if currentIndex < viewModel.packing_data?[currentContainerIndex].fitted_items.count ?? 0 {
                                let boxNode = createBoxes(packingData: packingData[currentContainerIndex], index: currentIndex)
                                scene.rootNode.addChildNode(boxNode)
                                addedNodes.append(boxNode)
                                if let boxName = boxNode.childNodes.first?.name {
                                    boxNames.append(boxName)
                                }
                                
                                currentIndex += 1
                            }
                        }) {
                            Image(systemName:"arrow.forward")
                        }
                        .disabled(currentIndex == (viewModel.packing_data?[currentContainerIndex].fitted_items.count ?? 0))
                    }
                    .padding()
                    
                    HStack {
                        Button(action: {
                            if currentContainerIndex > 0 {
                                currentContainerIndex -= 1
                            }
                        }) {
                            Image(systemName: "arrow.backward")
                        }
                        .disabled(currentContainerIndex == 0)
                        
                        Spacer()
                        
                        Button(action: {
                            if currentContainerIndex < packingData.count - 1 {
                                scene = createScene(packingData: packingData[currentContainerIndex])
                                currentContainerIndex += 1
                            }
                        }) {
                            Image(systemName: "arrow.forward")
                        }
                        .disabled(currentContainerIndex == packingData.count - 1)
                    }
                    .padding()
                    
                } else {
                    Text("Packing Data Not Available")
                }
                
            }
            
        }
        .onChange(of: currentContainerIndex) { newValue in
            // Remove all nodes from the scene
            for node in addedNodes {
                node.removeFromParentNode()
            }
            
            scene.rootNode.enumerateChildNodes { (node, _) in
                if node.name == "containerNode" {
                    node.removeFromParentNode()
                }
            }
            addedNodes.removeAll()
            boxNames.removeAll()
            currentIndex = 0
            
            // Update the scene with the new container data
            if let packingData = viewModel.packing_data {
                scene = createScene(packingData: packingData[newValue])
            }
        }
        
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
    
    let predefinedColors: [UIColor] = [
        UIColor.systemYellow,
        UIColor.systemIndigo,
        UIColor.systemBrown,
        UIColor.systemCyan,
        UIColor.systemPurple,
        UIColor.systemMint,
        UIColor.systemTeal,
        UIColor.systemGreen,
        UIColor.systemBlue,
        UIColor.systemOrange
    ]
    
    func extractDimensionsAndConvert(from text: String) -> [CGFloat] {
        let pattern = "(\\d+)x(\\d+)x(\\d+)"
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.flatMap { result -> [CGFloat] in
                var dimensions = [CGFloat]()
                for i in 1..<result.numberOfRanges {
                    if let range = Range(result.range(at: i), in: text),
                       let floatValue = Float(text[range]) {
                        dimensions.append(CGFloat(floatValue))
                    } else {
                        dimensions.append(0)
                    }
                }
                return dimensions
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func parseData(packingData: PackingData) -> ([Fitted_Items], [String], [UIColor], [[Float]], [[CGFloat]], [String], [Int], String, String) {
        let fittedItems = packingData.fitted_items
        let colors = fittedItems.indices.map { index in
            predefinedColors[index % predefinedColors.count]
        }
        let unfittedItemsNames = packingData.unfitted_items.map { $0.partno }
        
        let fittedItemsPositions = fittedItems.map { $0.position.compactMap { Float($0)  } }
        let fittedItemsDimensions = fittedItems.map { fittedItem in
            fittedItem.dimensions.compactMap { dimensionString in
                if let dimensionFloat = Float(dimensionString) {
                    return CGFloat(dimensionFloat)
                } else {
                    return nil
                }
            }
        }
        
        let fittedItemsNames = fittedItems.map { $0.partno }
        let rotationSetting = fittedItems.map { $0.rotation_type }
        let spaceUtilization = packingData.space_utilization
        let containerName = packingData.bin_name
        return (fittedItems, unfittedItemsNames, colors, fittedItemsPositions, fittedItemsDimensions, fittedItemsNames, rotationSetting, spaceUtilization, containerName)
        
    }
    
    
    func createScene(packingData: PackingData) -> SCNScene {
        let bin = extractDimensionsAndConvert(from: packingData.bin)
        
        let container = SCNBox(width: bin[0], height: bin[1], length: bin[2], chamferRadius: 0)
        container.firstMaterial?.diffuse.contents = UIColor.black
        
        let containerMaterials = [
            UIColor.black,   // Front
            UIColor.black,   // Back
            UIColor.red,   // Right
            UIColor.black,   // Left
            UIColor.black,    // Top
            UIColor.black   // Bottom
        ].enumerated().map { (index, color) in
            let material = SCNMaterial()
            material.diffuse.contents = color
            material.isDoubleSided = true
        
            if index != 2 {
                material.shaderModifiers = [SCNShaderModifierEntryPoint.surface: sm]
            } else {
                material.transparency = 0.2
            }
            
            return material
        }
                        
        container.materials = containerMaterials
        
        let containerNode = SCNNode(geometry: container)
        containerNode.name = "containerNode"
        containerNode.position = SCNVector3(0 + Float(bin[0] / 2), 0 + Float(bin[1] / 2), 0 + Float(bin[2] / 2))
        scene.rootNode.addChildNode(containerNode)
        
        return scene
    }
    
    func createBoxes(packingData: PackingData, index: Int) -> SCNNode {
        let packing_data = parseData(packingData: packingData)
        let size = packing_data.4[index]
        let position = packing_data.3[index]
        let color = packing_data.2[index]
        let name = packing_data.5[index]
        let rotation = packing_data.6[index]
        
        let parentNode = SCNNode()
        let fadeInAction = SCNAction.fadeIn(duration: 1)
        
        let box: SCNBox
        var rotatedSize: [CGFloat]
        
        if rotation == 0 {
            box = SCNBox(width: size[0], height: size[1], length: size[2], chamferRadius: 0.0)
            rotatedSize = [size[0], size[1], size[2]]
            
        } else if rotation == 1 {
            box = SCNBox(width: size[1], height: size[0], length: size[2], chamferRadius: 0.0)
            rotatedSize = [size[1], size[0], size[2]]
        } else if rotation == 2 {
            box = SCNBox(width: size[1], height: size[2], length: size[0], chamferRadius: 0.0)
            rotatedSize = [size[1], size[2], size[0]]
        } else if rotation == 3 {
            box = SCNBox(width: size[2], height: size[1], length: size[0], chamferRadius: 0.0)
            rotatedSize = [size[2], size[1], size[0]]
        } else if rotation == 4 {
            box = SCNBox(width: size[2], height: size[0], length: size[1], chamferRadius: 0.0)
            rotatedSize = [size[2], size[0], size[1]]
        } else if rotation == 5 {
            box = SCNBox(width: size[0], height: size[2], length: size[1], chamferRadius: 0.0)
            rotatedSize = [size[0], size[2], size[1]]
        } else {
            print("Invalid rotation")
            box = SCNBox(width: 0, height: 0, length: 0, chamferRadius: 0.0)
            rotatedSize = [0, 0, 0]
        }
        
        let material = SCNMaterial()
        material.diffuse.contents = color
        material.transparency = 0.7
        box.materials = [material]
        
        let boxNode = SCNNode(geometry: box)
        boxNode.name = name
        boxNode.opacity = 0.0
        
        let moveAction = SCNAction.move(to: SCNVector3(position[0] + Float(rotatedSize[0] / 2), position[1] + Float(rotatedSize[1] / 2), position[2] + Float(rotatedSize[2] / 2)), duration: 0.5)
        let fadeInMoveSequence = SCNAction.sequence([SCNAction.wait(duration: Double(index - currentIndex) * 1.0), fadeInAction, moveAction])
        
        boxNode.opacity = 0.0
        boxNode.runAction(fadeInMoveSequence)
        
        parentNode.addChildNode(boxNode)
        
        
        return parentNode
    }
}


//#Preview {
//    SchematicView()
//}
