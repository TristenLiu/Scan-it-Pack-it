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
    
    var CB = true
    
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var breadthLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var CBControl: UISegmentedControl!
    
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
    
    private func getLabel(forState state: MeasureState) -> UILabel {
        switch state {
        case .lengthCalc:
            return lengthLabel
        case .breadthCalc:
            return breadthLabel
        case .heightCalc:
            return heightLabel
        }
    }
    
    func clearScene() {
        removeNodes(fromNodeList: nodesList(forState: .lengthCalc))
        removeNodes(fromNodeList: nodesList(forState: .breadthCalc))
        removeNodes(fromNodeList: nodesList(forState: .heightCalc))
        removeNodes(fromNodeList: lineNodes)
    }
    
    //MARK: - IBActions
    @IBAction func CBChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            CB = true
        } else {
            CB = false
        }
    }
    
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
    
    @IBAction func resetCurrentMeasurement() {
        removeNodes(fromNodeList: nodesList(forState: currentState))
        realTimeLineNode?.removeFromParentNode()
        realTimeLineNode = nil
        getLabel(forState: currentState).text = "--"
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
            
            let displayDistance = sharedDims.measurementUnit == .cm ? distance : distance/2.54
            let format = sharedDims.measurementUnit == .cm ? "%.2fcm" : "%.2fin"
            
            
            //Remove realtime line node
            realTimeLineNode?.removeFromParentNode()
            realTimeLineNode = nil
            
            //Change state
            switch currentState {
            case .lengthCalc:
                dimensions = [distance, 0, 0]
                lengthLabel.text = String(format: format, displayDistance)
                currentState = .breadthCalc
            case .breadthCalc:
                dimensions[1] = distance
                breadthLabel.text = String(format: format, displayDistance)
                currentState = .heightCalc
            case .heightCalc:
                dimensions[2] = distance
                heightLabel.text = String(format: format, displayDistance)
                
                if CB {
                    if sharedDims.containerDims.last == [0,0,0] {
                        sharedDims.containerDims[sharedDims.containerCount - 1] = dimensions.map{Float($0)}
                    } else {
                        sharedDims.containerDims.append(dimensions.map{Float($0)})
                    }
                } else {
                    sharedDims.boxDims.append(dimensions.map{Float($0)})
                }
                print("Containers: \(sharedDims.containerDims) ")
                print("Boxes: \(sharedDims.boxDims)")
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
            
            var distance = sceneView.distance(betweenPoints: startNode.position, point2: hitResultPosition) * 100
            distance = sharedDims.measurementUnit == .cm ? distance : distance/2.54
            let format = sharedDims.measurementUnit == .cm ? "%.2fcm" : "%.2fin"

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
                label.text = String(format: format, distance)
                self.distanceLabel.text = String(format: format, distance)
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
