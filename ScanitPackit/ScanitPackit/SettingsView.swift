//
//  SettingsView.swift
//  ScanitPackit
//
//  Created by Tristen Liu on 4/3/24.
//

import Foundation
import SwiftUI


struct SettingsView: View {
    @ObservedObject var sharedDims = Dimensions.shared

    var body: some View {
        NavigationView {
                    Form {
                        Section(header: Text("Settings").font(.largeTitle)) {
                            VStack {
                                HStack {
                                    Text("Priority Packing")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Toggle("", isOn: $sharedDims.priorityToggle)
                                        .labelsHidden()
                                }
                                Spacer()
                                Text("Measurement Units")
                                Picker("Measurement Unit", selection:$sharedDims.measurementUnit) {
                                    ForEach(MeasurementUnit.allCases) { unit in
                                        Text(unit.rawValue).tag(unit)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                
                            }
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                }
    }
}

#Preview {
    SettingsView(sharedDims: Dimensions.shared)
}
