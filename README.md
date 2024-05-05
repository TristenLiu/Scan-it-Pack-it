# ![logo](https://github.com/TristenLiu/Scan-it-Pack-it/blob/main/logo.png)


## Project Description
This project, developed for the EC464 Capstone Senior Design Project at Boston University's Electrical & Computer Engineering department 2024, is designed to address sustainability in packaging. Under the guidance of Benyamin Trachtenberg, "Scan It! Pack It!" utilizes advanced technologies such as LiDAR, cloud computing, and machine learning to optimize packaging processes and ensuring efficient resource usage. This project was developed by Tristen Liu, Daniellia Sumigar, Juan Vecino and Ramy Attie.

## Table of Contents
1. [Installation Instructions](#installation-instructions)
2. [How to Use](#how-to-use)
3. [References](#references)

## Installation Instructions

**Hardware Prerequisites:**
- MacOS with Xcode 15 iOS development framework installed.
- iPhone/iPad 12+ Pro with LiDAR capability.

**Detailed Steps:**
*Refer to User Manual for supporting images*

1. Open Xcode and select **Clone Git Repository**.
2. Enter the repository URL: `https://github.com/TristenLiu/Scan-it-Pack-it.git` and click **Clone**.
3. Connect your iPhone/iPad to your MacOS via USB. Keep the Xcode project open and wait for Xcode to connect with your device.
4. Enable **Developer Mode** on your iPhone/iPad:
   - Navigate to **Settings > Privacy & Security > Developer Mode**.
   - Turn on Developer Mode and restart your device to apply changes.
5. If the iOS development framework was not installed during Xcode installation:
   - Click **Get** at the top of the window in Xcode to download necessary simulators and devices while your device is connected.
6. In Xcode, click on the project name **ScanitPackit** (look for the blue app store icon at the top of the file list) to open the app settings.
7. Navigate to **ScanitPackit > Signing & Capabilities**:
   - Next to **Status**, click **Add Account** and sign in with your Apple ID (skip if already signed in).
   - In the **Teams** dropdown, select your Apple ID.
   - Change the bundle identifier's prefix to a unique text value to ensure uniqueness.
8. Select your connected device from the dropdown list at the top of the Xcode window:
   - If your device does not appear, click **Manage Run Destinations** at the bottom of the list and ensure your device is connected properly.
9. Build and run the application on your device by pressing the **Play button** or **CMD+R**. Wait for the cache symbols to be copied.
10. Upon first run, a popup will appear on your device saying “Unable to Verify App”:
    - On your device, go to **Settings > General > VPN & Device Management > Developer App**.
    - Press **Trust “Apple Development: name@example.com”**.
    - Press **Verify App**.
11. If the app does not open after verification, build the application again and attempt to open **ScanitPackit** on your device.


## How to Use
### Scanning Objects
1) Navigate to **Scan** from the home menu.
2) Place the object on a flat surface.
3) Use the (+) button to capture a point, and again on the other point on the edge.
4) Repeat for all edges of the box.
5) For height, rotate the object such that the height edge is flush with the floor.
   
**Notes**
- Keep device steady and maintain a 1ft distance for accuracy.
- Use **Reset All** or **Reset Line** to clear measurements.
- Navigate to Manual Input to remove finished measurements.
- Select object type (container vs packing box) with the [ C | B ] slider.
- Rememeber box scanning order for later packing.

### Manual Inputs
1) Navigate to **Manual Input** from the home menu.
2) Add new fields with **Add Container** or **Add Boxes**.
3) Input dimensions directly or select presets for containers.
4) Press Finish Adding to view the schematic.
   
**Notes**
- Do not leave any fields empty.
- Delete fields by pressing the (-) button.

### Packing Schematic
1) Navigate through different containers and steps using the arrow buttons.
2) Match boxes to containers as indicated.
3) Boxes unable to fit into the provided containers are listed by number.

