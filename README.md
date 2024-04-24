# Scan It! Pack It!

## Project Description
This project, developed for the EC464 Capstone Senior Design Project at Boston University's Electrical & Computer Engineering department, is designed to address sustainability in packaging. Under the guidance of Benni Trachtenberg, "Scan It! Pack It!" utilizes advanced technologies such as LiDAR, cloud computing, and machine learning to optimize packaging processes and ensuring efficient resource usage.

## Table of Contents
1. [Installation Instructions](#installation-instructions)
2. [How to Use](#how-to-use)
3. [Examples](#examples)
4. [References](#references)

## Installation Instructions

**Prerequisites:**
- MacOS with Xcode 15 iOS development framework installed.
- iPhone/iPad 12+ Pro with LiDAR capability.
- Refer to Appendix 7.2 for guiding images if needed.

**Detailed Steps:**
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
### Operation Mode 1: Normal Operation
#### Scanning Objects
- Navigate to **Scan** from the home menu.
- Place the object on a flat surface.
- Use the (+) button to capture each point, repeating for all box edges.
- For height, rotate the object.
- Keep device steady and maintain a 1ft distance for accuracy.
- Use **Reset All** or **Reset Line** to clear measurements.
- Select object type with the [ C | B ] slider.
- Maintain a 1ft distance for accuracy.

#### Manual Input Screen
- Add new fields with **Add Container** or **Add Boxes**.
- Input dimensions directly or select presets.
- Delete or finish adding objects to view the schematic.

#### Schematic View
- Navigate through different schematic views using arrows.
- Match boxes to containers as indicated.
- Unfit boxes are listed by number.

### Operation Mode 2: Abnormal Operation
#### Scanning
- Reset and reposition if the object is too close or nodes drift.
- Object movement is permissible after edge scanning.

#### Manual Input
- Ensure all fields are filled; otherwise, the API fails.
- Delete or fill empty fields as needed.

### General
- Use the home screen for scanning, manual input, and session management.
- Modify settings like display units and packing priority in **Settings**.

## Examples
(TBA - Provide usage examples and screenshots once the application is finalized.)

## References
(TBA - Include any references and resources used in the development of the application.)
