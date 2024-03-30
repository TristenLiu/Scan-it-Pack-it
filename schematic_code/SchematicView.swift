//
//  SchematicView.swift
//  testPackingData
//
//  Created by Daniellia Sumigar on 3/23/24.
//

import SwiftUI
import SceneKit

struct SchematicView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var currentIndex = 0
    @State private var addedNodes = [SCNNode]()
    
    var scene = SCNScene()
    
    
    var body: some View {
        VStack {
            if let packingData = viewModel.packing_data {
                SceneView(scene: createScene(packingData: packingData), options: [.autoenablesDefaultLighting, .allowsCameraControl])
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                    .padding()
                
                
                HStack {
                    Button(action: {
                        if currentIndex > 0 {
                            currentIndex -= 1
                            
                            if addedNodes.isEmpty == false {
                                addedNodes.last?.removeFromParentNode()
                                addedNodes.removeLast()
                            }
                        }
                    }) {
                        Image(systemName: "arrow.backward")
                    }
                    .disabled(currentIndex == 0)
                    
                    Spacer()
                    
                    Button(action: {
                        if currentIndex < viewModel.packing_data?.fitted_items.count ?? 0 {
                            let boxNode = createBoxes(packingData: packingData, index: currentIndex)
                            scene.rootNode.addChildNode(boxNode)
                            
                            currentIndex += 1
                        }
                    }) {
                        Image(systemName:"arrow.forward")
                    }
                    .disabled(currentIndex == (viewModel.packing_data?.fitted_items.count ?? 0))
                }
                .padding()
            } else {
                Text("Packing Data Not Available")
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
        UIColor.systemPink,
        UIColor.systemBrown,
        UIColor.systemCyan,
        UIColor.systemPurple,
        UIColor.systemMint,
        UIColor.systemTeal,
        UIColor.systemRed,
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
    
    func parseData(packingData: PackingData) -> ([Fitted_Items], [UIColor], [[Float]], [[CGFloat]]) {
        let fittedItems = packingData.fitted_items
        
        let colors = fittedItems.indices.map { index in
            predefinedColors[index % predefinedColors.count]
        }
        
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
        
        return (fittedItems, colors, fittedItemsPositions, fittedItemsDimensions)
        
    }
    
    func createScene(packingData: PackingData) -> SCNScene {
        let bin = extractDimensionsAndConvert(from: packingData.bin)

        let parentNode = SCNNode()
        //parentNode.name = "package"
        
        let container = SCNBox(width: bin[0], height: bin[1], length: bin[2], chamferRadius: 0)
        container.firstMaterial?.diffuse.contents = UIColor.black
        container.firstMaterial?.shaderModifiers = [SCNShaderModifierEntryPoint.surface: sm]
        container.firstMaterial?.isDoubleSided = true
        
        let containerNode = SCNNode(geometry: container)
        containerNode.position = SCNVector3(0 + Float(bin[0] / 2), 0 + Float(bin[1] / 2), 0 + Float(bin[2] / 2))
        scene.rootNode.addChildNode(containerNode)
        return scene
    }       

    func createBoxes(packingData: PackingData, index: Int) -> SCNNode {
        let packing_data = parseData(packingData: packingData)
        let size = packing_data.3[index]
        let position = packing_data.2[index]
        let color = packing_data.1[index]
        
        let parentNode = SCNNode()

        let box = SCNBox(width: size[0], height: size[1], length: size[2], chamferRadius: 0.0)
        let material = SCNMaterial()
        material.diffuse.contents = color
        material.transparency = 0.7
        box.materials = [material]
        
        let boxNode = SCNNode(geometry: box)
        
        let fadeInAction = SCNAction.fadeIn(duration: 1)
        let moveAction = SCNAction.move(to: SCNVector3(position[0] + Float(size[0] / 2), position[1] + Float(size[1] / 2), position[2] + Float(size[2] / 2)), duration: 0.5)
        
        let fadeInMoveSequence = SCNAction.sequence([SCNAction.wait(duration: Double(index - currentIndex) * 1.0), fadeInAction, moveAction])
        
        boxNode.opacity = 0.0 // Initially hide new nodes
        boxNode.runAction(fadeInMoveSequence)
        
        parentNode.addChildNode(boxNode)
        
        
        return parentNode
    }
}


//#Preview {
//    SchematicView()
//}
