$folders = Get-ChildItem -Directory

$index = 1
foreach ($folder in $folders) {
    # Check if the folder name already starts with a number and an underscore
    if ($folder.Name -match '^\d{2}_') {
        Write-Host "Skipping folder $($folder.Name) as it is already numbered"
        continue
    }
    
    # Rename the folder with sequential numbering
    $newName = "{0:D2}_{1}" -f $index, $folder.Name
    Rename-Item -Path $folder.FullName -NewName $newName -Force
    Write-Host "Renamed folder $($folder.Name) to $($newName)"
    $index++
}
