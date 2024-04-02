//
//  ContainerSelectionView.swift
//  ScanitPackit
//
//  Created by Tristen Liu on 3/30/24.
//

import Foundation
import SwiftUI

struct ContainerSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    var selectContainer: (Container) -> Void
    
    let containerData = [
        "UPS Boxes": [Container(name: "10kg Box", dimensions: ["16", "13", "10"], 
                                imageName: "ups-10kg", category: "UPS Boxes"),
                      Container(name: "25kg Box", dimensions: ["19", "17", "14"], 
                                imageName: "ups-25kg", category: "UPS Boxes"),
                      Container(name: "Express Box", dimensions: ["18", "13", "3"], 
                                imageName: "ups-express-box", category: "UPS Boxes"),
                      Container(name: "World Ease Document Box", dimensions: ["17", "12.5", "3"], 
                                imageName:"ups-world-ease", category: "UPS Boxes")],
        
        "FedEx Boxes": [Container(name: "", dimensions: ["8", "8", "8"], 
                                  imageName: "8x8x8_523262314", category: "FedEx Boxes"),
                        Container(name: "", dimensions: ["12", "3", "17.5"],
                                  imageName: "12x3x17_5_228022854", category: "FedEx Boxes"),
                        Container(name: "", dimensions: ["12", "12", "18"],
                                  imageName: "12x12x18_1823964934", category: "FedEx Boxes"),
                        Container(name: "", dimensions: ["13", "9", "11"],
                                  imageName: "13x9x11_2036633520", category: "FedEx Boxes"),
                        Container(name: "", dimensions: ["16", "16", "16"],
                                  imageName: "16x16x16_653733980", category: "FedEx Boxes"),
                        Container(name: "", dimensions: ["14", "14", "14"],
                                  imageName: "14x14x14_1691299024", category: "FedEx Boxes"),
                        Container(name: "", dimensions: ["20", "20", "20"],
                                  imageName: "20x20x20_1876168326", category: "FedEx Boxes"),
                        Container(name: "", dimensions: ["23", "17", "12"],
                                  imageName: "23x17x12_994031845", category: "FedEx Boxes"),
                        Container(name: "", dimensions: ["12", "9", "6"],
                                  imageName: "12x9x6_1055843742",category: "FedEx Boxes"),
                        Container(name: "", dimensions: ["17", "17", "7"],
                                  imageName: "17x17x7_1225188354", category: "FedEx Boxes"),
                        Container(name: "", dimensions: ["20", "20", "12"],
                                  imageName: "20x20x12_638460089", category: "FedEx Boxes"),
                        Container(name: "", dimensions: ["24", "24", "24"],
                                  imageName: "24x24x24_778461799", category: "FedEx Boxes"),
                        Container(name: "", dimensions: ["28", "28", "28"],
                                  imageName: "28x28x28_1226659338", category: "FedEx Boxes"),
                        Container(name: "", dimensions: ["24", "24", "18"],
                                  imageName: "24x24x18_331748316", category: "FedEx Boxes"),
                        Container(name: "", dimensions: ["18", "13", "11.75"],
                                  imageName: "18x13x11_75_282911581", category: "FedEx Boxes"),]
    ]
    
    var body: some View {
        List {
            ForEach(containerData.keys.sorted(), id: \.self) { key in
                Section(header: Text(key)) {
                    ForEach(containerData[key] ?? []) { container in
                        Button(action: {
                            selectContainer(container)
                        }) {
                            ContainerRow(container: container)
                        }
                    }
                }
            }
        }
        .navigationBarTitle("Select a Container", displayMode: .inline)
    }
}

struct ContainerRow: View {
    var container: Container
    
    var body: some View {
        HStack {
            Image(container.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .padding(.trailing, 10)
            
            VStack(alignment: .leading) {
                Text(container.name)
                    .font(.headline)
                
                Text("Dimensions: \(container.dimensions.joined(separator: "\" x "))\" ")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct Container: Identifiable {
    var id = UUID()
    var name: String
    var dimensions: [String]
    var imageName: String
    var category: String
}
