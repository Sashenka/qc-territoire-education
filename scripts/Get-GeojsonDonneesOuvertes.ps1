[CmdletBinding()]
Param (
    [Alias('d')]
    [string] $Destination = "..\source\"
)

$Source = Get-Content -Path ".\source.json" | ConvertFrom-JSON

$StartedAt = [datetime]::UtcNow
$Jobs = @() 

Write-Host "Récupération des fichiers Geojson..."

foreach($Fichier in $Source.fichiers){
    $Jobs += Start-ThreadJob -Scriptblock {
        param($Url, $Output)
        Invoke-WebRequest -Uri $Url -OutFile $Output -Method Get
    }  -ArgumentList $Fichier.url, ($Destination + $Fichier.filename)
}

$Jobs | Receive-Job -Wait -AutoRemoveJob
Write-Host "`nRécupération des fichiers terminée. Temps d'éxécution total en secondes: $(([datetime]::UtcNow - $startedAt).TotalSeconds)" -ForegroundColor DarkGreen
