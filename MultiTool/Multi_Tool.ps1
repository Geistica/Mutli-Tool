Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName Microsoft.VisualBasic
Add-Type -AssemblyName System.Windows.Forms
# Declare a variable to store debug messages
$debugMessages = @()

#Choose between path variable if .ps1 or .exe 
$fileExtension = [System.IO.Path]::GetExtension($MyInvocation.MyCommand.Name)
if ($fileExtension -eq ".ps1") {
    $currentScriptDirectory = Split-Path -Parent $((Get-Variable MyInvocation).Value.MyCommand.Path)
} else {
    $currentScriptDirectory = (Get-Location).Path
}

#Functions
# Function to add a debug message to the debug console
function Add-DebugMessage {
  param(
    [string]$message
  )
  $debugMessages += $message
}

# Function to display the debug console
function Show-DebugConsole {
  # Clear the console
  Clear-Host

  # Display the debug messages
  Write-Host "Debug Console" -ForegroundColor Yellow
  Write-Host "----------------"
  $debugMessages | ForEach-Object {
    Write-Host "  - $_"
  }
}

Function Get-FixedDisk {
    [CmdletBinding()]
    # This param() block indicates the start of parameters declaration
    param (
<# 
            This parameter accepts the name of the target computer.
            It is also set to mandatory so that the function does not execute without specifying the value.
        #>
        [Parameter(Mandatory)]
        [string]$Computer
    )
<#
        WMI query command which gets the list of all logical disks and saves the results to a variable named $DiskInfo
    #>
    $DiskInfo = Get-WmiObject Win32_LogicalDisk -ComputerName $Computer -Filter 'DriveType=3'
   $DiskInfo
}

#Path for Icon
$iconPath = $currentScriptDirectory + "\MultiTool\Images\icon.ico"
$currentScript | Add-Content -Path $currentScript -Value "# ICO $iconPath"

# Location of the XAML data / Path
$xamlFile = $currentScriptDirectory + "\MultiTool\MainWindow.xaml"

#create window
$inputXML = Get-Content $xamlFile -Raw
$inputXML = $inputXML -replace 'mc:Ignorable="d"', '' -replace "x:N", 'N' -replace '^<Win.*', '<Window'
[XML]$XAML = $inputXML

#read of XAML
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
try {
    $window = [Windows.Markup.XamlReader]::Load( $reader )
} catch {
    Write-Warning $_.Exception
    throw
}

# Create variable form control Name.
# Variable will be named as 'var_<control name>'

$xaml.SelectNodes("//*[@Name]") | ForEach-Object {
    #"trying item $($_.Name)"
    try {
        Set-Variable -Name "var_$($_.Name)" -Value $window.FindName($_.Name) -ErrorAction Stop
    } catch {
        throw
    }
}
Get-Variable var_*

####################################################################################################
###############################################home#################################################
####################################################################################################

#Start of Displays
#Timer display
$Timer=New-Object System.Windows.Forms.Timer
$Timer_Tick={
    $Var_DisplayRealTime.Content= Get-Date -Format "HH:mm:ss"
    }
    $Timer.Enabled = $True
    $Timer.Interval = 1
    $Timer.add_Tick($Timer_Tick)

#Date display
$Var_DisplayRealDate.Content= Get-Date -Format dd-MM-yyyy
##END OF Displays


#START ABOUT ME___________________________________________________________________________________________#
$Var_Aboutme.Add_Click({
Write-Host "Initiating About Me Window"
# Location von der XAML Datei
$xamlFile = $currentScriptDirectory + "\MultiTool\AboutMe.xaml"

#Create about me window
$inputXML = Get-Content $xamlFile -Raw
$inputXML = $inputXML -replace 'mc:Ignorable="d"', '' -replace "x:N", 'N' -replace '^<Win.*', '<Window'
[XML]$XAML = $inputXML

#read of XAML
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
try {
    $window1 = [Windows.Markup.XamlReader]::Load( $reader )
} catch {
    Write-Warning $_.Exception
    throw
}

# Create variable form control Name.
# Variable will be named as 'var_<control name>'

$xaml.SelectNodes("//*[@Name]") | ForEach-Object {
    #"trying item $($_.Name)"
    try {
        Set-Variable -Name "var_$($_.Name)" -Value $window1.FindName($_.Name) -ErrorAction Stop
    } catch {
        throw
    }
}
Write-Host "About Me Window has been created"
Get-Variable var_*
$Null = $window1.ShowDialog()
})
##END ABOUT ME___________________________________________________________________________________________________#

