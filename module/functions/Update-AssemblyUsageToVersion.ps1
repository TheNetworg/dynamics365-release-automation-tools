

#Load model
#. ..\model\LatestAssembly.ps1


function Update-AssemblyUsageToAssemblyVersion {
    param (
        [Parameter(Mandatory = $true)][string]$ZipFileName,
        [Parameter(Mandatory = $true)][string]$AssemblyName,
        [Parameter(Mandatory = $true)][string]$AssemblyVersion,
        [Parameter(Mandatory = $true)][string]$AssemblyFQN
    )

    $ZipFileName = Resolve-Path $ZipFileName

    # Open zip and find the solution.xml file
    Add-Type -assembly  System.IO.Compression.FileSystem
    $zip = [System.IO.Compression.ZipFile]::Open($ZipFileName, "Update")

    $assemblyInformation = New-Object LatestAssembly -Prop (@{'name' = $AssemblyName; 'version' = $AssemblyVersion; 'fullyQualifiedName' = $AssemblyFQN})

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



