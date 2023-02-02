Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName Microsoft.VisualBasic
Add-Type -AssemblyName System.Windows.Forms
Import-Module PSWindowsUpdate

#===========================================================================
# Functions
#===========================================================================

# Declare a variable to store debug messages
$debugMessages = @()

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

#XAML File Main Window
$inputXML = @"
<Window x:Class="MultiTool.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:MultiTool"
        mc:Ignorable="d"
        Title="Multi Tool V1.0" Height="470" Width="825" ShowInTaskbar="False" Background="#FF3D4146" Foreground="#FF36393E" MinHeight="470" MinWidth="825">
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition/>
        </Grid.RowDefinitions>
        <TabControl BorderBrush="#FF36393E" Background="Black">
            <TabItem Header="Home" Margin="-2,-2,2,2" Height="20" Width="45" Background="#FF2C2F33" BorderBrush="#FF424549" Foreground="#FF747272">
                <Grid>
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition/>
                    </Grid.ColumnDefinitions>
                    <Grid.Background>
                        <LinearGradientBrush EndPoint="0.5,1" StartPoint="0.5,0">
                            <GradientStop Color="#FF2C2F33"/>
                            <GradientStop Color="#FF282B30" Offset="1"/>
                        </LinearGradientBrush>
                    </Grid.Background>
                    <Rectangle HorizontalAlignment="Left" Height="26" Margin="593,56,0,0" Stroke="Black" VerticalAlignment="Top" Width="81" Fill="#FF424549" RadiusX="5" RadiusY="5"/>
                    <Rectangle HorizontalAlignment="Left" Height="26" Margin="593,25,0,0" Stroke="Black" VerticalAlignment="Top" Width="81" Fill="#FF424549" RadiusX="5" RadiusY="5"/>
                    <Label Content="Current Time:" HorizontalAlignment="Left" Margin="593,25,0,0" VerticalAlignment="Top" Height="26">
                        <Label.Background>
                            <SolidColorBrush Color="White" Opacity="0"/>
                        </Label.Background>
                    </Label>
                    <Label x:Name="DisplayRealTime" HorizontalAlignment="Left" Margin="685,25,0,0" VerticalAlignment="Top" Width="81" Background="White" Height="25"/>
                    <Label Content="Current Date:" HorizontalAlignment="Left" Margin="593,56,0,0" VerticalAlignment="Top" Height="26">
                        <Label.Background>
                            <SolidColorBrush Color="White" Opacity="0"/>
                        </Label.Background>
                    </Label>
                    <Label x:Name="DisplayRealDate" HorizontalAlignment="Left" Margin="685,57,0,0" VerticalAlignment="Top" Width="81" Background="White" Height="25"/>
                    <TextBlock HorizontalAlignment="Left" Margin="34,30,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Height="219" Width="487" Foreground="#FFCECECE" FontSize="14"><Run Text="Hey thanks a lot for using this script. "/><LineBreak/><Run Text="I will continue to write this script to be able to perform more work faster."/><LineBreak/><Run Text="Do not hesitate to report any bugs on my github."/><LineBreak/><LineBreak/><Run Text="This is my first time having created such a powershell script."/><LineBreak/><LineBreak/><Run Language="de-ch" Text="I wish you much fun with my script :)"/><LineBreak/><Run/><LineBreak/><Run/><LineBreak/><Run/></TextBlock>
                    <Button x:Name="Aboutme" Content="About Me" HorizontalAlignment="Left" Margin="34,257,0,0" VerticalAlignment="Top" Background="#FF36393E" Foreground="#FF949494" Width="60" Height="20" MinWidth="60" MinHeight="20"/>
                    <Button x:Name="github" Content="Github and Features" HorizontalAlignment="Left" Margin="118,257,0,0" VerticalAlignment="Top" Background="#FF36393E" Foreground="#FF949494"/>
                </Grid>
            </TabItem>
            <TabItem Header="System Operations" Background="#FF2C2F33" Margin="-2,-2,2,2" Height="20" Width="115" BorderBrush="#FF424549" Foreground="#FF747272">
                <Grid>
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="0*"/>
                        <ColumnDefinition/>
                    </Grid.ColumnDefinitions>
                    <Grid.Background>
                        <LinearGradientBrush EndPoint="0.5,1" StartPoint="0.5,0">
                            <GradientStop Color="#FF23272A" Offset="1"/>
                            <GradientStop Color="#FF282B30"/>
                        </LinearGradientBrush>
                    </Grid.Background>
                    <Rectangle Grid.ColumnSpan="2" HorizontalAlignment="Left" Height="32" Margin="50,175,0,0" Stroke="Black" VerticalAlignment="Top" Width="122" Fill="#FF566EB2" RadiusX="5" RadiusY="5"/>
                    <Rectangle Grid.ColumnSpan="2" HorizontalAlignment="Left" Height="32" Margin="50,225,0,0" Stroke="Black" VerticalAlignment="Top" Width="122" Fill="#FF697FC5" RadiusX="5" RadiusY="5"/>
                    <Rectangle Grid.ColumnSpan="2" HorizontalAlignment="Left" Height="32" Margin="50,125,0,0" Stroke="Black" VerticalAlignment="Top" Width="122" Fill="#FF435EA0" RadiusX="5" RadiusY="5"/>
                    <Rectangle Grid.ColumnSpan="2" HorizontalAlignment="Left" Height="32" Margin="50,75,0,0" Stroke="Black" VerticalAlignment="Top" Width="122" Fill="#FF304E8E" RadiusX="5" RadiusY="5"/>
                    <Rectangle Grid.ColumnSpan="2" HorizontalAlignment="Left" Height="32" Margin="49,25,0,0" Stroke="Black" VerticalAlignment="Top" Width="122" Fill="#FF304E8E" RadiusX="5" RadiusY="5"/>
                    <Button x:Name="btn_shutdown" Content="Shutdown System" HorizontalAlignment="Left" Margin="50,26,0,0" VerticalAlignment="Top" Height="30" Width="120" Grid.ColumnSpan="2">
                        <Button.BorderBrush>
                            <SolidColorBrush Color="#FF707070" Opacity="0"/>
                        </Button.BorderBrush>
                        <Button.Background>
                            <SolidColorBrush Color="#FFDDDDDD" Opacity="0"/>
                        </Button.Background>
                    </Button>
                    <Button x:Name="btn_restart" Content="Restart System" HorizontalAlignment="Left" Margin="51,76,0,0" VerticalAlignment="Top" Height="30" Width="120" Grid.ColumnSpan="2">
                        <Button.BorderBrush>
                            <SolidColorBrush Color="#FF707070" Opacity="0"/>
                        </Button.BorderBrush>
                        <Button.Background>
                            <SolidColorBrush Color="#FFDDDDDD" Opacity="0"/>
                        </Button.Background>
                    </Button>
                    <Button x:Name="btn_mbr2gpt" Content="MBR2GPT" HorizontalAlignment="Left" Margin="51,176,0,0" VerticalAlignment="Top" Height="30" Width="120" Grid.ColumnSpan="2">
                        <Button.BorderBrush>
                            <SolidColorBrush Color="#FF707070" Opacity="0"/>
                        </Button.BorderBrush>
                        <Button.Background>
                            <SolidColorBrush Color="#FFDDDDDD" Opacity="0"/>
                        </Button.Background>
                    </Button>
                    <Button x:Name="btn_password" Content="Password" HorizontalAlignment="Left" Margin="51,226,0,0" VerticalAlignment="Top" Height="30" Width="120" Grid.ColumnSpan="2">
                        <Button.BorderBrush>
                            <SolidColorBrush Color="#FF707070" Opacity="0"/>
                        </Button.BorderBrush>
                        <Button.Background>
                            <SolidColorBrush Color="#FFDDDDDD" Opacity="0"/>
                        </Button.Background>
                    </Button>
                    <Rectangle Grid.ColumnSpan="2" HorizontalAlignment="Left" Height="32" Margin="200,175,0,0" Stroke="Black" VerticalAlignment="Top" Width="122" Fill="#FF566EB2" RadiusX="5" RadiusY="5"/>
                    <Button x:Name="btn_winupdate" Content="*Check Win Updates*" HorizontalAlignment="Left" Margin="201,176,0,0" VerticalAlignment="Top" Height="30" Width="120" Grid.ColumnSpan="2">
                        <Button.BorderBrush>
                            <SolidColorBrush Color="#FF707070" Opacity="0"/>
                        </Button.BorderBrush>
                        <Button.Background>
                            <SolidColorBrush Color="#FFDDDDDD" Opacity="0"/>
                        </Button.Background>
                    </Button>
                    <TextBox x:Name="console" Grid.ColumnSpan="2" HorizontalAlignment="Left" Margin="401,42,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="339" Height="273" Background="Black" Foreground="White" VerticalScrollBarVisibility="Visible" Visibility="Hidden"/>
                    <Rectangle Grid.ColumnSpan="2" HorizontalAlignment="Left" Height="32" Margin="200,225,0,0" Stroke="Black" VerticalAlignment="Top" Width="122" Fill="#FF697FC5" RadiusX="5" RadiusY="5"/>
                    <Rectangle Grid.ColumnSpan="2" HorizontalAlignment="Left" Height="32" Margin="200,125,0,0" Stroke="Black" VerticalAlignment="Top" Width="122" Fill="#FF435EA0" RadiusX="5" RadiusY="5"/>
                    <Button x:Name="btn_static_IP" Content="Create Static IP" HorizontalAlignment="Left" Margin="201,226,0,0" VerticalAlignment="Top" Height="30" Width="120" Grid.ColumnSpan="2">
                        <Button.BorderBrush>
                            <SolidColorBrush Color="#FF707070" Opacity="0"/>
                        </Button.BorderBrush>
                        <Button.Background>
                            <SolidColorBrush Color="#FFDDDDDD" Opacity="0"/>
                        </Button.Background>
                    </Button>
                    <Rectangle Grid.ColumnSpan="2" HorizontalAlignment="Left" Height="32" Margin="200,25,0,0" Stroke="Black" VerticalAlignment="Top" Width="122" Fill="#FF304E8E" RadiusX="5" RadiusY="5"/>
                    <Button x:Name="btn_safeboot" Content="Safe Boot" HorizontalAlignment="Left" Margin="201,26,0,0" VerticalAlignment="Top" Height="30" Width="120" Grid.ColumnSpan="2" RenderTransformOrigin="0.496,1.29">
                        <Button.BorderBrush>
                            <SolidColorBrush Color="#FF707070" Opacity="0"/>
                        </Button.BorderBrush>
                        <Button.Background>
                            <SolidColorBrush Color="#FFDDDDDD" Opacity="0"/>
                        </Button.Background>
                    </Button>
                    <Rectangle Grid.ColumnSpan="2" HorizontalAlignment="Left" Height="32" Margin="200,75,0,0" Stroke="Black" VerticalAlignment="Top" Width="122" Fill="#FF304E8E" RadiusX="5" RadiusY="5"/>
                    <Button x:Name="btn_pcclean" Content="PC Clean Up" HorizontalAlignment="Left" Margin="51,126,0,0" VerticalAlignment="Top" Height="30" Width="120" Grid.ColumnSpan="2">
                        <Button.BorderBrush>
                            <SolidColorBrush Color="#FF707070" Opacity="0"/>
                        </Button.BorderBrush>
                        <Button.Background>
                            <SolidColorBrush Color="#FFDDDDDD" Opacity="0"/>
                        </Button.Background>
                    </Button>
                    <Button x:Name="btn__logout" Content="Log Out Current User" HorizontalAlignment="Left" Margin="201,76,0,0" VerticalAlignment="Top" Height="30" Width="120" Grid.ColumnSpan="2">
                        <Button.BorderBrush>
                            <SolidColorBrush Color="#FF707070" Opacity="0"/>
                        </Button.BorderBrush>
                        <Button.Background>
                            <SolidColorBrush Color="#FFDDDDDD" Opacity="0"/>
                        </Button.Background>
                    </Button>
                    <Button x:Name="btn_empty_folders" Content="Remove Empty Folders" HorizontalAlignment="Left" Margin="202,127,0,0" VerticalAlignment="Top" Height="30" Width="120" Grid.ColumnSpan="2" FontSize="11">
                        <Button.BorderBrush>
                            <SolidColorBrush Color="#FF707070" Opacity="0"/>
                        </Button.BorderBrush>
                        <Button.Background>
                            <SolidColorBrush Color="#FFDDDDDD" Opacity="0"/>
                        </Button.Background>
                    </Button>
                </Grid>
            </TabItem>
            <TabItem Header="System Information" Margin="-3,-2,-2,2" Height="20" BorderBrush="#FF424549" Background="#FF2C2F33" Foreground="#FF747272">
                <Grid>
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition/>
                    </Grid.ColumnDefinitions>
                    <Grid.Background>
                        <LinearGradientBrush EndPoint="0.5,1" StartPoint="0.5,0">
                            <GradientStop Color="#FF2C2F33"/>
                            <GradientStop Color="#FF23272A" Offset="1"/>
                        </LinearGradientBrush>
                    </Grid.Background>
                    <Rectangle HorizontalAlignment="Left" Height="37" Margin="603,75,0,0" Stroke="Black" VerticalAlignment="Top" Width="77" Fill="#FF697FC5" RadiusX="5" RadiusY="5"/>
                    <Rectangle HorizontalAlignment="Left" Height="37" Margin="603,25,0,0" Stroke="Black" VerticalAlignment="Top" Width="77" Fill="#FF697FC5" RadiusX="5" RadiusY="5"/>
                    <Rectangle HorizontalAlignment="Left" Height="37" Margin="513,25,0,0" Stroke="Black" VerticalAlignment="Top" Width="77" Fill="#FF697FC5" RadiusX="5" RadiusY="5"/>
                    <TextBox x:Name="iptextbox" HorizontalAlignment="Left" Margin="187,33,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="156" Height="26" IsEnabled="False">
                        <TextBox.Background>
                            <SolidColorBrush Color="#FF959595" Opacity="0.995"/>
                        </TextBox.Background>
                        <TextBox.BorderBrush>
                            <SolidColorBrush Color="#FFABADB3" Opacity="1"/>
                        </TextBox.BorderBrush>
                    </TextBox>
                    <TextBox x:Name="pcname" HorizontalAlignment="Left" Margin="187,64,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="156" Height="26" IsEnabled="False" Background="#FF959595"/>
                    <Button x:Name="btn_diskinfo" Content="Disks" HorizontalAlignment="Left" Margin="514,26,0,0" VerticalAlignment="Top" Height="35" Width="75" BorderThickness="1,1,1,0" Foreground="Black">
                        <Button.Background>
                            <SolidColorBrush Color="White" Opacity="0"/>
                        </Button.Background>
                        <Button.BorderBrush>
                            <SolidColorBrush Color="White" Opacity="0.01"/>
                        </Button.BorderBrush>
                    </Button>
                    <TextBox x:Name="txtResults" HorizontalAlignment="Left" Margin="42,105,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="437" Height="291" HorizontalScrollBarVisibility="Disabled" VerticalScrollBarVisibility="Visible" ScrollViewer.CanContentScroll="True" UndoLimit="100" Background="Black" Foreground="White"/>
                    <Label Content="Host-IPAddress" HorizontalAlignment="Left" Margin="77,33,0,0" VerticalAlignment="Top" Foreground="White"/>
                    <Label Content="Host-Name" HorizontalAlignment="Left" Margin="87,64,0,0" VerticalAlignment="Top" Foreground="White"/>
                    <Button x:Name="btn_specs" Content="Specs" HorizontalAlignment="Left" Margin="603,26,0,0" VerticalAlignment="Top" Height="35" Width="77" BorderThickness="0,0,0,0">
                        <Button.Background>
                            <SolidColorBrush Color="#FFDDDDDD" Opacity="0"/>
                        </Button.Background>
                    </Button>
                    <Button x:Name="btn_battery" Content="Battery Info" HorizontalAlignment="Left" Margin="603,75,0,0" VerticalAlignment="Top" Height="36" Width="77" Padding="-2,1,1,1" ScrollViewer.CanContentScroll="True" BorderThickness="0,0,0,0">
                        <Button.Background>
                            <SolidColorBrush Color="#FFDDDDDD" Opacity="0"/>
                        </Button.Background>
                    </Button>
                </Grid>
            </TabItem>
            <TabItem Header="Quick Access" Margin="-2,-2,-2,2" Height="20" BorderBrush="#FF424549" Background="#FF2C2F33" Foreground="#FF747272">
                <Grid>
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition/>
                    </Grid.ColumnDefinitions>
                    <Grid.Background>
                        <LinearGradientBrush EndPoint="0.5,1" StartPoint="0.5,0">
                            <GradientStop Color="#FF2C2F33"/>
                            <GradientStop Color="#FF282B30" Offset="1"/>
                        </LinearGradientBrush>
                    </Grid.Background>
                    <Rectangle HorizontalAlignment="Left" Height="32" Margin="148,65,0,0" Stroke="Black" VerticalAlignment="Top" Width="122" Fill="#FFA1B5FF" RadiusX="5" RadiusY="5"/>
                    <Button x:Name="btn_taskmngr" Content="Task Manager" HorizontalAlignment="Left" Margin="149,66,0,0" VerticalAlignment="Top" Height="30" Width="120">
                        <Button.BorderBrush>
                            <SolidColorBrush Color="#FF707070" Opacity="0"/>
                        </Button.BorderBrush>
                        <Button.Background>
                            <SolidColorBrush Color="#FF23272A" Opacity="0"/>
                        </Button.Background>
                    </Button>
                    <Rectangle HorizontalAlignment="Left" Height="32" Margin="350,65,0,0" Stroke="Black" VerticalAlignment="Top" Width="122" Fill="#FFA1B5FF" RadiusX="5" RadiusY="5"/>
                    <Rectangle HorizontalAlignment="Left" Height="32" Margin="148,123,0,0" Stroke="Black" VerticalAlignment="Top" Width="122" Fill="#FF7B91D8" RadiusX="5" RadiusY="5"/>
                    <Button x:Name="btn_control" Content="Control Panel" HorizontalAlignment="Left" Margin="149,124,0,0" VerticalAlignment="Top" Height="30" Width="120">
                        <Button.BorderBrush>
                            <SolidColorBrush Color="#FF707070" Opacity="0"/>
                        </Button.BorderBrush>
                        <Button.Background>
                            <SolidColorBrush Color="#FFDDDDDD" Opacity="0"/>
                        </Button.Background>
                    </Button>
                    <Rectangle HorizontalAlignment="Left" Height="32" Margin="350,123,0,0" Stroke="Black" VerticalAlignment="Top" Width="122" Fill="#FF7B91D8" RadiusX="5" RadiusY="5"/>
                    <Button x:Name="btn_devmgmt" Content="Device Manager" HorizontalAlignment="Left" Margin="351,124,0,0" VerticalAlignment="Top" Height="30" Width="120">
                        <Button.BorderBrush>
                            <SolidColorBrush Color="#FF707070" Opacity="0"/>
                        </Button.BorderBrush>
                        <Button.Background>
                            <SolidColorBrush Color="#FFDDDDDD" Opacity="0"/>
                        </Button.Background>
                    </Button>
                    <Rectangle HorizontalAlignment="Left" Height="32" Margin="548,65,0,0" Stroke="Black" VerticalAlignment="Top" Width="122" Fill="#FFA1B5FF" RadiusX="5" RadiusY="5"/>
                    <Rectangle HorizontalAlignment="Left" Height="32" Margin="548,123,0,0" Stroke="Black" VerticalAlignment="Top" Width="122" Fill="#FF7B91D8" RadiusX="5" RadiusY="5"/>
                    <Rectangle HorizontalAlignment="Left" Height="32" Margin="350,185,0,0" Stroke="Black" VerticalAlignment="Top" Width="122" Fill="#FF697FC5" RadiusX="5" RadiusY="5"/>
                    <Button x:Name="btn_winset" Content="Windows Settings" HorizontalAlignment="Left" Margin="549,124,0,0" VerticalAlignment="Top" Height="30" Width="120">
                        <Button.BorderBrush>
                            <SolidColorBrush Color="#FF707070" Opacity="0"/>
                        </Button.BorderBrush>
                        <Button.Background>
                            <SolidColorBrush Color="#FFDDDDDD" Opacity="0"/>
                        </Button.Background>
                    </Button>
                    <Rectangle HorizontalAlignment="Left" Height="32" Margin="148,185,0,0" Stroke="Black" VerticalAlignment="Top" Width="122" Fill="#FF697FC5" RadiusX="5" RadiusY="5"/>
                    <Rectangle HorizontalAlignment="Left" Height="32" Margin="548,185,0,0" Stroke="Black" VerticalAlignment="Top" Width="122" Fill="#FF697FC5" RadiusX="5" RadiusY="5"/>
                    <Rectangle HorizontalAlignment="Left" Height="32" Margin="548,245,0,0" Stroke="Black" VerticalAlignment="Top" Width="122" Fill="#FF566EB2" RadiusX="5" RadiusY="5"/>
                    <Button x:Name="btn_taskscheduler" Content="Task Scheduler" HorizontalAlignment="Left" Margin="550,246,0,0" VerticalAlignment="Top" Height="30" Width="120">
                        <Button.BorderBrush>
                            <SolidColorBrush Color="#FF707070" Opacity="0"/>
                        </Button.BorderBrush>
                        <Button.Background>
                            <SolidColorBrush Color="#FFDDDDDD" Opacity="0"/>
                        </Button.Background>
                    </Button>
                    <Rectangle HorizontalAlignment="Left" Height="32" Margin="350,245,0,0" Stroke="Black" VerticalAlignment="Top" Width="122" Fill="#FF566EB2" RadiusX="5" RadiusY="5"/>
                    <Button x:Name="btn_sysconfig" Content="System Configuration" HorizontalAlignment="Left" Margin="549,186,0,0" VerticalAlignment="Top" Height="30" Width="120">
                        <Button.BorderBrush>
                            <SolidColorBrush Color="#FF707070" Opacity="0"/>
                        </Button.BorderBrush>
                        <Button.Background>
                            <SolidColorBrush Color="#FFDDDDDD" Opacity="0"/>
                        </Button.Background>
                    </Button>
                    <Rectangle HorizontalAlignment="Left" Height="32" Margin="148,245,0,0" Stroke="Black" VerticalAlignment="Top" Width="122" Fill="#FF566EB2" RadiusX="5" RadiusY="5"/>
                    <Button x:Name="btn_regedit" Content="Registry Editor" HorizontalAlignment="Left" Margin="149,246,0,0" VerticalAlignment="Top" Height="30" Width="120">
                        <Button.BorderBrush>
                            <SolidColorBrush Color="#FF707070" Opacity="0"/>
                        </Button.BorderBrush>
                        <Button.Background>
                            <SolidColorBrush Color="#FFDDDDDD" Opacity="0"/>
                        </Button.Background>
                    </Button>
                    <Rectangle HorizontalAlignment="Left" Height="32" Margin="350,305,0,0" Stroke="Black" VerticalAlignment="Top" Width="122" Fill="#FF435EA0" RadiusX="5" RadiusY="5"/>
                    <Button x:Name="btn_resmon" Content="Ressource Monitor" HorizontalAlignment="Left" Margin="351,66,0,0" VerticalAlignment="Top" Height="30" Width="120">
                        <Button.BorderBrush>
                            <SolidColorBrush Color="#FF707070" Opacity="0"/>
                        </Button.BorderBrush>
                        <Button.Background>
                            <SolidColorBrush Color="#FFDDDDDD" Opacity="0"/>
                        </Button.Background>
                    </Button>
                    <Rectangle HorizontalAlignment="Left" Height="32" Margin="148,305,0,0" Stroke="Black" VerticalAlignment="Top" Width="122" Fill="#FF435EA0" RadiusX="5" RadiusY="5"/>
                    <Rectangle HorizontalAlignment="Left" Height="32" Margin="548,305,0,0" Stroke="Black" VerticalAlignment="Top" Width="122" Fill="#FF435EA0" RadiusX="5" RadiusY="5"/>
                    <Button x:Name="btn_eventview" Content="Event Viewer" HorizontalAlignment="Left" Margin="549,66,0,0" VerticalAlignment="Top" Height="30" Width="120">
                        <Button.BorderBrush>
                            <SolidColorBrush Color="#FF707070" Opacity="0"/>
                        </Button.BorderBrush>
                        <Button.Background>
                            <SolidColorBrush Color="#FFDDDDDD" Opacity="0"/>
                        </Button.Background>
                    </Button>
                    <Button x:Name="btn_services" Content="Services" HorizontalAlignment="Left" Margin="351,246,0,0" VerticalAlignment="Top" Height="30" Width="120">
                        <Button.BorderBrush>
                            <SolidColorBrush Color="#FF707070" Opacity="0"/>
                        </Button.BorderBrush>
                        <Button.Background>
                            <SolidColorBrush Color="#FFDDDDDD" Opacity="0"/>
                        </Button.Background>
                    </Button>
                    <Button x:Name="btn_cmd" Content="Command Panel" HorizontalAlignment="Left" Margin="149,186,0,0" VerticalAlignment="Top" Height="30" Width="120">
                        <Button.BorderBrush>
                            <SolidColorBrush Color="#FF707070" Opacity="0"/>
                        </Button.BorderBrush>
                        <Button.Background>
                            <SolidColorBrush Color="#FFDDDDDD" Opacity="0"/>
                        </Button.Background>
                    </Button>
                    <Button x:Name="btn_powershell" Content="Powershell" HorizontalAlignment="Left" Margin="351,186,0,0" VerticalAlignment="Top" Height="30" Width="120">
                        <Button.BorderBrush>
                            <SolidColorBrush Color="#FF707070" Opacity="0"/>
                        </Button.BorderBrush>
                        <Button.Background>
                            <SolidColorBrush Color="#FFDDDDDD" Opacity="0"/>
                        </Button.Background>
                    </Button>
                    <Button x:Name="btn_firewall" Content="Firewall" HorizontalAlignment="Left" Margin="549,306,0,0" VerticalAlignment="Top" Height="30" Width="120">
                        <Button.BorderBrush>
                            <SolidColorBrush Color="#FF707070" Opacity="0"/>
                        </Button.BorderBrush>
                        <Button.Background>
                            <SolidColorBrush Color="#FFDDDDDD" Opacity="0"/>
                        </Button.Background>
                    </Button>
                    <Button x:Name="btn_defrag" Content="Defragment Drives" HorizontalAlignment="Left" Margin="351,306,0,0" VerticalAlignment="Top" Height="30" Width="120">
                        <Button.BorderBrush>
                            <SolidColorBrush Color="#FF707070" Opacity="0"/>
                        </Button.BorderBrush>
                        <Button.Background>
                            <SolidColorBrush Color="#FFDDDDDD" Opacity="0"/>
                        </Button.Background>
                    </Button>
                    <Button x:Name="btn_printmgmt" Content="*Printer Management*" HorizontalAlignment="Left" Margin="149,306,0,0" VerticalAlignment="Top" Height="30" Width="121" FontSize="11">
                        <Button.BorderBrush>
                            <SolidColorBrush Color="#FF707070" Opacity="0"/>
                        </Button.BorderBrush>
                        <Button.Background>
                            <SolidColorBrush Color="#FFDDDDDD" Opacity="0"/>
                        </Button.Background>
                    </Button>
                </Grid>
            </TabItem>
        </TabControl>

    </Grid>