####################################################################################################
#########################################System Operations##########################################
####################################################################################################
$Var_btn_shutdown.Add_Click({shutdown /s})
$Var_btn_restart.Add_Click({Restart-Computer})
$Var_btn_logout.Add_Click({logoff 1})

#START OF CHANGE PASSWORD OF LOCAL USER SCRIPT___________________________________________________________________#
$var_btn_password.Add_Click({
Write-Host "button password change has been clicked"
#Administrator Permissions check and warning
$adminCheck = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (!$adminCheck) {
    [System.Windows.Forms.MessageBox]::Show("You need admin permissions to use this button.", "Admin permissions required", "OK", "Warning")
}
else {
$username = $env:username
$changepassword = [Microsoft.VisualBasic.Interaction]::InputBox("Please Input New Password for this user:", "Password Changer")
    net user $username $changepassword
    if ($changepassword -eq "") {
    [System.Windows.Forms.MessageBox]::Show("No Password was set, please try again")
} else {
    [System.Windows.Forms.MessageBox]::Show("Password has been changed")
}
}
Write-Host "Script password changer has ended"   
})
##END OF CHANGE PASSWORD OF LOCAL USER SCRIPT______________________________________________________________#

#START OF THE MBR TO GPT CONVERTER SCRIPT__________________________________________________________________#
$var_btn_mbr2gpt.Add_Click({
Write-Host "button mbr2gpt has been clicked"
    #clear the result box
    $var_console.Text = ""
$DriveLetter = [Microsoft.VisualBasic.Interaction]::InputBox("Please Input the Drive you want to convert:", "Mbr2GPT Converter")
    mbr2gpt.exe /allowFullOS /convert /disk:$DriveLetter
    if ($DriveLetter -eq "") {
    [System.Windows.Forms.MessageBox]::Show("No Drive was selected, please try again")
} else {
    [System.Windows.Forms.MessageBox]::Show("Drive $DriveLetter has been converted to gpt")
}
Write-Host "Script mbr2gpt has ended"   
})
##END OF THE MBR TO GPT CONVERTER SCRIPT_____________________________________________________________________#

#START OF THE WINDOWS UPDATE SCRIPT__________________________________________________________________________#
$var_btn_winupdate.Add_Click({
Write-Host "button windows Update has been clicked"
$var_console.Text = ""
# Check if updates are available
$winupdates = Get-WindowsUpdate

#Updates are Available
if ($winupdates) {
    if ($winupdates.Count -eq 1) {
$answer_winupdates = [System.Windows.Forms.MessageBox]::Show("There are updates available, do you want to download and install them?", "Updates Available", [System.Windows.Forms.MessageBoxButtons]::YesNo)
#Install updates
if ($answer_winupdates -eq [System.Windows.Forms.DialogResult]::Yes) {
    Write-Host "Updates will now be downloaded and installed."
    foreach ($update in $updates) {
    $update.KBArticleIDs | % { wusa.exe /quiet /norestart /kb:$_ }
    #Restart
    shutdown /r /t 0
#Do not install updates
}} elseif ($answer_winupdates -eq [System.Windows.Forms.DialogResult]::No) {
    Write-Host "Updates will not be downloaded or installed."
 }
 }
}
#No Updates
else {
    Write-Host "There are currently no updates are available."
}
Write-Host "Script Windows Update has ended"   
})
##END OF WINDOWS UPDATES SCRIPT______________________________________________________________________________#

