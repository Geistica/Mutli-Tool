$foldersCount = Read-Host "Enter the number of folders to create"
$prefix = Read-Host "Enter the prefix for the folder names"
$numberLocation = Read-Host "Enter the location of the number in the folder names (start/end)"
$addUnderscore = Read-Host "Add underscore before/after the number? (yes/no)"

# Check if the input is a valid number
if (-not [int]::TryParse($foldersCount, [ref]0)) {
    Write-Host "Invalid input. Please enter a valid number."
    exit
}

# Create the folders
for ($i = 1; $i -le $foldersCount; $i++) {
    if ($addUnderscore.ToLower() -eq "yes") {
        if ($numberLocation.ToLower() -eq "start") {
            $folderName = "$i" + "_" + "$prefix"
        }
        elseif ($numberLocation.ToLower() -eq "end") {
            $folderName = "$prefix" + "_" + "$i"
        }
        else {
            Write-Host "Invalid input. Please enter 'start' or 'end' for the location of the number."
            exit
        }
    }
    else {
        if ($numberLocation.ToLower() -eq "start") {
            $folderName = "$i$prefix"
        }
        elseif ($numberLocation.ToLower() -eq "end") {
            $folderName = "$prefix$i"
        }
        else {
            Write-Host "Invalid input. Please enter 'start' or 'end' for the location of the number."
            exit
        }
    }

    $folderPath = Join-Path -Path $PSScriptRoot -ChildPath $folderName
    New-Item -ItemType Directory -Path $folderPath | Out-Null
    Write-Host "Created folder $folderPath"
}