</Window>
"@ 

$inputXML = $inputXML -replace 'mc:Ignorable="d"','' -replace "x:N",'N' -replace '^<Win.*', '<Window'
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = $inputXML
#Read the XAML code

$reader=(New-Object System.Xml.XmlNodeReader $xaml)
try{
    $Form=[Windows.Markup.XamlReader]::Load( $reader )
}
catch{
    Write-Warning "Unable to parse XML, with error: $($Error[0])`n Ensure that there are NO SelectionChanged or TextChanged properties in your textboxes (PowerShell cannot process them)"
    throw
}

#===========================================================================
# Load XAML Objects In PowerShell
#===========================================================================

$xaml.SelectNodes("//*[@Name]") | %{"trying item $($_.Name)";
    try {Set-Variable -Name "WPF$($_.Name)" -Value $Form.FindName($_.Name) -ErrorAction Stop}
    catch{throw}
    }

Function Get-FormVariables{
if ($global:ReadmeDisplay -ne $true){Write-host "If you need to reference this display again, run Get-FormVariables" -ForegroundColor Yellow;$global:ReadmeDisplay=$true}
write-host "Found the following interactable elements from our form" -ForegroundColor Cyan
get-variable WPF*
}

Get-FormVariables

#===================================================================================================
###############################################home#################################################
#===================================================================================================

