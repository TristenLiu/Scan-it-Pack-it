# Scan It! Pack It!

## Project Description
This project, developed for the EC464 Capstone Senior Design Project at Boston University's Electrical & Computer Engineering department, is designed to address sustainability in packaging. Under the guidance of Benni Trachtenberg, "Scan It! Pack It!" utilizes advanced technologies such as LiDAR, cloud computing, and machine learning to optimize packaging processes and ensuring efficient resource usage.

## Table of Contents
1. [Installation Instructions](#installation-instructions)
2. [How to Use](#how-to-use)
3. [Examples](#examples)
4. [References](#references)

## Installation Instructions
- **Prerequisites:**
  - MacOS with Xcode 15 installed.
  - iPhone/iPad 12+ Pro with LiDAR.
- **Steps:**
  1. Open Xcode, select **Clone Git Repository**.
  2. Enter `https://github.com/TristenLiu/Scan-it-Pack-it.git` and clone.
  3. Connect your device via USB, wait for Xcode to detect your device.
  4. Enable **Developer Mode** on your device via **Settings > Privacy & Security**.
  5. Navigate to **ScanitPackit > Signing & Capabilities** in Xcode, adjust settings as needed and build the app.
  6. Follow device prompts to trust the developer and verify the app if needed.

## How to Use
### Operation Mode 1: Normal Operation
#### Scanning Objects
- Navigate to **Scan** from the home menu.
- Place the object on a flat surface.
- Use the (+) button to capture each point, repeating for all box edges.
- For height, rotate the object; keep device steady.
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
