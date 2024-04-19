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
        UsageSection(title: "App Overview",
                     instructions: ["Welcome to Scan it Pack it!",
                                    "This application was created during the 2023-2024 school year as an ECE Senior Design Project, requested by Benyamin Trachtenberg (btt@bu.edu) and developed by Tristen Liu (tristenl@bu.edu), Daniellia Sumigar (dsumigar@bu.edu), Juan Vecino (jvecino@bu.edu) and Ramy Attie (attiera@bu.edu).",
                                   "The purpose of this application is to be able to determine the optimal schematic to pack a variable number of boxes into a variable number of containers, based on the automatic determination of the dimensions of each object.",
                                   "Our implementation of this goal involves using the LiDAR scanner in iPhones in order to determine the lengths of the three sides of a box, calling a Cloud Computing backend in order to calculate the optimal packing schematic and then displaying that schematic on the screen."]),
        UsageSection(title: "Scanning",
                     instructions: ["1) Press the (+) button on one point of the length of the box select the starting point",
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
                     instructions: ["1) Press Add Container or Add Box to add a new field to the List",
                                    "2) Enter the dimensions of the Container/Box in the respective fields",
                                    "3) When finished entering all dimensions, Press the 'Finish Adding' button to move to the packing schematic",
                                    "---Notes---",
                                    "Select Container Preset options by pressing the grid button on the top right of the Container Field",
                                    "Delete Containers/Boxes by pressing the delete button on the top right of the input field",
                                    "Keep track of box input order for the Packing Schematic"]),
        UsageSection(title: "Packing Schematic",
                     instructions: ["1) On opening, set up the container according to the schematic container format",
                                    "2) Press the right and left arrows to view the different packing order of the input boxes",
                                    "3) Pack the boxes according to the Container number and the Box number on the screen",
                                    "4) Toggle between Multiple Containers using the bottom right and left arrows",
                                   "---Notes---",
                                    "Boxes unable to be fit the provided container will be written on top of the screen",
                                    "The default view of the packing schematic is Top-Down. The bottom side of the container is colored red."]),
        UsageSection(title: "History",
                     instructions: ["1) Select the 'Saved' tab from the home page",
                                    "2) To load a session's data, press on the session",
                                    "3) To delete a session's data, swipe left",
                                    "---Notes---",
                                    "A session's data is always saved when 'Finish Adding' is pressed"]),
        UsageSection(title: "Settings",
                     instructions: ["1) Open the settings by pressing the gear button at the top right of the home page",
                                    "2) Modify the display unit by moving the slider"]),
    ]
}
