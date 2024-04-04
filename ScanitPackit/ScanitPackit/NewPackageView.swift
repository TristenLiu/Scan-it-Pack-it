//
//  NewPackageView.swift
//  ScanitPackit
//
//  Created by Daniellia Sumigar on 4/1/24.
//

import SwiftUI

struct NewPackageView: View {
    @State private var manualScreen = false
    @ObservedObject var sharedDims = Dimensions.shared
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
//        NavigationView() {
            VStack () {
                Spacer()
                Text("Select Input Mode")
                    .font(.title)
                    .frame(alignment: .top)
                    .padding() // Add padding at the top
                
                Spacer()
                
                
                NavigationLink(destination: storyboardView().edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)) {
                    VStack (alignment: .leading, spacing: 16.0) {
                        HStack {
                            Image(systemName: "camera")
                                .bold()
                                .foregroundColor(Color.white)
                            Text("Scan")
                                .fontWeight(.bold)
                        }
                        Text("Scan the container and objects to detect dimensions")
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.all)
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .frame(maxWidth: 300)
                }
                .padding()
                
                NavigationLink(destination: ManualInputView(dimensionsList: sharedDims)) {
                    VStack (alignment: .leading, spacing: 16.0) {
                        HStack {
                            Image(systemName: "square.and.pencil")
                                .bold()
                            Text("Manual")
                                .fontWeight(.bold)
                        }
                        Text("Enter dimensions of the container and objects")
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.all)
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .frame(maxWidth: 300)
                    
                    
                }
                .padding()
                
                Spacer()
                
            }
            
        }
//    }
    //.navigationTitle("Select Input Mode")
}

#Preview {
    NewPackageView()
}
