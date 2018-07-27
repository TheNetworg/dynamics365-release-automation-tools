$global:counter = 0 
$global:totalReplacements = 0
# Find all assembly references and replace them if the version does not match
function Update-AssemblyVersionInFile {
    param(
        [string]$FileContent, 
        [LatestAssembly[]]$LatestVersions)


    $global:counter = 0
    foreach ($assembly in $LatestVersions) {

        $regex = [regex]"(AssemblyQualifiedName="".+?, )($($assembly.name), Version=\d.+?, Culture=neutral, PublicKeyToken=.+?)("")"

        $evaluator = [System.Text.RegularExpressions.MatchEvaluator] {
            param($match)

            if ($assembly.fullyQualifiedName -ne $match.Groups[2].Value) {
                $global:counter++
                $global:totalReplacements++
            }

            return "$($match.Groups[1].Value)$($assembly.fullyQualifiedName)$($match.Groups[3].Value)"
        }

        $FileContent = $regex.Replace($FileContent, $evaluator);

    }

    if ($global:counter -gt 0) {Write-Host "Replacements made: $($global:counter)`r`n" -ForegroundColor Red}

    return $FileContent
}