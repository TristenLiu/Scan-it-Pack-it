# Software

This application is built entirely within XCode and requires a MacOS with XCode 15 installed for further development. It can be split into four main components: Scanning, Manual Input, Packing and Schematics.

## Dependency Flowchart
![ScanitPackit_dependencyflowchart](https://github.com/TristenLiu/Scan-it-Pack-it/assets/98703889/64236452-ebae-455b-8860-8fad649f27d1)

## Component Overviews
### Scanning
The scanning portion of this application can be found in the StoryboardFiles directory of the ScanitPackit swift project. The main code file is `AreaViewController.swift` and the screen is built in `Main.storyboard`. `AreaViewController` inherits from `MeasureViewController`, which provides some helper functions for controlling nodes and screen views. In `AreaViewController`, functions are connected to `Main.storyboard` buttons that allow the users to create new point nodes, clear the screen and choose object type to save to Dimensions. The point and line nodes displayed on screen during use are created using the `LineNode.swift` and `SCNSphere+Init.swift` classes, helping the user to see where the nodes are placed in the environment. 

Most of the logic occurs in function `addPoint`, which is triggered whenever a user adds a point to the environment. The center point location is first calculated using the LiDAR. Then, the scene is checked for the number of nodes in the environment. If there are already 6 nodes on screen, then the environment is reset and all nodes are cleared as an object measurement has been completed (6 points to measure per object). Otherwise, a new node is added at the point location for the current scanning state (length, width, height). Then, if the current nodes count is 1 (the first node of an edge measurement), a realTimeLineNode is added allowing the user to visualize a line extending from the created point to the center point in real time. If the current nodes count is 2 (the second node of an edge measurement), then a new LineNode is created with the first and second node as the start and end positions. The distance between the two nodes is calculated, and saved to a dimensions variable based on the `currentState` of the application (length, width or height). If the current state is height, that indicates that the last line required for a box measurement has been measured, and depending on the `[C | B]` slider, the dimensions variable will be appended to either the shared Container Dimesions or shared Box Dimensions variables. 

### Manual Input

### Packing API

### Schematics
