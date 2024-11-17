

# Function to generate the configuration file for Windows Sandbox
param(
    [Parameter(HelpMessage = "Permission for the files i.e. -readonly On/Off")]
    [string]$readonly,

    [Parameter(HelpMessage = "Permission for the vGPU i.e. -vGPU On/Off")]
    [string]$vGPU,

    [Parameter(HelpMessage = "Permission for the Networking i.e. -network On/Off")]
    [string]$network,

    [Parameter(HelpMessage = "Permission for the AudioInput i.e. -audio On/Off")]
    [string]$audio,

    [Parameter(HelpMessage = "Host Folder Path i.e. C:\Sandbox")]
    [string]$hostfolder,

    [Parameter(HelpMessage = "File name to execute in Sandbox i.e. file.exe")]
    [string]$file,

    [Parameter(HelpMessage = "The mapped Sandbox folder i.e C:\sandbox")]
    [string]$sandboxfolder,

    [Parameter(HelpMessage = "Permission for protected client i.e. -protected On/Off")]
    [string]$protected
)
# Import necessary .NET assemblies for Windows Forms and Drawing
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
# Load necessary .NET assemblies
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null

# Generate and execute the WSB file if parameters are provided
if ($hostfolder -and $file -and $sandboxfolder -and $readonly) {
    $wsbFilePath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath("Desktop"), "sandbox.wsb")
    $wsbContent = @"
<?xml version="1.0" encoding="UTF-8"?>
<Configuration>
    <MappedFolders>
        <MappedFolder>
            <HostFolder>$hostfolder</HostFolder>
            <SandboxFolder>$sandboxfolder</SandboxFolder>
        </MappedFolder>
    </MappedFolders>
    <LogonCommand>
        <Command>$sandboxfolder\$file</Command>
    </LogonCommand>
    <ReadOnly>$readonly</ReadOnly>
    <vGPU>$vGPU</vGPU>
    <Networking>$network</Networking>
    <AudioInput>$audio</AudioInput>
    <ProtectedClient>$protected</ProtectedClient>
