//
//  TabBarView.swift
//  ScanitPackit
//
//  Created by Daniellia Sumigar on 3/31/24.
//

import SwiftUI

enum Tabs: Int {
    case saved = 0
    case usage = 1
}

struct TabBarView: View {
    
    @Binding var selectedTab: Tabs
    @State private var isShowingNewPackageView = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                HStack(alignment: .center) {
                    Button {
                        selectedTab = .saved
                    } label: {
                        TabBarButton(buttonText: "Saved",
                                               imageName: "folder",
                                               isActive: selectedTab == .saved)
                    }
                    .tint(.secondary)
                    
//                    NavigationLink(destination: NewPackageView().edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)) {
//                        Button {
//                            isShowingNewPackageView = true
//                        } label: {
//                            VStack (alignment: .center, spacing: 4) {
//                                Image(systemName: "plus.circle.fill")
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(width: 32, height: 32)
//
//                                Text("New Package")
//                            }
//                        }
//                        .tint(.customDarkBlue)
//                    }
                    
                    NavigationLink(destination: NewPackageView().edgesIgnoringSafeArea(.all), isActive: $isShowingNewPackageView) {
                        Button {
                            isShowingNewPackageView = true
                        } label: {
                            VStack (alignment: .center, spacing: 4) {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 32, height: 32)
                                
                                Text("New Package")
                            }
                            .foregroundColor(.customDarkBlue) // Setting text color instead of tint
                        }
                        .buttonStyle(PlainButtonStyle()) // Use PlainButtonStyle to remove the button's default styling
                    }
                    
                    Button {
                        selectedTab = .usage
                    } label: {
                        TabBarButton(buttonText: "Usage",
                                               imageName: "questionmark.circle",
                                               isActive: selectedTab == .usage)
                    }
                    .tint(.secondary)
                }
                .frame(height: 82)
                //.sheet(isPresented: $isShowingNewPackageView) {
                //    NewPackageView().edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            //}
            }
        }
    }
}

#Preview {
    TabBarView(selectedTab: .constant(.saved))
}
