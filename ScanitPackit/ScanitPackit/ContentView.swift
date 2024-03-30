//
//  ContentView.swift
//  ScanitPackit
//
//  Created by Tristen Liu on 3/25/24.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @State private var scanScreen = false
    @State private var manualScreen = false
    @ObservedObject var sharedDims = Dimensions.shared

    
    var body: some View {
        NavigationView {
            VStack {
                Image("scan-it-pack-it-2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                
//                NavigationLink(destination: storyboardView()) {
//                                    HStack {
//                                        Image(systemName: "camera")
//                                        Text("New Scan")
//                                    }
//                                }
                Button(action: {
                    scanScreen = true
                }) {
                    HStack {
                        Image(systemName: "camera")
                        Text("New Scan")
                    }
                }
                .fullScreenCover(isPresented: $scanScreen, content: {
                    storyboardView()
                })
                
                Button("Manual Input") {
                    manualScreen = true
                }
                .fullScreenCover(isPresented: $manualScreen, content: {
                    ManualInputView(dimensionsList: sharedDims)
                })
                
            }
        }
    }
}

struct storyboardView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(identifier: "AreaView")
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}

#Preview {
    ContentView()
}
