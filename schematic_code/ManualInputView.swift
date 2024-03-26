//
//  ManualInputView.swift
//  ScanitPackit
//
//  Created by Tristen Liu on 3/25/24.
//

import Foundation
import SwiftUI
import SceneKit


struct Dimensions {
    var height: String = ""
    var width: String = ""
    var length: String = ""
}

struct ManualInputView: View {
    @State private var dimensionsList: [Dimensions] = [Dimensions()]
    @State private var containerDimensions: Dimensions = Dimensions()
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    Text("Manual Input Mode")
                        .font(.title)
                        .frame(alignment: .top)
                        .foregroundColor(Color.black)
                    List {
                        Section(header: Text("Container")) {
                                TextField("Height (m)", text: $containerDimensions.height).keyboardType(.decimalPad)
                            TextField("Width (m)", text: $containerDimensions.width)
                                .keyboardType(.decimalPad)
                            TextField("Length (m)", text: $containerDimensions.length)
                                .keyboardType(.decimalPad)
                        }
                        ForEach(0..<dimensionsList.count, id: \.self) { index in
                            Section(header: Text("Box \(index + 1)")) {
                                TextField("Height (m)", text: $dimensionsList[index].height)
                                    .keyboardType(.decimalPad)
                                TextField("Width (m)", text: $dimensionsList[index].width)
                                    .keyboardType(.decimalPad)
                                TextField("Length (m)", text: $dimensionsList[index].length)
                                    .keyboardType(.decimalPad)
                            }
                        }
                        Button("Add More") {
                            dimensionsList.append(Dimensions())
                            print(dimensionsList)
                        }
                        
                        //NavigationLink(destination: SchematicView()) {
                        //    Text("Finish Adding")
                        //}
                    }
                }
            }
        }
        
        .padding()
    }
}

