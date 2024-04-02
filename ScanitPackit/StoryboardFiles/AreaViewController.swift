//
//  ViewController.swift
//  AMMeasure
//
//  Created by Bhat, Adithya H on 04/04/19.
//  Modified by Tristen Liu on 03/25/24.
//

import UIKit
import SwiftUI
import ARKit
import Combine

class AreaViewController: MeasureViewController {

    var sharedDims = Dimensions.shared
    var dimensions: [CGFloat] = [0, 0, 0]
    
    enum MeasureState {
        case lengthCalc
        case breadthCalc
        case heightCalc
    }
    
    var lengthNodes = NSMutableArray()
    var breadthNodes = NSMutableArray()
    var heightNodes = NSMutableArray()
    var lineNodes = NSMutableArray()
    var currentState: MeasureState = MeasureState.lengthCalc
    
    var allPointNodes: [Any] {
        get {
            return lengthNodes as! [Any] + breadthNodes + heightNodes
        }
    }
    var nodeColor = UIColor.white.withAlphaComponent(0.8)
    
    
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var breadthLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
    }
    
    //MARK: - Private helper methods
    private func nodesList(forState state: MeasureState) -> NSMutableArray {
        switch state {
        case .lengthCalc:
            return lengthNodes
        case .breadthCalc:
            return breadthNodes
        case .heightCalc:
            return heightNodes
        }
    }
    
    func clearScene() {
        removeNodes(fromNodeList: nodesList(forState: .lengthCalc))
        removeNodes(fromNodeList: nodesList(forState: .breadthCalc))
        removeNodes(fromNodeList: nodesList(forState: .heightCalc))
        removeNodes(fromNodeList: lineNodes)
    }
    
    //MARK: - IBActions
    @IBAction func resetMeasurement() {
        print("reset button pressed")
        clearScene()
        removeNodes(fromNodeList: lineNodes)
        realTimeLineNode?.removeFromParentNode()
        realTimeLineNode = nil
        currentState = .lengthCalc
        lengthLabel.text = "--"
        breadthLabel.text = "--"
        heightLabel.text = "--"
        distanceLabel.text = "--"
    }
    
    @IBAction func addPoint(_ sender: UIButton) {
        
        let pointLocation = view.convert(screenCenterPoint, to: sceneView)
        guard let hitResultPosition = sceneView.hitResult(forPoint: pointLocation)  else {
            return
        }
        
        //To prevent multiple taps
        sender.isUserInteractionEnabled = false
        defer {
            sender.isUserInteractionEnabled = true
        }
        
        if allPointNodes.count >= 6 {
            resetMeasurement()
        }
        let nodes = nodesList(forState: currentState)
        
        let sphere = SCNSphere(color: UIColor.white.withAlphaComponent(1), radius: nodeRadius)
        let node = SCNNode(geometry: sphere)
        node.position = hitResultPosition
        sceneView.scene.rootNode.addChildNode(node)
        
        // Add the Sphere to the list.
        nodes.add(node)
        
        if nodes.count == 1 {
            
            //Add a realtime line
            let realTimeLine = LineNode(from: hitResultPosition,
                                        to: hitResultPosition,
                                        lineColor: nodeColor,
                                        lineWidth: lineWidth)
            realTimeLine.name = realTimeLineName
            realTimeLineNode = realTimeLine
            sceneView.scene.rootNode.addChildNode(realTimeLine)
            
        } else if nodes.count == 2 {
            let startNode = nodes[0] as! SCNNode
            let endNode = nodes[1]  as! SCNNode
            
            // Create a node line between the nodes
            let measureLine = LineNode(from: startNode.position,
                                       to: endNode.position,
                                       lineColor: UIColor.white.withAlphaComponent(1),
                                       lineWidth: lineWidth)
            sceneView.scene.rootNode.addChildNode(measureLine)
            lineNodes.add(measureLine)
            
            //calc distance
            let distance = sceneView.distance(betweenPoints: startNode.position, point2: endNode.position) * 100 // M to CM
            
            //Remove realtime line node
            realTimeLineNode?.removeFromParentNode()
            realTimeLineNode = nil
            
            //Change state
            switch currentState {
            case .lengthCalc:
                dimensions = [distance, 0, 0]
                lengthLabel.text = String(format: "%.2fcm", distance)
                currentState = .breadthCalc
            case .breadthCalc:
                dimensions[1] = distance
                breadthLabel.text = String(format: "%.2fcm", distance)
                currentState = .heightCalc
            case .heightCalc:
                dimensions[2] = distance
                heightLabel.text = String(format: "%.2fcm", distance)
                
                sharedDims.dimensions.append([String(format: "%.3f", dimensions[0]),
                                    String(format: "%.3f", dimensions[1]),
                                    String(format: "%.3f", dimensions[2])])
                print(sharedDims.dimensions)
            }
        }
    }
    
}

extension AreaViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        let dotNodes = allPointNodes as! [SCNNode]
        if dotNodes.count > 0, let currentCameraPosition = self.sceneView.pointOfView {
            updateScaleFromCameraForNodes(dotNodes, fromPointOfView: currentCameraPosition)
        }
        
        //Update realtime line node
        if let realTimeLineNode = self.realTimeLineNode,
           let hitResultPosition = sceneView.hitResult(forPoint: screenCenterPoint),
           let startNode = self.nodesList(forState: self.currentState).firstObject as? SCNNode {
            realTimeLineNode.updateNode(vectorA: startNode.position, vectorB: hitResultPosition, color: nil)
            
            let distance = sceneView.distance(betweenPoints: startNode.position, point2: hitResultPosition) * 100
            let label: UILabel
            switch currentState {
            case .lengthCalc:
                label = lengthLabel
            case .breadthCalc:
                label = breadthLabel
            case .heightCalc:
                label = heightLabel
            }
            DispatchQueue.main.async { [unowned self] in
                label.text = String(format: "%.2fcm", distance)
                self.distanceLabel.text = String(format: "%.2fcm", distance)
            }
        }
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
        case .normal:
            break
        default:
            break
        }
    }
    
}
