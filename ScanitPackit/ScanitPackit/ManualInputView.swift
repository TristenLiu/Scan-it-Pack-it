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
    @State private var SchematicSeen = false
    @StateObject var viewModel = ViewModel()

    
    var body: some View {
        //NavigationStack {
            VStack {
                HStack {
//                    Button(action: {
//                        self.presentationMode.wrappedValue.dismiss()
//                    }) {
//                        HStack {
//                            Image(systemName: "chevron.left")
//                            Text("Back")
//                        }}
//                    .padding()
                    //Spacer()
                    
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
                
                Button("Fetch Data (demo)") {
                    viewModel.fetch()
                }
                
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
                                    SchematicSeen = false
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                }
                                .padding(.trailing, 8)
                            }
                        }) {
                            TextField("Length (cm)", text: $dimensionsList.dimensions[index][0])
                                .keyboardType(.decimalPad)
                            TextField("Width (cm)", text: $dimensionsList.dimensions[index][1])
                                .keyboardType(.decimalPad)
                            TextField("Height (cm)", text: $dimensionsList.dimensions[index][2])
                                .keyboardType(.decimalPad)
                        }
                    }
                    
                    Section() {
                        Button{
                            dimensionsList.dimensions.append(["", "", ""])
                            print(dimensionsList.dimensions)
                            SchematicSeen = false
                        } label: {
                            Text("Add More")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        }
                        
                        NavigationLink("Finish Adding", destination: SchematicView(viewModel: viewModel)
                            .onAppear{
                                if !SchematicSeen {
                                    print("Finished adding boxes")
                                    let data = SessionData(
                                        dimensionsList: dimensionsList.dimensions,
                                        saveDate: Date(),
                                        numberOfBoxes: dimensionsList.dimensions.count)
                                    print(data)
                                    data.save()
                                    
                                    SchematicSeen = true
                                }
                        })
                    }
                    
                    // Add blank space for buttom visiblity
                    Color(.clear)
                        .frame(height:300)
                        .listRowBackground(Color.clear)
                }
                .scrollDismissesKeyboard(.immediately)
                .sheet(isPresented: $showingContainerSelection) {
                    ContainerSelectionView(selectContainer: { container in
                        dimensionsList.dimensions[0] = container.dimensions.map { dimension in
                            if let inchValue = Double(dimension) {
                                let cmValue = inchValue * 2.54
                                return String(format: "%.2f", cmValue)
                            } else {
                                return dimension
                            }
                        }
                        showingContainerSelection = false
                    })
                }
                
            }
            .padding()
        //}
    }
}

#Preview {
    ManualInputView(dimensionsList: Dimensions.shared)
}
