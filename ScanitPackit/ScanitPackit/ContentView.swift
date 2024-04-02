//
//  ContentView.swift
//  ScanitPackit
//
//  Created by Tristen Liu on 3/25/24.
//

import SwiftUI
import UIKit

struct ContentView: View {
    
    @State private var manualScreen = false
    @ObservedObject var sharedDims = Dimensions.shared
    @State var selectedTab: Tabs = .saved
    
    var body: some View {
        VStack {
            
            TabBarView(selectedTab: $selectedTab)
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