#START OF REMOVE EMPTY FOLDERS SCRIPT________________________________________________________________________#
$var_btn_empty_folders.Add_Click({
Write-Host "button empty folders has been clicked"
$path = (New-Object -ComObject Shell.Application).BrowseForFolder(0, "Enter the path of the directory you want to scan for empty folders", 0, 0).self.path 
$folders = Get-ChildItem $path -Directory
foreach ($folder in $folders) {
    $isEmpty = (Get-ChildItem $folder.FullName -Force -ErrorAction SilentlyContinue).Count -eq 0
    if ($isEmpty) {
        Remove-Item $folder.FullName -Force -Confirm:$false}
        if (Test-Path $folder.FullName) {
            [System.Windows.Forms.MessageBox]::Show("Folder $($folder.FullName) was not deleted.")
        } else {
            [System.Windows.Forms.MessageBox]::Show("Folder $($folder.FullName) was deleted successfully.")
        }
}
Write-Host "Script Empty Folders has ended" 
})
##END OF REMOVE EMPTY FOLDERS SCRIPT_________________________________________________________________________#

#START OF STATIC IP CREATOR SCRIPT___________________________________________________________________________#
$var_btn_static_IP.Add_Click({
Write-Host "button static Ip has been clicked"
$nic = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "IPEnabled = 'True'"
$IPAddress = $nic.IPAddress[0]

if ($IPAddress -ne $null) {
    $result = [System.Windows.Forms.MessageBox]::Show("A static IP address is already set. Do you want to overwrite it?", "Static IP Address", [System.Windows.Forms.MessageBoxButtons]::YesNo)
    if ($result -eq [System.Windows.Forms.DialogResult]::yes) {
        $nic.EnableDHCP()
    

$IPAddress = [Microsoft.VisualBasic.Interaction]::InputBox("Enter the IP address:", "IP Address")
$SubnetMask = [Microsoft.VisualBasic.Interaction]::InputBox("Enter the subnet mask:", "Subnet Mask")
$DefaultGateway = [Microsoft.VisualBasic.Interaction]::InputBox("Enter the default gateway:", "Default Gateway")
$DNSServer = [Microsoft.VisualBasic.Interaction]::InputBox("Enter the DNS server:", "DNS Server")

 $nic = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "IPEnabled = 'True'"
 $nic.EnableStatic($IPAddress, $SubnetMask)
 $nic.SetGateways($DefaultGateway)
 $nic.SetDNSServerSearchOrder($DNSServer)
 $nic.SetDynamicDNSRegistration("FALSE")

 }else { ($result -eq [System.Windows.Forms.DialogResult]::no)
 $IPAddress = ""
 $SubnetMask = ""
 $DefaultGateway = ""
 $DNSServer = ""

 $nic = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "IPEnabled = 'True'"
 $nic.EnableStatic($IPAddress, $SubnetMask)
 $nic.SetGateways($DefaultGateway)
 $nic.SetDNSServerSearchOrder($DNSServer)
 $nic.SetDynamicDNSRegistration("FALSE")
}
#No Static Ip
}else {[System.Windows.Forms.MessageBox]::Show("No Static Ip has been set", "Static IP Address")
}
Write-Host "Script Static IP has ended" 
})
##END OF STATIC IP CREATOR SCRIPT____________________________________________________________________________#

#START OF THE SAFE BOOT SCRIPT_______________________________________________________________________________#
$Var_btn_safeboot.Add_Click({
Write-Host "button safe boot has been clicked"
$safeBootKey = "HKLM:\SYSTEM\CurrentControlSet\Control\SafeBoot\"

# Check current boot setting
$currentSetting = (Get-ItemProperty $safeBootKey).Minimal

if($currentSetting -eq "Minimal") {
    # Prompt user to confirm boot into Normal Mode
    $choice = [System.Windows.Forms.MessageBox]::Show("The computer is currently in Safe Mode, do you want to boot into Normal Mode?", "Safe Mode", [System.Windows.Forms.MessageBoxButtons]::YesNo)

    if($choice -eq [System.Windows.Forms.DialogResult]::Yes) {
        # Change boot setting to Normal Mode
        Set-ItemProperty $safeBootKey -Name "Minimal" -Value ""

        # Restart computer
        Restart-Computer
    } else {
        # Do nothing
        Write-Host "Boot into Normal Mode cancelled."
    }
} else {
    # Prompt user to confirm boot into Safe Mode
    $choice = [System.Windows.Forms.MessageBox]::Show("Do you want to boot into Safe Mode?", "Safe Mode", [System.Windows.Forms.MessageBoxButtons]::YesNo)

    if($choice -eq [System.Windows.Forms.DialogResult]::Yes) {
        # Change boot setting to Safe Mode
        Set-ItemProperty $safeBootKey -Name "Minimal" -Value "Net"

        # Restart computer
        Restart-Computer
    } else {
        # Do nothing
        Write-Host "Safe Mode boot cancelled."
    }
}
Write-Host "Script safe boot has ended" 
})
##END OF THE SAFE BOOT SCRIPT________________________________________________________________________________#

