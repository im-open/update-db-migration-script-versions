function Get-Versions {
    param (
        [string]$sqlFolder
    )
    return Get-ChildItem -File -Recurse v*.sql -Path $sqlFolder `
    | ForEach-Object {            
        [int]([regex]::Match($_.Name, '(?i)V\.?([0-9\.]+)__.*\.sql').captures.groups[1].value)
    } `
    | Sort-Object
}

function Get-NextVersion {
    [OutputType([System.Int32])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [AllowNull()]
        [long[]]$versions,
        [long]$maxVersionGap = 100
    )

    if ($null -eq $versions -or $versions.Count -eq 0) {
        return 1
    }

    $sortedVersions = $versions | Sort-Object
    $currentVersion = $sortedVersions[0]
    $index = 0;
    while ($index -lt $sortedVersions.Length) {
        if ($sortedVersions[$index] - $currentVersion -gt $maxVersionGap) {
            return $currentVersion + 1
        }
        $currentVersion = $sortedVersions[$index]
        $index++
    }

    return ($sortedVersions | Select-Object -Last 1) + 1 
}

function Get-NextVersionToSquash {
    param (
        [long[]]$versions,
        [long]$maxVersionGap = 100
    )

    $nextVersion = Get-NextVersion $versions $maxVersionGap
    
    return $versions | Sort-Object | Where-Object { $_ -gt $nextVersion } | Select-Object -First 1
}

function Get-VersionsAndNextSquash {
    [OutputType([System.Collections.Hashtable])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$migrationFolder,
        [long]$maxVersionGap = 100
    )

    $versions = Get-Versions $migrationFolder

    $versionToSquash = Get-NextVersionToSquash $versions $maxVersionGap

    return @{
        versions = $versions
        versionToSquash = $versionToSquash
    }
}