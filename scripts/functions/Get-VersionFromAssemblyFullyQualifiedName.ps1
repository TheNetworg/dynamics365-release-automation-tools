# Parse fully qualified name
function Get-VersionFromAssemblyFullyQualifiedName {
    param(
        [string]$FullyQualifiedName    
    )
    $versionTag = "Version=";
    return [version]$FullyQualifiedName.Substring($FullyQualifiedName.IndexOf($versionTag) + $versionTag.Length, $FullyQualifiedName.Substring($FullyQualifiedName.IndexOf($versionTag) + $versionTag.Length).IndexOf(","))
}