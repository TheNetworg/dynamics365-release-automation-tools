# Delete missing dependencies from solution.xml
function Remove-MissingDependencies{
    param (
        [string]$ZipFileName
    )
    
    $fileToEdit = "solution.xml"
    $ZipFileName = Resolve-Path $ZipFileName
    
    # Open zip and find the solution.xml file
    Add-Type -assembly  System.IO.Compression.FileSystem
    $zip =  [System.IO.Compression.ZipFile]::Open($ZipFileName,"Update")
    $solutionFile = $zip.Entries.Where({$_.name -eq $fileToEdit})
    
    # Read the XML
    $streamReader = [System.IO.StreamReader]($solutionFile).Open()
    $XmlDocument = [xml]$streamReader.ReadToEnd()
    $XmlDocument.PreserveWhiteSpace = $true
    $streamReader.Close()
    
    # Remove MissingDependency nodes
    if ($XmlDocument.ImportExportXml.SolutionManifest.MissingDependencies -is [Xml.XmlElement]) {
        $XmlDocument.ImportExportXml.SolutionManifest.MissingDependencies.MissingDependency | ForEach-Object{ $_.ParentNode.RemoveChild($_) | Out-Null }
    }
    
    # Overwrite the file
    $streamWriter = [System.IO.StreamWriter]($solutionFile).Open()
    $streamWriter.BaseStream.SetLength(0)
    $streamWriter.Write($XmlDocument.OuterXml)
    $streamWriter.Flush()
    $streamWriter.Close()
    
    # Close the zip file
    $zip.Dispose()
}