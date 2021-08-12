param(
    [string]$migrationPath,
    [long]$maxVersionGap = 100
)

. $PSScriptRoot\versioning-helper.ps1

while($null -ne ($versionInfo = Get-VersionsAndNextSquash $migrationPath $maxVersionGap).versionToSquash) {
    $oldVersion = $versionInfo.versionToSquash
    $nextVersion = Get-NextVersion -versions $versionInfo.versions -maxVersionGap $maxVersionGap
            
    Write-Host "Version $($versionInfo.versionToSquash) to be squashed to $nextVersion"

    $formattedNumber = "{0:0000000}" -f $nextVersion
    Get-ChildItem -Path $path -Recurse "V$oldVersion*.sql" | `
        ForEach-Object {             
            $newName = ( $_.Name -replace "(?i)V\.?$oldVersion", "V$formattedNumber")
            Write-Host "Updating the filename $($_.Name) to $newName"
            Rename-Item -Path $_.FullName -NewName $newName
        }
}

Write-Host "Migration script renaming complete"