#Start of Displays
#Timer display
$Timer=New-Object System.Windows.Forms.Timer
$Timer_Tick={
    $WPFDisplayRealTime.Content= Get-Date -Format "HH:mm:ss"
    }
    $Timer.Enabled = $True
    $Timer.Interval = 1
    $Timer.add_Tick($Timer_Tick)

#Date display
$WPFDisplayRealDate.Content= Get-Date -Format dd-MM-yyyy
##END OF Displays

#START ABOUT ME___________________________________________________________________________________________#
$WPFAboutme.Add_Click({
# Load the About Me Window
$inputXML = @"
<Window x:Class="MultiTool.AboutMe"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:MultiTool"
        mc:Ignorable="d"
        Title="AboutMe" Height="184" Width="200">
    <Grid Background="#FF23272A">
        <TextBlock HorizontalAlignment="Left" Margin="10,10,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Height="74" Width="199" Foreground="#FFCECECE"><Run Text="Current Version: 1.00"/><LineBreak/><Run Text="Created by: Samuel Senn"/><LineBreak/><Run Text="Supported OS: Win 10 &amp; 11"/><LineBreak/><Run Text="�"/><Run Language="de-ch" Text="2023 "/></TextBlock>
    </Grid>
</Window>
"@ 

$inputXML = $inputXML -replace 'mc:Ignorable="d"','' -replace "x:N",'N' -replace '^<Win.*', '<Window'
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = $inputXML
# Read XAML

$reader=(New-Object System.Xml.XmlNodeReader $xaml)
try{
    $Form=[Windows.Markup.XamlReader]::Load( $reader )
}
catch{
    Write-Warning "Unable to parse XML, with error: $($Error[0])`n Ensure that there are NO SelectionChanged or TextChanged properties in your textboxes (PowerShell cannot process them)"
    throw
}

#===========================================================================
# Load XAML Objects In PowerShell
#===========================================================================

$xaml.SelectNodes("//*[@Name]") | %{"trying item $($_.Name)";
    try {Set-Variable -Name "WPF$($_.Name)" -Value $Form.FindName($_.Name) -ErrorAction Stop}
    catch{throw}
    }

Function Get-FormVariables{
if ($global:ReadmeDisplay -ne $true){Write-host "If you need to reference this display again, run Get-FormVariables" -ForegroundColor Yellow;$global:ReadmeDisplay=$true}
get-variable WPF*
}

Get-FormVariables
$Form.ShowDialog() | out-null
})
##END ABOUT ME___________________________________________________________________________________________________#

