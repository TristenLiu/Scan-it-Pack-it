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
The Packing API call can be found in the `ViewModel` file. Here, the input data from `dimensionsList` from the Manual Input screen is parsed into JSON format and sent in as the JSON body for a POST HTTP request. The specified URL is the Heroku server that is located in a separate GitHub, which may be found in the README references section. The API will return an output JSON that is decoded into `packing_data` and is of type `PackingData`. All of the necessary API model structures corresponding to the output JSON body structure are defined in `Models`.

### Schematics
The Packing Schematic is generated using SceneKit and constructs the output schematic based on the packing coordinates returned from the Packing API. Once `packing_data` is queried from the API, the `ViewModel` object is loaded into `SchematicView` as an `ObservableObject`. 

The schematic code has a couple private `@State` variables which may be accessed globally within `SchematicView`. The most important are: 
 * `scene` defines the container holding all nodes to produce the 3D scene
 * `currentIndex` which tracks the count of all boxes within the container
 * `currentContainerIndex` which tracks the count of all containers for the Multiple Containers Feature
   
In order to extract the output JSON data, `ViewModel.packingData` is parsed via two methods: `extractDimensionsAndConvert` and `parseData`. The first will extract the dimensions of the container from the `bin_name` value of the JSON. The second method will extract the `fittedItems`, `unfittedItemsNames`, `colors`, `fittedItemsPositions`, `fittedItemsDimensions`, `fittedItemsNames`, `rotationSetting`, `spaceUtilization`, `containerName`. 

The container is initialized in `createScene` using the bin dimension data extracted from the `extractDimensionsAndConvert` method. Here, a custom material defined in `sm` is applied to all six faces of the container. Additionally, other container material modifiers may be found here to customize the appearance of the box. The container geometry is then added to the main `scene` displayed to the user.

The addition of the objects is handled in the `createBoxes` method which is called whenever the user pressed the forward button in the schematic. These boxes are constructed using the data returned by the `parseData` method. The rotation configuration of each box is also handled here which directly changes the order of the dimensions. Moreover, the color of each box is generated randomly using the `predefinedColors` struct. Finally, this method includes the custom animations of objects gradually entering the scene. All boxes are added as `boxNode` which are child nodes of `scene`.

The deletion of boxes and containers when the user presses the backward button is handled on the `.onChange` modifier for the main `view` struct.

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
