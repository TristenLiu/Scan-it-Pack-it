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
    
    var body: some View {
            TabView(selection: $selectedTab) {
                BoxSessionsListView()
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

struct BoxSessionsListView: View {
    @ObservedObject var viewModel = SessionDataViewModel()
    @State private var deleteSession: SessionData?

    var body: some View {
        NavigationView {
            List {
                ForEach(Array(viewModel.SessionDataList.enumerated()), id: \.element.saveDate) { index, session in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Date: \(session.saveDate, formatter: dateFormatter)")
                            Text("Number of Boxes: \(session.numberOfBoxes)")
                        }
                        Spacer()
                        Button(action: {
                            self.deleteSession = session
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
                .onDelete(perform: delete) 
            }
            .navigationBarTitle("Saved Box Sessions")
            .alert(item: $deleteSession) { session in
                        Alert(
                            title: Text("Confirm Delete"),
                            message: Text("Are you sure you want to delete this session?"),
                            primaryButton: .destructive(Text("Delete")) {
                                if let index = viewModel.SessionDataList.firstIndex(where: { $0.id == session.id }) {
                                    viewModel.deleteSession(at: index)
                                }
                            },
                            secondaryButton: .cancel()
                        )
                    }
        }
    }
    
    private func delete(at offsets: IndexSet) {
            for index in offsets {
                viewModel.deleteSession(at: index)
            }
        }
}

struct UsageView: View {
    var body: some View {
        VStack {
            Text("Temporary Usage Instructions")
        }
    }
}

private let dateFormatter: DateFormatter = {
    print("formatting Dates")
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

#Preview {
    TabBarView(/*selectedTab: .constant(.saved)*/)
}
