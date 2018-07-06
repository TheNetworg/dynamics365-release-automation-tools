# Look at solution.xml and get the latest version of included assemblies
function Get-LatestAssemblyVersions {
    param(
        [xml]$SolutionFileXml    
    )

    $assemblyTypeCode = 91

    #Get all assemblies in the solution 
    $assemblies = $SolutionFileXml.ImportExportXml.SolutionManifest.RootComponents.RootComponent | Where-Object {$_.type -match $assemblyTypeCode} `
        | ForEach-Object {$_.schemaName.Substring(0, $_.schemaName.IndexOf(","))} `
        | Sort-Object -Unique

    $assemblyFQNs = $SolutionFileXml.ImportExportXml.SolutionManifest.RootComponents.RootComponent | Where-Object {$_.type -match $assemblyTypeCode} `
        | ForEach-Object {$_.schemaName}

    
    $assemblyLatestVersions = @()

    #Get latest versions
    $assemblies | ForEach-Object { 
        $assembly = $_;

        $fqn = $assemblyFQNs | Where-Object { $_.StartsWith($assembly)} `
            | Sort-Object -Property @{Expression = { [version](Get-VersionFromAssemblyFullyQualifiedName $_)}; Ascending = $True} `
            | Select-Object -Last 1 

        $version = Get-VersionFromAssemblyFullyQualifiedName $fqn

        $assemblyLatestVersions = $assemblyLatestVersions + (New-Object LatestAssembly -Prop (@{'name' = $assembly; 'version' = $version; 'fullyQualifiedName' = $fqn}))
    } 

    return $assemblyLatestVersions
}