#START OF THE PC CLEAN UP SCRIPT_____________________________________________________________________________#
$Var_btn_pcclean.Add_Click({
#Delete temp files
Remove-Item -Path "$env:temp\*" -Force -Recurse

#Empty recycle bin
$shell = New-Object -ComObject Shell.Application
$recycleBin = $shell.Namespace(0xA)
$recycleBin.Items() | %{$recycleBin.InvokeVerb("Delete")}

#Delete Internet Explorer temp files
Remove-Item -Path "$env:userprofile\AppData\Local\Microsoft\Windows\Temporary Internet Files\*" -Force -Recurse

#Remove unneeded Windows files
Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1"

#Clear Windows event logs
Clear-EventLog -LogName "Application"
Clear-EventLog -LogName "Security"
Clear-EventLog -LogName "System"
})
##END OF THE PC CLEAN UP SCRIPT______________________________________________________________________________#

####################################################################################################
########################################System Informations#########################################
####################################################################################################

#START OF THE DISPLAYS_______________________________________________________________________________________#
#Ip Adress in ipv4
$ip = Test-Connection -ComputerName (hostname) -Count 1 | Select -ExpandProperty IPV4Address
$var_Testing.Text = $var_Testing.Text + "$ip"

#Display Computer Name
$var_pcname.text = $env:COMPUTERNAME
##END OF DISPLAYS____________________________________________________________________________________________#

#START OF THE DISKINFO SCRIPT________________________________________________________________________________#
$var_btn_diskinfo.Add_Click( {
Write-Host "button diskinfo has been clicked"
       #clear the result box
       $var_txtResults.Text = ""
           if ($result = Get-FixedDisk -Computer $var_pcname.Text) {
               foreach ($item in $result) {
                   $var_txtResults.Text = $var_txtResults.Text + "Device ID: $($item.DeviceID)`n" 
                   $var_txtResults.Text = $var_txtResults.Text + "Volume Name: $($item.VolumeName)`n"
                   $var_txtResults.Text = $var_txtResults.Text + "Free Space: " + [Math]::Round(($item.FreeSpace/1GB), 2) + "GB`n"
                   $var_txtResults.Text = $var_txtResults.Text + "Size: " + [Math]::Round(($item.Size/1GB), 2) + "GB"
               }
           }
           Write-Host "Script diskinfo has ended"    
       })
##END OF THE DISKINFO SCRIPT________________________________________________________________________________#

#START OF THE DEVICE SPECIFICATION SCRIPT___________________________________________________________________#
$var_btn_specs.Add_Click( {
Write-Host "button specifications has been clicked"
    #clear the result box
    $var_txtResults.Text = ""
              $var_txtResults.Text = $var_txtResults.Text + "Operating System: $((Get-CimInstance -ClassName Win32_OperatingSystem).Caption)`n"
              $var_txtResults.Text = $var_txtResults.Text + "CPU: $((Get-CimInstance -ClassName Win32_Processor).Name)`n"
              $var_txtResults.Text = $var_txtResults.Text + "RAM: $((Get-CimInstance -ClassName Win32_ComputerSystem).TotalPhysicalMemory / 1GB) GB`n"
              $var_txtResults.Text = $var_txtResults.Text + "GPU: $((Get-CimInstance -ClassName Win32_VideoController).Name)`n"
              $var_txtResults.Text = $var_txtResults.Text + "Bios Vers: $((Get-CimInstance -ClassName Win32_BIOS).Name)`n"
              $var_txtResults.Text = $var_txtResults.Text + "Win Vers detailed: $([System.Environment]::OSVersion.Version)`n"
              $var_txtResults.Text = $var_txtResults.Text + "Win Vers: $(Get-ComputerInfo | select windowsversion)`n"
              Write-Host "Script specifications has ended"   
            })