</Configuration>
"@
    Set-Content -Path $wsbFilePath -Value $wsbContent
    Start-Process -FilePath $wsbFilePath
} else {
    # Create the form for user input
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "GUI Windows Sandbox configuration"
    $form.Size = New-Object System.Drawing.Size(600, 600)

    # Checkbox Controls
    $checkbox2 = New-Object System.Windows.Forms.CheckBox
    $checkbox2.Text = "On/Off Networking"
    $checkbox2.Location = New-Object System.Drawing.Point(50, 70)
    $checkbox2.Size = New-Object System.Drawing.Size(200, 30)

    $checkbox1 = New-Object System.Windows.Forms.CheckBox
    $checkbox1.Text = "On/Off vGPU"
    $checkbox1.Location = New-Object System.Drawing.Point(50, 120)
    $checkbox1.Size = New-Object System.Drawing.Size(200, 30)
    $form.Controls.Add($checkbox1)

    $checkbox4 = New-Object System.Windows.Forms.CheckBox
    $checkbox4.Text = "On/Off AudioInput"
    $checkbox4.Location = New-Object System.Drawing.Point(50, 170)
    $checkbox4.Size = New-Object System.Drawing.Size(200, 30)

    $checkbox3 = New-Object System.Windows.Forms.CheckBox
    $checkbox3.Text = "ReadOnly True/False"
    $checkbox3.Location = New-Object System.Drawing.Point(300, 70)
    $checkbox3.Size = New-Object System.Drawing.Size(200, 30)

    $checkbox5 = New-Object System.Windows.Forms.CheckBox
    $checkbox5.Text = "On/Off Protected Client"
    $checkbox5.Location = New-Object System.Drawing.Point(300, 120)
    $checkbox5.Size = New-Object System.Drawing.Size(250, 30)

    # Host Folder Path Label and TextBox
    $pathLabel = New-Object System.Windows.Forms.Label
    $pathLabel.Location = New-Object System.Drawing.Point(50, 250)
    $pathLabel.Size = New-Object System.Drawing.Size(150, 30)
    $pathLabel.Text = "Host Folder Path:"
    $pathLabel.Font = New-Object System.Drawing.Font("Arial", 10)

    $pathTextBox = New-Object System.Windows.Forms.TextBox
    $pathTextBox.Location = New-Object System.Drawing.Point(200, 250)
    $pathTextBox.Size = New-Object System.Drawing.Size(250, 25)
    $pathTextBox.ReadOnly = $true
    $pathTextBox.Text = "Select path to File"
    $pathTextBox.Font = New-Object System.Drawing.Font("Arial", 10)

    $browseButton = New-Object System.Windows.Forms.Button
    $browseButton.Location = New-Object System.Drawing.Point(460, 250)
    $browseButton.Size = New-Object System.Drawing.Size(75, 25)
    $browseButton.Text = "Browse"
    $browseButton.FlatStyle = 'Flat'
    $browseButton.FlatAppearance.BorderSize = 2

    $browseButton.Add_Click({
        $fileDialog = New-Object System.Windows.Forms.OpenFileDialog
        $fileDialog.Filter = "Executable Files (*.exe)|*.exe"
        $result = $fileDialog.ShowDialog()
        if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
            $pathTextBox.Text = $fileDialog.FileName
        }
    })

    # Arguments Label and TextBox
    $argLabel = New-Object System.Windows.Forms.Label
    $argLabel.Location = New-Object System.Drawing.Point(50, 300)
    $argLabel.Size = New-Object System.Drawing.Size(75, 25)
    $argLabel.Text = "Arguments:"
    $argLabel.Font = New-Object System.Drawing.Font("Arial", 10)

    $argTextBox = New-Object System.Windows.Forms.TextBox
    $argTextBox.Location = New-Object System.Drawing.Point(175, 300)
    $argTextBox.Size = New-Object System.Drawing.Size(300, 25)
    $argTextBox.Font = New-Object System.Drawing.Font("Arial", 10)

    # Clear All Button
    $btnClearAll = New-Object System.Windows.Forms.Button
    $btnClearAll.Location = New-Object System.Drawing.Point(250, 390)
    $btnClearAll.Size = New-Object System.Drawing.Size(150, 40)
    $btnClearAll.Text = "Clear All"
    $btnClearAll.FlatStyle = 'Flat'
    $btnClearAll.FlatAppearance.BorderSize = 4
    $btnClearAll.Add_Click({
        $argTextBox.Text = ""
        $pathTextBox.Text = ""
        $checkbox1.Checked = $false
        $checkbox2.Checked = $false
        $checkbox3.Checked = $false
        $checkbox4.Checked = $false
        $checkbox5.Checked = $false
    })

    # Execute Button
    $executeButton = New-Object System.Windows.Forms.Button
    $executeButton.Location = New-Object System.Drawing.Point(250, 340)
    $executeButton.Size = New-Object System.Drawing.Size(150, 40)
    $executeButton.Text = "Execute"
    $executeButton.FlatStyle = 'Flat'
    $executeButton.FlatAppearance.BorderSize = 4
    $executeButton.Add_Click({
        if ($pathTextBox.Text -ne "Select path to File") {
            $filePath = $pathTextBox.Text
            
            $file = [System.IO.Path]::GetFileName($filePath)
            $folder = [System.IO.Path]::GetDirectoryName($filePath)
            $folderName = Split-Path -Path $folder -Leaf
            $sandboxFolder = "C:\sandbox"  # Default sandbox folder

            if ($checkbox1.Checked) { $vGPU = "On" } else { $vGPU = "Off" }
            if ($checkbox2.Checked) { $network = "On" } else { $network = "Off" }
            if ($checkbox3.Checked) { $readonly = "true" } else { $readonly = "false" }
            if ($checkbox4.Checked) { $audio = "On" } else { $audio = "Off" }
            if ($checkbox5.Checked) { $protected = "On" } else { $protected = "Off" }
     
            $wsbContent = @"
<?xml version="1.0" encoding="UTF-8"?>
<Configuration>
    <MappedFolders>
        <MappedFolder>
            <HostFolder>$folder</HostFolder>
            <ReadOnly>$readonly</ReadOnly>
        </MappedFolder>
    </MappedFolders>
    <LogonCommand>
       <Command>cmd.exe /c start cmd.exe /k "C:\Users\WDAGUtilityAccount\Desktop\$folderName\$file"</Command>
    </LogonCommand>
    <vGPU>$vGPU</vGPU>
    <Networking>$network</Networking>
    <AudioInput>$audio</AudioInput>
    <ProtectedClient>$protected</ProtectedClient>
</Configuration>
"@
            $wsbFilePath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath("Desktop"), "sandbox.wsb")
            Set-Content -Path $wsbFilePath -Value $wsbContent

            try {
                Start-Process -FilePath $wsbFilePath
            } catch {
                [System.Windows.Forms.MessageBox]::Show("Failed to start the sandbox. Error: $_", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            }
        }
    })

    # Add controls to the form
    $form.Controls.AddRange(@(
        $pathLabel, $pathTextBox, $browseButton,
        $argLabel, $argTextBox, $executeButton, $btnClearAll,
        $checkbox1, $checkbox2, $checkbox3, $checkbox4, $checkbox5
    ))

    # Show the form
    $form.ShowDialog()
}