# Github Link button
$WPFgithub.Add_Click({
# Open Github
Start-Process "https://github.com/Geistica/Mutli-Tool"
Write-Host "Github Link has been opened"
})

#===================================================================================================
#########################################System Operations##########################################
#===================================================================================================
# Shutdown System
$WPFbtn_shutdown.Add_Click({shutdown /s})
# Restart Sytem
$WPFbtn_restart.Add_Click({Restart-Computer})
# Log out of current user
$WPFbtn_logout.Add_Click({logoff 1})

#START OF CHANGE PASSWORD OF LOCAL USER SCRIPT___________________________________________________________________#
$WPFbtn_password.Add_Click({
Write-Host "button password change has been clicked"
# Administrator Permissions check and warn if it isn't he isn't elevated
$adminCheck = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (!$adminCheck) {
    [System.Windows.Forms.MessageBox]::Show("You need admin permissions to use this button.", "Admin permissions required", "OK", "Warning")
}
else {
# Change the password
$username = $env:username
# Input Window
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
$WPFbtn_mbr2gpt.Add_Click({
Write-Host "button mbr2gpt has been clicked"
    # clear the result box
    $WPFconsole.Text = ""
# Input Box
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
$WPFbtn_winupdate.Add_Click({
Write-Host "button windows Update has been clicked"
# Check if Module "Get-InstallModule" is installed
$installedModules = Get-InstalledModule -Name "PSWindowsUpdate"
if ($installedModules.Count -eq 0) {
    [System.Windows.Forms.MessageBox]::Show("You need to install PSWindowsUpdate module before using this button. Please run 'Install-Module -Name PSWindowsUpdate -Force' in an elevated PowerShell prompt.", "Module not found", "OK", "Warning")
}
else {
# Administrator Permissions check and warning
$adminCheck = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

if (!$adminCheck) {
    [System.Windows.Forms.MessageBox]::Show("You need admin permissions to use this button.", "Admin permissions required", "OK", "Warning")
}
else {
# Check if updates are available
$winupdates = Get-WindowsUpdate

# If Updates are Available
if ($winupdates) {
    if ($winupdates.Count -eq 1) {
$answer_winupdates = [System.Windows.Forms.MessageBox]::Show("There are updates available, do you want to download and install them?", "Updates Available", [System.Windows.Forms.MessageBoxButtons]::YesNo)
}
# Install updates
if ($answer_winupdates -eq [System.Windows.Forms.DialogResult]::Yes) {
    Write-Host "Updates will now be downloaded and installed."
    foreach ($update in $updates) {
    $update.KBArticleIDs | % { wusa.exe /quiet /norestart /kb:$_ }  
    # Restart
    shutdown /r /t 0
    # Do not install updates
}} elseif ($answer_winupdates -eq [System.Windows.Forms.DialogResult]::No) {
    Write-Host "Updates will not be downloaded or installed."
 }
}
# No Updates available
else {
    Write-Host "There are currently no updates are available."
}
      
}
}
})
##END OF WINDOWS UPDATES SCRIPT______________________________________________________________________________#

#START OF REMOVE EMPTY FOLDERS SCRIPT________________________________________________________________________#
$WPFbtn_empty_folders.Add_Click({
Write-Host "button empty folders has been clicked"
# Input Path to directory
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
$WPFbtn_static_IP.Add_Click({
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
# No Static Ip
}else {[System.Windows.Forms.MessageBox]::Show("No Static Ip has been set", "Static IP Address")
}
Write-Host "Script Static IP has ended" 
})
##END OF STATIC IP CREATOR SCRIPT____________________________________________________________________________#

#START OF THE SAFE BOOT SCRIPT_______________________________________________________________________________#
$WPFbtn_safeboot.Add_Click({
Write-Host "button safe boot has been clicked"
# Set registry as a variable
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
$WPFbtn_pcclean.Add_Click({
# Delete temp files
Remove-Item -Path "$env:temp\*" -Force -Recurse

# Empty recycle bin
$shell = New-Object -ComObject Shell.Application
$recycleBin = $shell.Namespace(0xA)
$recycleBin.Items() | %{$recycleBin.InvokeVerb("Delete")}

# Delete Internet Explorer temp files
Remove-Item -Path "$env:userprofile\AppData\Local\Microsoft\Windows\Temporary Internet Files\*" -Force -Recurse

# Remove unneeded Windows files
Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1"

# Clear Windows event logs
Clear-EventLog -LogName "Application"
Clear-EventLog -LogName "Security"
Clear-EventLog -LogName "System"
})
##END OF THE PC CLEAN UP SCRIPT______________________________________________________________________________#

#===================================================================================================
########################################System Informations#########################################
#===================================================================================================

#START OF THE DISPLAYS_______________________________________________________________________________________#
# Ip Adress in ipv4
$ip = Test-Connection -ComputerName (hostname) -Count 1 | Select -ExpandProperty IPV4Address
$WPFiptextbox.Text = $WPFiptextbox.Text + "$ip"

# Display Computer Name
$WPFpcname.text = $env:COMPUTERNAME
##END OF DISPLAYS____________________________________________________________________________________________#

#START OF THE DISKINFO SCRIPT________________________________________________________________________________#
$WPFbtn_diskinfo.Add_Click( {
Write-Host "button diskinfo has been clicked"
       # clear the result box
       $WPFtxtResults.Text = ""
           if ($result = Get-FixedDisk -Computer $WPFpcname.Text) {
               foreach ($item in $result) {
                   $WPFtxtResults.Text = $WPFtxtResults.Text + "Device ID: $($item.DeviceID)`n" 
                   $WPFtxtResults.Text = $WPFtxtResults.Text + "Volume Name: $($item.VolumeName)`n"
                   $WPFtxtResults.Text = $WPFtxtResults.Text + "Free Space: " + [Math]::Round(($item.FreeSpace/1GB), 2) + "GB`n"
                   $WPFtxtResults.Text = $WPFtxtResults.Text + "Size: " + [Math]::Round(($item.Size/1GB), 2) + "GB"
               }
           }
           Write-Host "Script diskinfo has ended"    
       })
##END OF THE DISKINFO SCRIPT________________________________________________________________________________#

#START OF THE DEVICE SPECIFICATION SCRIPT___________________________________________________________________#
$WPFbtn_specs.Add_Click( {
Write-Host "button specifications has been clicked"
    # clear the result box
    $WPFtxtResults.Text = ""
              $WPFtxtResults.Text = $WPFtxtResults.Text + "Operating System: $((Get-CimInstance -ClassName Win32_OperatingSystem).Caption)`n"
              $WPFtxtResults.Text = $WPFtxtResults.Text + "CPU: $((Get-CimInstance -ClassName Win32_Processor).Name)`n"
              $WPFtxtResults.Text = $WPFtxtResults.Text + "RAM: $((Get-CimInstance -ClassName Win32_ComputerSystem).TotalPhysicalMemory / 1GB) GB`n"
              $WPFtxtResults.Text = $WPFtxtResults.Text + "GPU: $((Get-CimInstance -ClassName Win32_VideoController).Name)`n"
              $WPFtxtResults.Text = $WPFtxtResults.Text + "Bios Vers: $((Get-CimInstance -ClassName Win32_BIOS).Name)`n"
              $WPFtxtResults.Text = $WPFtxtResults.Text + "Win Vers detailed: $([System.Environment]::OSVersion.Version)`n"
              $WPFtxtResults.Text = $WPFtxtResults.Text + "Win Vers: $(Get-ComputerInfo | select windowsversion)`n"
              Write-Host "Script specifications has ended"   
            })
##END OF THE SPECIFICATION SCRIPT__________________________________________________________________________#

#START OF THE BATTERY INFO SCRIPT__________________________________________________________________________#
$WPFbtn_battery.Add_Click( {
Write-Host "button battery info has been clicked"
$saveLocation = (New-Object -ComObject Shell.Application).BrowseForFolder(0, "Select a location to save the file", 0, 0).self.path
powercfg /batteryreport /output "$saveLocation\Battery-Info.html"
ii "$saveLocation\Battery-Info.html"
Write-Host "Script battery info has ended"   
})
##END OF THE BATTERY INFO SCRIPT__________________________________________________________________________#

#===================================================================================================
############################################Quick Access############################################
#===================================================================================================
# Start Task Manager
$WPFbtn_taskmngr.Add_Click( {
Write-Host "Starting Task Manager" 
Start-Process -FilePath "taskmgr.exe"
})

# Start Services
$WPFbtn_services.Add_Click( {
Write-Host "Starting Services" 
Start-Process -FilePath "services.msc"
})

# Start Control Panel
$WPFbtn_services.Add_Click( {
Write-Host "Starting Control Panel" 
Start-Process -FilePath "services.msc"
})

# Start Device Manager
$WPFbtn_devmgmt.Add_Click( {
Write-Host "Starting Device Manager" 
Start-Process -FilePath "devmgmt.msc"
})

# Start Defragment and optimize Drives
$WPFbtn_defrag.Add_Click( {
Write-Host "Starting Defragment and optimize Drives" 
Start-Process -FilePath "dfrgui.exe"
})

# Start Powershell
$WPFbtn_powershell.Add_Click( {
Write-Host "Starting Powershell" 
Start-Process -FilePath "powershell.exe"
})

# Start Command Panel
$WPFbtn_cmd.Add_Click( {
Write-Host "Starting Command Panel" 
Start-Process -FilePath "cmd.exe" -Verb RunAs
})

# Start Firewall
$WPFbtn_firewall.Add_Click( {
Write-Host "Starting Firewall" 
Start-Process -FilePath "wf.msc"
})

# Start Windows Settings
$WPFbtn_winset.Add_Click( {
Write-Host "Starting Windows Settings" 
Start-Process -FilePath "ms-settings:"
})

# Start Registry Editor
$WPFbtn_regedit.Add_Click( {
Write-Host "Starting Registry Editor" 
Start-Process -FilePath "regedit.exe"
})

# Start System Configuration
$WPFbtn_sysconfig.Add_Click( {
Write-Host "Starting System Configuration" 
Start-Process -FilePath "msconfig.exe" -Verb RunAs
})

# Start Task Scheduler
$WPFbtn_taskscheduler.Add_Click( {
Write-Host "Starting Task Scheduler" 
Start-Process -FilePath "taskschd.msc" -Verb RunAs
})

# Start Ressource Monitor
$WPFbtn_resmon.Add_Click( {
Write-Host "Starting Ressource Monitor"
Start-Process -FilePath "resmon.exe"
})

# Start Print Managment
$WPFbtn_printmgmt.Add_Click( {
# Check if the Print Management Console is installed
if (!(Test-Path "C:\Windows\System32\printmanagement.msc")) {
    # Show message box to user
    [System.Windows.Forms.MessageBox]::Show("You need to install the 'Print Management Console' before using this button. Please install it from the 'Control Panel' and try again.", "Print Management Console not found", "OK", "Warning")
}
else {
Write-Host "Starting Print Management"
Start-Process -FilePath "printmanagement.msc"
}
})

# Start Event Viewer
$WPFbtn_eventview.Add_Click( {
Write-Host "Starting Event Viewer"
Start-Process -FilePath "eventvwr.msc"
})

###################################################################################
# Display the debug console
Show-DebugConsole
# DO NOT TOUCH
$Form.ShowDialog() | out-null
###################################################################################