##END OF THE SPECIFICATION SCRIPT__________________________________________________________________________#

#START OF THE BATTERY INFO SCRIPT__________________________________________________________________________#
$var_btn_battery.Add_Click( {
Write-Host "button battery info has been clicked"
$saveLocation = (New-Object -ComObject Shell.Application).BrowseForFolder(0, "Select a location to save the file", 0, 0).self.path
powercfg /batteryreport /output "$saveLocation\Battery-Info.html"
ii "$saveLocation\Battery-Info.html"
Write-Host "Script battery info has ended"   
})
##END OF THE BATTERY INFO SCRIPT__________________________________________________________________________#

####################################################################################################
############################################Quick Access############################################
####################################################################################################
#Start Task Manager
$var_btn_taskmngr.Add_Click( {
Write-Host "Starting Task Manager" 
Start-Process -FilePath "taskmgr.exe"
})

#Start Services
$var_btn_services.Add_Click( {
Write-Host "Starting Services" 
Start-Process -FilePath "services.msc"
})

#Start Control Panel
$var_btn_services.Add_Click( {
Write-Host "Starting Control Panel" 
Start-Process -FilePath "services.msc"
})

#Start Device Manager
$var_btn_devmgmt.Add_Click( {
Write-Host "Starting Device Manager" 
Start-Process -FilePath "devmgmt.msc"
})

#Start Defragment and optimize Drives
$var_btn_defrag.Add_Click( {
Write-Host "Starting Defragment and optimize Drives" 
Start-Process -FilePath "dfrgui.exe"
})

#Start Powershell
$var_btn_powershell.Add_Click( {
Write-Host "Starting Powershell" 
Start-Process -FilePath "powershell.exe"
})

#Start Command Panel
$var_btn_cmd.Add_Click( {
Write-Host "Starting Command Panel" 
Start-Process -FilePath "cmd.exe" -Verb RunAs
})

#Start Firewall
$var_btn_firewall.Add_Click( {
Write-Host "Starting Firewall" 
Start-Process -FilePath "wf.msc"
})

#Start Windows Settings
$var_btn_winset.Add_Click( {
Write-Host "Starting Windows Settings" 
Start-Process -FilePath "ms-settings:"
})

#Start Registry Editor
$var_btn_regedit.Add_Click( {
Write-Host "Starting Registry Editor" 
Start-Process -FilePath "regedit.exe"
})

#Start System Configuration
$var_btn_sysconfig.Add_Click( {
Write-Host "Starting System Configuration" 
Start-Process -FilePath "msconfig.exe" -Verb RunAs
})

#Start Task Scheduler
$var_btn_taskscheduler.Add_Click( {
Write-Host "Starting Task Scheduler" 
Start-Process -FilePath "taskschd.msc" -Verb RunAs
})

#Start Ressource Monitor
$var_btn_resmon.Add_Click( {
Write-Host "Starting Ressource Monitor"
Start-Process -FilePath "resmon.exe"
})

#Start Print Managment
$var_btn_printmgmt.Add_Click( {
Write-Host "Starting Print Management"
Start-Process -FilePath "printmanagement.msc"
})

#Start Event Viewer
$var_btn_eventview.Add_Click( {
Write-Host "Starting Event Viewer"
Start-Process -FilePath "eventvwr.msc"
})

###################################################################################
# Display the debug console
Show-DebugConsole
#DO NOT TOUCH
$Null = $window.ShowDialog()
###################################################################################