

#Load model
#. ..\model\LatestAssembly.ps1   


function Update-AssemblyUsageToLatestVersion {
    param (
        [Parameter(Mandatory = $true)][string]$ZipFileName,
        [Parameter(Mandatory = $false)][string]$AssemblyName
    )

    $fileToEdit = "solution.xml"
    $ZipFileName = Resolve-Path $ZipFileName

    # Open zip and find the solution.xml file
    Add-Type -assembly  System.IO.Compression.FileSystem
    $zip = [System.IO.Compression.ZipFile]::Open($ZipFileName, "Update")
    $solutionFile = $zip.Entries.Where( {$_.name -eq $fileToEdit})

    # Read the XML
    $streamReader = [System.IO.StreamReader]($solutionFile).Open()
    $XmlDocument = [xml]$streamReader.ReadToEnd()
    $streamReader.Close()

    #Find the latest builds
    $assemblyLatestVersions = Get-LatestAssemblyVersions $XmlDocument

    if ([string]::IsNullOrEmpty($AssemblyName) -ne $true) {

        $assemblyLatestVersions = $assemblyLatestVersions | Where-Object { $_.name -eq $AssemblyName }
    }

    Write-Host "`r`nThe latest assembly builds in the solution:" -ForegroundColor Green
    Write-Host ($assemblyLatestVersions | Format-Table | Out-String) -ForegroundColor Green

    #Loop through all the workflow definition files
    foreach ($zipFileEntry in (Get-WorkflowDefinitionFileEntriesFromZip $zip)) {

        Write-Host "Checking> $zipFileEntry"

        # Read the XML
        $sr = [System.IO.StreamReader]($zipFileEntry).Open()
        $content = $sr.ReadToEnd()
        $sr.Close()

        $updatedContent = (Update-AssemblyVersionInFile $content $assemblyLatestVersions)

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



