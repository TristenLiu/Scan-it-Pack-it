# ![logo](https://github.com/TristenLiu/Scan-it-Pack-it/blob/main/logo.png)


## Project Description
This project, developed for the EC464 Capstone Senior Design Project at Boston University's Electrical & Computer Engineering department 2024, is designed to address sustainability in packaging. Under the guidance of Benyamin Trachtenberg, "Scan It! Pack It!" utilizes advanced technologies such as LiDAR, cloud computing, and machine learning to optimize packaging processes and ensuring efficient resource usage. This project was developed by Tristen Liu, Daniellia Sumigar, Juan Vecino and Ramy Attie.

## Table of Contents
1. [Installation Instructions](#installation-instructions)
2. [How to Use](#how-to-use)
3. [References](#references)

## Installation Instructions

**Prerequisites:**
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


## References
- [Measure](https://github.com/adithyabhat/Measure), modified to be Scanning.

## Contacts
- Tristen Liu (tristenl@bu.edu)
- Daniellia Sumigar (dsumigar@bu.edu)
- Juan Vecino (jvecino@bu.edu)
- Ramy Attie (attiera@bu.edu)
