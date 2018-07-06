# Get only .xaml files in Workflows folder
function Get-WorkflowDefinitionFileEntriesFromZip {
    param (
        $SolutionZip
    )
    return $SolutionZip.Entries.Where( {$_.name.endswith(".xaml") -and $_.fullname.startswith("Workflows/")})
}