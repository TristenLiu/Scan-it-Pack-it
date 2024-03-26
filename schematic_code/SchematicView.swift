//
//  SchematicView.swift
//  ManualInput
//
//  Created by Daniellia Sumigar on 3/2/24.
//

import SwiftUI
import SceneKit

struct SchematicView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            if let packingData = viewModel.packing_data {
                SceneView(scene: createScene(packingData: packingData), options: [.autoenablesDefaultLighting, .allowsCameraControl])
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
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
                        dimensions.append(0) // Or any default value you prefer
                    }
                }
                return dimensions
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    
    func createScene(packingData: PackingData) -> SCNScene {
        let scene = SCNScene()
        let fittedItems = packingData.fitted_items
        let unfittedItems = packingData.unfitted_items
        let bin = extractDimensionsAndConvert(from: packingData.bin)
        let spaceUtilization = packingData.space_utilization
        let residualVolume = packingData.residual_volume
        let unpackItemVolume = packingData.unpack_item_volume
        let usedTime = packingData.used_time
        
        let colors = packingData.fitted_items.indices.map { index in
            predefinedColors[index % predefinedColors.count]
        }

        print(fittedItems)
        let fittedItemsPositions = packingData.fitted_items.map { $0.position.compactMap { Float($0)  } }
        let fittedItemsDimensions = packingData.fitted_items.map { fittedItem in
            fittedItem.dimensions.compactMap { dimensionString in
                if let dimensionFloat = Float(dimensionString) {
                    return CGFloat(dimensionFloat)
                } else {
                    return nil
                }
            }
        }
        print(fittedItemsDimensions)
        print(fittedItemsPositions)
        let combinedNode = createBoxes(containerSize: bin, sizes: fittedItemsDimensions, positions: fittedItemsPositions, colors: colors)
        scene.rootNode.addChildNode(combinedNode)
        
        return scene
    }
    
    func createBoxes(containerSize: [CGFloat], sizes: [[CGFloat]], positions: [[Float]], colors: [UIColor]) -> SCNNode {
        let parentNode = SCNNode()
        
        let container = SCNBox(width: containerSize[0], height: containerSize[1], length: containerSize[2], chamferRadius: 0)
        
        container.firstMaterial?.diffuse.contents = UIColor.black
        container.firstMaterial?.shaderModifiers = [SCNShaderModifierEntryPoint.surface: sm]
        container.firstMaterial?.isDoubleSided = true
        
        let containerNode = SCNNode(geometry: container)
        containerNode.position = SCNVector3(0 + Float(containerSize[0] / 2), 0 + Float(containerSize[1] / 2), 0 + Float(containerSize[2] / 2))
        
        parentNode.addChildNode(containerNode)
        
        for i in 0..<min(sizes.count, positions.count, colors.count) {
            let size = sizes[i]
            let position = positions[i]
            let color = colors[i]
            
            // Create SCNBox
            let box = SCNBox(width: size[0], height: size[1], length: size[2], chamferRadius: 0.0)
            let material = SCNMaterial()
            material.diffuse.contents = color
            material.transparency = 0.7
            box.materials = [material]
            
            // Create SCNNode with the box geometry
            let boxNode = SCNNode(geometry: box)
            
            let fadeInAction = SCNAction.fadeIn(duration: 1)
            let moveAction = SCNAction.move(to: SCNVector3(position[0] + Float(size[0] / 2), position[1] + Float(size[1] / 2), position[2] + Float(size[2] / 2)), duration: 0.5)
            
            let fadeInMoveSequence = SCNAction.sequence([SCNAction.wait(duration: Double(i) * 1.0), fadeInAction, moveAction])
            
            boxNode.runAction(fadeInMoveSequence)
            
            parentNode.addChildNode(boxNode)
        }
        
        return parentNode
    }

}
