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

    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }}
                    .padding()
                    Spacer()
                }
                Text("Manual Input Mode")
                    .font(.title)
                    .frame(alignment: .top)
                    .foregroundColor(Color.black)
                List {
                    ForEach(0..<dimensionsList.dimensions.count, id: \.self) { index in
                        Section(header: Text(index == 0 ? "Container" : "Box \(index)")) {
                            TextField("Length (cm)", text: $dimensionsList.dimensions[index][0])
                                .keyboardType(.decimalPad)
                            TextField("Width (cm)", text: $dimensionsList.dimensions[index][1])
                                .keyboardType(.decimalPad)
                            TextField("Height (cm)", text: $dimensionsList.dimensions[index][2])
                                .keyboardType(.decimalPad)
                        }
                    }
                    
                    Button("Add More") {
                        dimensionsList.dimensions.append(["", "", ""])
                        print(dimensionsList)
                    }
                    
                    NavigationLink(destination: SchematicView()) {
                        Text("Finish Adding")
                    }
                }
                
            }
            .padding()
        }
    }
}