### General
- The home screen consists of Session History, New Package, Usage Information and Settings.
- View session history by selecting a session, which will bring you to the main home screen with the dimension history loaded.
- Read Usage information by selecting drop down menus in Usage.
- Modify various settings by selecting the top left settings button.

## Engineering Addendum 
By the end of Senior Design, the team was able to accomplish dimension detection via LiDAR scanning and packing solutions for rectangular, fixed-size objects. We would like to expand our project by implementing the remaining [packing algorithm](https://github.com/jerry800416/3D-bin-packing) customization parameters along with automatic dimension detection using LiDAR. The packing algorithm can also pack cylindrical-shaped objects, however we did not integrate this into our final product. Throughout the design process, several methods were explored to complete the scanning module which included obtaining dimensions of bounding boxes generated from Apple's ObjectCapture/RealityKit APIs as demonstrated [here](https://github.com/jigs611989/ARKitDemo) under the 'Scan Real-World Objects with an iOS App' section. However, the team ran into many issues figuring out how to obtain these dimensions and opted for a semi-manual scanning method instead based on the Apple Measure App. Additionally, we've considered using Machine Learning approaches such as NeRFs and [SegmentAnythingin3D](https://github.com/Jumpat/SegmentAnythingin3D/tree/nerfstudio-version) for scanning and dimension detection. These methods would not require LiDAR, making the app more accessible for a wider variety of mobile devices as well as generate 3D irregular shapes. This may be an area worth exploring as future work on this project which would also require updating the packing algorithm to pack 3D irregular-shaped objects. Additionally, factors such as fragility and weight would be other areas to explore in this project in order to provide a more practical solution for users.

An important note is that the [Packing API](https://github.com/juanvecino/scanit_packit_heroku) was built using Flask and deployed on a Heroku cloud server. The Packing API is labelled app.py  in this repository and is set to automatically deploy on the Heroku server. We found that occassionally, the packing algorithm does not produce the most optimal solution, sometimes resulting in unfitted items when there are items that may still fit into the container. We have made the following adjustment to the API where we have set it to randomize the ordering of dimensions of all input objects into the packing algorithm. Based on the output space utilization, we return the "best" packing solution to the user that maximizes this space utilization. Another important note is that in the Scan It! Pack It! app, these adjustments will cause the packing API to take a longer time to return output data for the schematic generation displayed onto the user. This means that while the packing API is deciding on the "best" packing solution, the app will direct into a screen displaying "Packing Data Not Found". However, if you wait enough time, the packing schematic will be generated eventually.

Another adjustment made on the original packing algorithm was commenting out the gravity calculations. This was necessary in order to implement the Multiple Containers feature because the code would run into an error (division by zero) whenever it needed to calculate the gravity distribution of an empty container. This scenario happens when all input objects fit into one container, leaving others empty.

A feature that was implemented in the Packing API but was NOT implemented in the final product was a Minimum Size Container Search. Currently, the packing API returns the information: volume of all input objects, volume of minimum size container, container name. Our intention was to offer a feature to suggest the minimum size container that would fit all objects based on calculating the total input object volume. The necessary model structures were created on the Swift project code but they were never implemented on the user-side. Other features that were intended but not implemented was a way to reset the camera view after rotating the packing schematic and resizing the camera view when toggling between multiple containers. Currently, there is no way to reset the view back to default and when switching from a large container to a small one, the camera angle does not adapt to the change in sizes.

To any future team that may pick up this project - Good Luck :)

## References
- [Measure](https://github.com/adithyabhat/Measure), modified to be Scanning.
- [Packing Algorithm](https://github.com/jerry800416/3D-bin-packing)
- [Packing API](https://github.com/juanvecino/scanit_packit_heroku)

## Contacts
- Tristen Liu (tristenl@bu.edu)
- Daniellia Sumigar (dsumigar@bu.edu)
- Juan Vecino (jvecino@bu.edu)
- Ramy Attie (attiera@bu.edu)
