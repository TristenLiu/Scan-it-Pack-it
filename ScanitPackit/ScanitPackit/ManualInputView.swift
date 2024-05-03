//
//  ManualInputView.swift
//  ScanitPackit
//
//  Created by Tristen Liu on 3/25/24.
//

import Foundation
import SwiftUI
import SceneKit

struct ManualInputView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var dimensionsList: Dimensions
    @State private var showingContainerSelection = false
    @State private var fetchCompleted = false
    @StateObject var viewModel = ViewModel()
    @State private var selectIndex = 0
    
    var body: some View {
        VStack {
            Text("Manual Input Mode")
                .font(.title)
                .frame(alignment: .top)
                .foregroundColor(Color.black)
                .padding()
            
            List {
                ForEach(0..<dimensionsList.containerCount, id: \.self) { index in
                    Section(header: HStack {
                        Text("Container \(index + 1)")
                        Spacer()
                            Button(action: {
                                selectIndex = index
                                showingContainerSelection = true
                            }) {
                                Image(systemName: "square.grid.2x2")
                                    .foregroundColor(.blue)
                            }
                            .padding(.trailing, 8)
                            Button(action: {
                                dimensionsList.removeCDims(at: index)
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                            }
                            .padding(.trailing, 8)
                        
                    }) {
                        TextField("Length (\(dimensionsList.measurementUnit.rawValue))",
                                  text: self.Cbinding(for: index, dimensionIndex: 0))
                        .keyboardType(.decimalPad)
                        TextField("Width (\(dimensionsList.measurementUnit.rawValue))",
                                  text: self.Cbinding(for: index, dimensionIndex: 1))
                        .keyboardType(.decimalPad)
                        TextField("Height (\(dimensionsList.measurementUnit.rawValue))",
                                  text: self.Cbinding(for: index, dimensionIndex: 2))
                        .keyboardType(.decimalPad)
                    }
                }
                ForEach(0..<dimensionsList.boxDims.count, id: \.self) { index in
                    Section(header: HStack {
                        Text("Box \(index + 1)")
                        Spacer()
                        Button(action: {
                            dimensionsList.removeBDims(at: index)
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        .padding(.trailing, 8)
                    }) {
                        TextField("Length (\(dimensionsList.measurementUnit.rawValue))",
                                  text: self.Bbinding(for: index, dimensionIndex: 0))
                        .keyboardType(.decimalPad)
                        TextField("Width (\(dimensionsList.measurementUnit.rawValue))",
                                  text: self.Bbinding(for: index, dimensionIndex: 1))
                        .keyboardType(.decimalPad)
                        TextField("Height (\(dimensionsList.measurementUnit.rawValue))",
                                  text: self.Bbinding(for: index, dimensionIndex: 2))
                        .keyboardType(.decimalPad)
                    }
                }
                .onMove(perform: move)
                
                Section() {
                    Button("Add Container") {
                        dimensionsList.containerDims.append([0,0,0])
                    }
                    Button("Add Box") {
                        dimensionsList.boxDims.append([0,0,0])
                    }
                    
                    Button("Finish Adding") {
                        let data = SessionData(
                            containerDims: dimensionsList.containerDims,
                            boxDims: dimensionsList.boxDims,
                            saveDate: Date(),
                            numberOfBoxes: dimensionsList.containerCount + dimensionsList.boxDims.count)
//                        print(data)
                        data.save()
                        viewModel.fetch(with: dimensionsList)
                        fetchCompleted = true
                        
                        print("Containers: \(dimensionsList.containerDims)")
                        print("Boxes: \(dimensionsList.boxDims)")
                    }
                    
                    NavigationLink(destination: SchematicView(viewModel: viewModel), isActive: $fetchCompleted) {
                        EmptyView()
                    }
                    
//                    Button("Suggest a Container") {
//                        let data = SessionData(
//                            containerDims: dimensionsList.containerDims,
//                            boxDims: dimensionsList.boxDims,
//                            saveDate: Date(),
//                            numberOfBoxes: dimensionsList.containerCount + dimensionsList.boxDims.count)
////                        print(data)
//                        data.save()
//                        viewModel.findMinimumContainerSize(with: dimensionsList)
//                    }
                }
                
                Color(.clear)
                    .frame(height:300)
                    .listRowBackground(Color.clear)
            }
            .scrollDismissesKeyboard(.immediately)
            .sheet(isPresented: $showingContainerSelection) {
                ContainerSelectionView(selectContainer: { container in
                    dimensionsList.containerDims[selectIndex] = container.dimensions.map { dimension in
                        let cmValue = dimension * 2.54
                        return Float(cmValue)
                    }
                })
            }
            
        }
        .padding()
    }
    
    func move(from source: IndexSet, to destination: Int) {
        // Ensure move is allowed only for boxes
        dimensionsList.boxDims.move(fromOffsets: source, toOffset: destination)
    }
    
    private func convertDimensions(_ dimension: Float, to unit: MeasurementUnit) -> String {
        switch unit {
        case .inches:
            return String(format: "%.2f", dimension / 2.54)
        case .cm:
            return String(format: "%.2f", dimension)
        }
    }
    
    // Create a binding for each dimension TextField
    private func Cbinding(for index: Int, dimensionIndex: Int) -> Binding<String> {
        Binding<String>(
            get: {
                guard self.dimensionsList.containerDims.indices.contains(index),
                      self.dimensionsList.containerDims[index].indices.contains(dimensionIndex)
                else {
                    return ""
                }
                
                // when getting, convert to CM or IN based on current unit
                let dimension = self.dimensionsList.containerDims[index][dimensionIndex]
                let displayText = self.convertDimensions(dimension,
                                                         to: self.dimensionsList.measurementUnit)
                // if the dimension is empty, return an empty string
                return displayText == "0.00" ? "" : displayText
                
            },
            set: {
                // when setting, convert to cm for dimensionsList
                if let floatValue = Float($0) {
                    let storedValue: Float
                    if self.dimensionsList.measurementUnit == .inches {
                        // if curent unit is in inches, convert to cm
                        storedValue = floatValue * 2.54
                    } else {
                        storedValue = floatValue
                    }
                    // update value
                    self.dimensionsList.containerDims[index][dimensionIndex] = storedValue
                } else {
                    self.dimensionsList.containerDims[index][dimensionIndex] = 0
                }
            }
        )
    }
    
    // Create a binding for each dimension TextField
    private func Bbinding(for index: Int, dimensionIndex: Int) -> Binding<String> {
        Binding<String>(
            get: {
                // make sure [index][dimensionIndex] exists
                    guard self.dimensionsList.boxDims.indices.contains(index),
                          self.dimensionsList.boxDims[index].indices.contains(dimensionIndex) else {
                        return ""
                    }
                    
                    // when getting, convert to CM or IN based on current unit
                    let dimension = self.dimensionsList.boxDims[index][dimensionIndex]
                    let displayText = self.convertDimensions(dimension,
                                                             to: self.dimensionsList.measurementUnit)
                    // if the dimension is empty, return an empty string
                    return displayText == "0.00" ? "" : displayText
                
            },
            set: {
                // when setting, convert to cm for dimensionsList
                if let floatValue = Float($0) {
                    let storedValue: Float
                    if self.dimensionsList.measurementUnit == .inches {
                        // if curent unit is in inches, convert to cm
                        storedValue = floatValue * 2.54
                    } else {
                        storedValue = floatValue
                    }
                    // update value
                        self.dimensionsList.boxDims[index][dimensionIndex] = storedValue
                    
                } else {
                    self.dimensionsList.boxDims[index][dimensionIndex] = 0
                }
            }
        )
    }
}
