//
//  UsageViewModel.swift
//  ScanitPackit
//
//  Created by Tristen Liu on 4/13/24.
//

import Foundation
import Combine

struct UsageSection {
    let title: String
    let instructions: [String]
}

class UsageViewModel: ObservableObject {
    @Published var sections: [UsageSection] = [
        UsageSection(title: "Scanning", 
                     instructions: ["1) Press the (+) button on one point of the length of the                   box select the starting point",
                                    "2) Press the (+) on the other endpoint on the same length of the box to finish the edge measurement",
                                    "3) Repeat steps 1&2 two more times on the width and the height of the box",
                                    "4) To finish, return to the Manual Input screen",
                                    "---Notes---",
                                    "Press Reset All to reset all measurements",
                                    "Press Reset Line to reset current measurement",
                                    "Maintain a distance of at least 1ft(0.3m) for best accuracy",
                                    "Toggle the Slider in order to register Container or Box dimensions",
                                    "Keep track of box input order for the Packing Schematic"]),
        UsageSection(title: "Manual Input",
                     instructions: ["1) Press Add Container or Add Box to add a new field to the                 List",
                                    "2) Enter the dimensions of the Container/Box in the respective fields",
                                    "3) When finished entering all dimensions, Press the 'Finish Adding' button to move to the packing schematic",
                                    "---Notes---",
                                    "Select Container Preset options by pressing the grid button on the top right of the Container Field",
                                    "Delete Containers/Boxes by pressing the delete button on the top right of the input field",
                                    "Keep track of box input order for the Packing Schematic"]),
        UsageSection(title: "Packing Schematic",
                     instructions: ["1) On opening, set up the container according to the                        schematic container format",
                                    "2) Press the right and left arrows to view the different packing order of the input boxes",
                                    "3) Pack the boxes according to the Container number and the Box number on the screen",
                                   "---Notes---", 
                                    "Boxes unable to be fit the provided container will be written on top of the screen"]),
        UsageSection(title: "History",
                     instructions: ["1) Select the 'Saved' tab from the home page",
                                    "2) To load a session's data, press on the session",
                                    "3) To delete a session's data, press on the trash button or swipe left",
                                    "---Notes---",
                                    "A session's data is always saved when 'Finish Adding' is pressed"]),
        UsageSection(title: "Settings",
                     instructions: ["1) Open the settings by pressing the gear button at the top right of the home page",
                                    "2) Modify the display unit by moving the slider"]),
    ]
}
