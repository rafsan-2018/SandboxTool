# Windows Sandbox Configuration Tool
The Windows Sandbox Configuration Tool is a user-friendly graphical interface designed to simplify the generation of configuration files for Windows Sandbox. This tool streamlines the process of configuring various settings such as folder mappings, networking, audio and video input, vGPU utilization, logon commands, and execution of the sandbox configuration file.

## Launching the Application
To launch the application:

Ensure that PowerShell is installed on your system.
Save the provided script to a GUI.ps1
Open PowerShell as an administrator or CMD
Navigate to the directory where the script is saved.
Execute the script by typing .\GUI.ps1 and pressing Enter.
OR esure the right path  put in the CMD  then run the GUI file trought the line : powershell.exe -Executionpolicy Bypass -File GUI.ps1 

# Configuration

Use the GUI to set executable permissions within the sandbox.
Browse to select the Host Folder Path containing the executable.
Specify the executable name and the sandbox folder path

## Folder Mapping
    Host Folder: Specify the path of the folder on the host system to be mapped into the sandbox.
    Sandbox Folder: Enter the destination path within the sandbox where the host folder will be mapped.
    Read Only: Check this box to make the mapped folder read-only within the sandbox.
     
## Sandbox Permissions
    Networking: Check to on networking within the sandbox.
    Audio Input: Check to on audio input within the sandbox.
    Video Input: Check to on video input within the sandbox.
    vGPU: Check to on virtual GPU (vGPU) within the sandbox.

## Execution
    Click the Execute button. This will generate the .wsb file based on the provided inputs and execute it.

## Usage
    Fill in the required information in the input fields and checkboxes as per your sandbox configuration requirements.
    Click the Browse button to select the host folder path. The path will be displayed in the Host Folder Path text box.    
    Click the "execute" button to execute the sandbox configuration file with the settings you have just selected.

## Notes
Location of Sandbox Folder: C:\Users\Desktop