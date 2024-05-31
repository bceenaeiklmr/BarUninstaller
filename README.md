# BarUninstaller

**Author:** Bence Markiel (bceenaeiklmr)  
**License:** MIT License  
**Date:** 31.05.2024  
**Version:** 0.1.0  

## Overview

BarUninstaller is an AutoHotkey script designed to manage and remove specific AppX packages related to gaming overlays on Windows 10 and Windows 11. This script provides an easy-to-use interface to check the installation status, remove, and reinstall these packages.

## Features

- Check if certain gaming overlay packages are installed.
- Remove these packages from the system.
- Reinstall the packages via the Microsoft Store.
- Simple graphical user interface (GUI) for ease of use.

## Requirements

- Windows 10 or Windows 11
- AutoHotkey v2.0 or later

## Usage

1. **Download and Install AutoHotkey v2.0+**:
   [AutoHotkey v2.0+](https://www.autohotkey.com/)

2. **Clone or Download the Repository**:

3. **Run the Script**:
Double-click BarUninstaller.ahk to run the script. It will prompt for admin privileges.

### Part 4: Script Details (Functions)

### Functions

- **shellExecCommand(cmd)**
  - Executes a PowerShell command and returns its output.
  - **Parameter**: `cmd` - The PowerShell command to execute.

- **runAsAdmin()**
  - Restarts the script with admin privileges if not already running as admin.

- **exitFn(*)**
  - Kills the script process on exit.
 
### Class: AppxPackageRemover

- **AppxPackageRemover(packageName*)**
  - Constructor for the class.
  - **Parameters**: `packageName*` - The AppX package names to be removed.

- **install()**
  - Opens the Microsoft Store page of the specified AppX package.

- **check()**
  - Checks if the specified AppX packages are installed.

- **remove()**
  - Removes the specified AppX packages and checks if the removal was successful.

- **showPackageInfo(i, *)**
  - Displays package info on mouse hover.


### License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### Contact

For issues, please open a new issue on the [GitHub repository](https://github.com/bceenaeiklmr/barUninstaller/issues).


### Contact

For issues, please open a new issue on the GitHub repository.

## Disclaimer

This script is not affiliated with or endorsed by Microsoft. It is provided "as is" without any warranties, express or implied. Use at your own risk.

