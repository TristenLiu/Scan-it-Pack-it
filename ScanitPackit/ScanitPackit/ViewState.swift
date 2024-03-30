//
//  ViewState.swift
//  ScanitPackit
//
//  Created by Tristen Liu on 3/30/24.
//

import SwiftUI
import Combine

class ViewState: ObservableObject {
    static let shared = ViewState()
    @Published var activeScreen: ActiveScreen = .none
}

enum ActiveScreen {
    case none, manualScreen, scanScreen
}
