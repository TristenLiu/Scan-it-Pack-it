//
//  ContentView.swift
//  ScanitPackit
//
//  Created by Tristen Liu on 3/25/24.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Image("scan-it-pack-it-2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                
                NavigationLink(destination: storyboardView()) {
                    HStack {
                        Image(systemName: "camera")
                        Text("New Scan")
                    }
                }

                NavigationLink("Manual Input", destination: ManualInputView())
                .padding()
                
                NavigationLink(destination: SchematicView(viewModel: viewModel)) {
                    Text("Test Schematic")
                        .onAppear {
                            viewModel.fetch {
                                // Trigger navigation here
                            }
                        }
                }
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
