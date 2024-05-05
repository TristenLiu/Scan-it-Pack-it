# Software

## Dependency Flowchart
![ScanitPackit_dependencyflowchart](https://github.com/TristenLiu/Scan-it-Pack-it/assets/98703889/64236452-ebae-455b-8860-8fad649f27d1)

## Component Overviews
### Scanning
The scanning portion of this application can be found in the StoryboardFiles directory of the ScanitPackit swift project. The main code file is `AreaViewController.swift` and the screen is built in `Main.storyboard`. `AreaViewController` inherits from `MeasureViewController`, which provides some helper functions for controlling nodes and screen views. In `AreaViewController`, functions are connected to `Main.storyboard` buttons that allow the users to create new point nodes, clear the screen and choose object type to save to Dimensions. The point and line nodes displayed on screen during use are created using the `LineNode.swift` and `SCNSphere+Init.swift` classes, helping the user to see where the nodes are placed in the environment. Additionally, an Observed Object variable is created from the Published variable Dimensions, in order to ensure commonality between the Dimensions used between Scanning, Manual Input and Schematic.

Most of the logic occurs in function `addPoint`, which is triggered whenever a user adds a point to the environment. The center point location is first calculated using the LiDAR. Then, the scene is checked for the number of nodes in the environment. If there are already 6 nodes on screen, then the environment is reset and all nodes are cleared as an object measurement has been completed (6 points to measure per object). Otherwise, a new node is added at the point location for the current scanning state (length, width, height). Then, if the current nodes count is 1 (the first node of an edge measurement), a realTimeLineNode is added allowing the user to visualize a line extending from the created point to the center point in real time. If the current nodes count is 2 (the second node of an edge measurement), then a new LineNode is created with the first and second node as the start and end positions. The distance between the two nodes is calculated, and saved to a dimensions variable based on the `currentState` of the application (length, width or height). If the current state is height, that indicates that the last line required for a box measurement has been measured, and depending on the `[C | B]` slider, the dimensions variable will be appended to either the shared Container Dimesions or shared Box Dimensions variables. 

### Manual Input
The manual portion of this application is built with SwiftUI rather than UIKit. For each container and box in the Observed Object `dimensionsList`, three TextField objects are rendered on the screen allowing the user to modify each value (LWH) directly. Three buttons are rendered below the TextFields, allowing users to add more containers, add more boxes or Finish adding. Currently, a user is only able to finish adding objects through the ManualInputView. Upon pressing `Finish Adding`, the Dimension data will be sent to `ViewModel` and the view will switch to `SchematicView`.

For each TextField in Containers and Boxes, there is a corresponding Binding function with get and set methods. The get method is utilized in order to display the values from `Dimensions` into the TextFields, as well as differentiate between a display value and a value of 0. If the Dimension has a value then the value will be displayed in the field, otherwise the corresponding text "Length/Width/Height (unit)" will be displayed depending on the field position and display unit. The set method is utilized whenever a user changes a value in a TextField. Based on the display unit (inches or centimeters), the user input value will need to be converted to centimeters before being saved to the `dimensionsList` variable. 

### Packing API

### Schematics

### Settings
Two settings are provided for the user. 
  * The first is a Priority toggle, which modifies some settings in the packing API, resulting in a packing schematic that prioritizes boxes with a lower number over higher numbers. 
  * The second setting simply changes the measurement display unit between inches and centimeters. Since the Packing API deals in CM, only the display unit is changed while the `Dimensions` object will always store data in CM.

### Session History
Session history is saved in the application by using the FileManager in Swift as a `SessionData` object. The `SessionData` object stores the UUID, Container dimensions, Box dimensions, save date and number of boxes of the session. The data is saved to the documents directory with the name "SessionData-\(UUID).json", allowing it to be retrieved later by referencing its unique ID and name. All the session data files are retrieved by querying the documents directory for files that start with "SessionData" and then decoded into SessionData objects. Additionally, sessions are deleted by referencing its name and removing it from the FileManager. 

## Dev/Build tool information
  * XCode 15
  * MacOS
  * iOS16+
  * iPhone 12+ Pro

## Software Installation Instructions
1) Install XCode from Apple's Developer site (https://developer.apple.com/xcode/) on a MacOS device
2) After installation, open XCode
3) Select **Clone Git Repository**
4) Enter `https://github.com/TristenLiu/Scan-it-Pack-it.git` and click **Clone**
