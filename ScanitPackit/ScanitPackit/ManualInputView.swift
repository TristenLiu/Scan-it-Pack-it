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
            HStack {
                NavigationLink(destination: storyboardView().edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)) {
                    HStack {
                        Text("Scan")
                    }
                }
                .padding()
            }
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
                        TextField("Length (cm)", value: $dimensionsList.dimensions[index][0], formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                        TextField("Width (cm)", value: $dimensionsList.dimensions[index][1], formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                        TextField("Height (cm)", value: $dimensionsList.dimensions[index][2], formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                    }
                }
                
                Section() {
                    Button("Add More") {
                        dimensionsList.dimensions.append([0,0,0])
                        //print(dimensionsList.dimensions)
                    }
                    
                    Button("Finish Adding") {
                        viewModel.fetch(with: dimensionsList)
                        fetchCompleted = true
                    }
                    
                    NavigationLink(destination: SchematicView(viewModel: viewModel), isActive: $fetchCompleted) {
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
}
