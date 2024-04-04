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
    
    var body: some View {
        VStack {
//            HStack {
//                Spacer()
//                NavigationLink(destination: storyboardView().edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)) {
//                    HStack {
//                        Text("Scan")
//                    }
//                }
//            }
            Text("Manual Input Mode")
                .font(.title)
                .frame(alignment: .top)
                .foregroundColor(Color.black)
                .padding()
            
            List {
                ForEach(0..<dimensionsList.dimensions.count, id: \.self) { index in
                    Section(header: HStack {
                        Text(index == 0 ? "Container" : "Box \(index)")
                        Spacer()
                        if index == 0 {
                            Button(action: {
                                showingContainerSelection = true
                            }) {
                                Image(systemName: "square.grid.2x2")
                                    .foregroundColor(.blue)
                            }
                            .padding(.trailing, 8)
                        } else {
                            Button(action: {
                                dimensionsList.removeDimensions(at: index)
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                            }
                            .padding(.trailing, 8)
                        }
                    }) {
                        TextField("Length (\(dimensionsList.measurementUnit.rawValue))",
                                  text: self.binding(for: index, dimensionIndex: 0))
                            .keyboardType(.decimalPad)
                        TextField("Width (\(dimensionsList.measurementUnit.rawValue))",
                                  text: self.binding(for: index, dimensionIndex: 1))
                            .keyboardType(.decimalPad)
                        TextField("Height (\(dimensionsList.measurementUnit.rawValue))",
                                  text: self.binding(for: index, dimensionIndex: 2))
                            .keyboardType(.decimalPad)
                    }
                }
                
                Section() {
                    Button("Add More") {
                        dimensionsList.dimensions.append([0,0,0])
                        //print(dimensionsList.dimensions)
                    }
                    
                    Button("Finish Adding") {
                        let data = SessionData(
                            dimensionsList: dimensionsList.dimensions,
                            saveDate: Date(),
                            numberOfBoxes: dimensionsList.dimensions.count)
                        print(data)
                        data.save()
                        viewModel.fetch(with: dimensionsList)
                        fetchCompleted = true
                    }
                    
                    NavigationLink(destination: SchematicView(viewModel: viewModel), isActive: $fetchCompleted) {
                        EmptyView()
                    }
                }
                
                Color(.clear)
                    .frame(height:300)
                    .listRowBackground(Color.clear)
            }
            .scrollDismissesKeyboard(.immediately)
            .sheet(isPresented: $showingContainerSelection) {
                ContainerSelectionView(selectContainer: { container in
                    dimensionsList.dimensions[0] = container.dimensions.map { dimension in
                        let cmValue = dimension * 2.54
                        return Float(cmValue)
                    }
                    showingContainerSelection = false
                })
            }
            
        }
        .padding()
        //}
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
    private func binding(for index: Int, dimensionIndex: Int) -> Binding<String> {
        Binding<String>(
            get: {
                // make sure [index][dimensionIndex] exists
                guard self.dimensionsList.dimensions.indices.contains(index),
                      self.dimensionsList.dimensions[index].indices.contains(dimensionIndex) else {
                    return ""
                }
                // when getting, convert to CM or IN based on current unit
                let dimension = self.dimensionsList.dimensions[index][dimensionIndex]
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
                    self.dimensionsList.dimensions[index][dimensionIndex] = storedValue
                }
            }
        )
    }
}
