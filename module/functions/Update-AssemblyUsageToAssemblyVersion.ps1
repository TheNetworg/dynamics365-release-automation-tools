

#Load model
#. ..\model\LatestAssembly.ps1


function Update-AssemblyUsageToAssemblyVersion {
    param (
        [Parameter(Mandatory = $true)][string]$ZipFileName,
        [Parameter(Mandatory = $true)][string]$AssemblyPath
    )

    $fileToEdit = "solution.xml"
    $ZipFileName = Resolve-Path $ZipFileName

    # Open zip and find the solution.xml file
    Add-Type -assembly  System.IO.Compression.FileSystem
    $zip = [System.IO.Compression.ZipFile]::Open($ZipFileName, "Update")
    $solutionFile = $zip.Entries.Where( {$_.name -eq $fileToEdit})

    # Read the XML
    $streamReader = [System.IO.StreamReader]($solutionFile).Open()
    $SolutionFileXml = [xml]$streamReader.ReadToEnd()
    $streamReader.Close()

    $assemblyTypeCode = 91

    #Get all assemblies in the solution 
    $assemblies = $SolutionFileXml.ImportExportXml.SolutionManifest.RootComponents.RootComponent | Where-Object {$_.type -match $assemblyTypeCode} `
        | ForEach-Object {$_.schemaName.Substring(0, $_.schemaName.IndexOf(","))} `
        | Sort-Object -Unique

    $assemblyFQNs = $SolutionFileXml.ImportExportXml.SolutionManifest.RootComponents.RootComponent | Where-Object {$_.type -match $assemblyTypeCode} `
        | ForEach-Object {$_.schemaName}
    

    $assembly = [System.Reflection.AssemblyName]::GetAssemblyName($AssemblyPath)

    $assemblyInformation = New-Object LatestAssembly -Prop (@{'name' = $assembly.Name; 'version' = $assembly.Version; 'fullyQualifiedName' = $assembly.FullName})

    Write-Host "`r`nUpdating assembly to:" -ForegroundColor Green
    Write-Host ($assemblyInformation | Format-Table | Out-String) -ForegroundColor Green

    #Loop through all the workflow definition files
    foreach ($zipFileEntry in (Get-WorkflowDefinitionFileEntriesFromZip $zip)) {

        Write-Host "Checking> $zipFileEntry"

        # Read the XML
        $sr = [System.IO.StreamReader]($zipFileEntry).Open()
        $content = $sr.ReadToEnd()
        $sr.Close()

        $updatedContent = (Update-AssemblyVersionInFile $content $assemblyInformation)

        #Update the content
        $sw = [System.IO.StreamWriter]($zipFileEntry).Open()
        $sw.BaseStream.SetLength(0)
        $sw.Write([string]$updatedContent)
        $sw.Flush()
        $sw.Close()
    }

    # Close the zip file
    $zip.Dispose()

    Write-Host "`r`nTotal changes: $($global:totalReplacements)`r`n" -ForegroundColor Yellow
}



