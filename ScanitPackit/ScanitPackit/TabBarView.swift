//
//  TabBarView.swift
//  ScanitPackit
//
//  Created by Daniellia Sumigar on 3/31/24.
//

import SwiftUI

enum Tabs: Int {
    case saved = 0
    case home = 1
    case usage = 2
}

struct TabBarView: View {
    
    @State private var selectedTab: Int = 1
    @State private var isShowingNewPackageView = false
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                SessionDataView(selectedTab: $selectedTab, dimensionsList: Dimensions.shared)
                    .tabItem {
                        TabBarButton(buttonText: "Saved",
                                     imageName: "folder",
                                     isActive: selectedTab == 0)
                    }
                    .tint(.secondary)
                    .tag(0)
                
                NewPackageView().edgesIgnoringSafeArea(.all)
                    .tabItem {
                        VStack (alignment: .center, spacing: 4) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 32)
                            
                            Text("New Package")
                        }
                        .foregroundColor(.customDarkBlue) // Setting text color instead of tint
                    }
                    .buttonStyle(PlainButtonStyle())
                    .tag(1)
                
                UsageView()
                    .tabItem {
                        TabBarButton(buttonText: "Usage",
                                     imageName: "questionmark.circle",
                                     isActive: selectedTab == 2)
                    }
                    .tint(.secondary)
                    .tag(2)
            }
            .navigationBarTitle("Scan it! Pack it!", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                showingSettings = true
            }) {
                Image(systemName: "gear")
                    .foregroundColor(.blue)
            })
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
        
        //    var body: some View {
        //        NavigationView {
        //            VStack {
        //                Spacer()
        //                HStack(alignment: .center) {
        //                    Button {
        //                        selectedTab = .saved
        //                    } label: {
        //                        TabBarButton(buttonText: "Saved",
        //                                     imageName: "folder",
        //                                     isActive: selectedTab == .saved)
        //                    }
        //                    .tint(.secondary)
        //
        //                    //                    NavigationLink(destination: NewPackageView().edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)) {
        //                    //                        Button {
        //                    //                            isShowingNewPackageView = true
        //                    //                        } label: {
        //                    //                            VStack (alignment: .center, spacing: 4) {
        //                    //                                Image(systemName: "plus.circle.fill")
        //                    //                                    .resizable()
        //                    //                                    .scaledToFit()
        //                    //                                    .frame(width: 32, height: 32)
        //                    //
        //                    //                                Text("New Package")
        //                    //                            }
        //                    //                        }
        //                    //                        .tint(.customDarkBlue)
        //                    //                    }
        //
        //                    NavigationLink(destination: NewPackageView().edgesIgnoringSafeArea(.all), isActive: $isShowingNewPackageView) {
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
        //                            .foregroundColor(.customDarkBlue) // Setting text color instead of tint
        //                        }
        //                        .buttonStyle(PlainButtonStyle()) // Use PlainButtonStyle to remove the button's default styling
        //                    }
        //
        //                    Button {
        //                        selectedTab = .usage
        //                    } label: {
        //                        TabBarButton(buttonText: "Usage",
        //                                     imageName: "questionmark.circle",
        //                                     isActive: selectedTab == .usage)
        //                    }
        //                    .tint(.secondary)
        //                }
        //                .frame(height: 82)
        //                //.sheet(isPresented: $isShowingNewPackageView) {
        //                //    NewPackageView().edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        //                //}
        //            }
        //        }
        //    }
    }
}

struct SessionDataView: View {
    @Binding var selectedTab: Int
    @ObservedObject var dimensionsList: Dimensions
    @ObservedObject var viewModel = SessionDataViewModel()
    @State private var deleteSession: SessionData?
    @State private var showingClearAllConfirm = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Array(viewModel.SessionDataList.enumerated()), id: \.element.saveDate) { index, session in
                    Button(action: {
                        dimensionsList.containerDims = session.containerDims
                        dimensionsList.boxDims = session.boxDims
                        selectedTab = 1
                    }) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Date: \(session.saveDate, formatter: dateFormatter)")
                                Text("Number of Boxes: \(session.numberOfBoxes)")
                            }
                        }
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationBarTitle("Session History")
            .navigationBarItems(trailing: Button("Clear All") {
                showingClearAllConfirm = true
                print("button pressed")
            }
                .alert(isPresented: $showingClearAllConfirm) {
                    Alert(
                        title: Text("Confirm Clear All"),
                        message: Text("Are you sure you want to delete all sessions? This action cannot be undone."),
                        primaryButton: .destructive(Text("Delete All")) {
                            viewModel.deleteAllSessions()
                        },
                        secondaryButton: .cancel()
                    )
                })
        }
    }
    
    private func delete(at offsets: IndexSet) {
        for index in offsets {
            viewModel.deleteSession(at: index)
        }
    }
}

struct UsageView: View {
    @ObservedObject var viewModel = UsageViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.sections, id: \.title) { section in
                DisclosureGroup(section.title) {
                    ForEach(section.instructions, id: \.self) { instruction in
                        Text(instruction)
                    }
                }
            }
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

#Preview {
    TabBarView(/*selectedTab: .constant(.saved)*/)
}
