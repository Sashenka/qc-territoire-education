$Universitaire = Get-Content -Path "..\source\es_universitaire.geojson" | ConvertFrom-JSON

$Universitaire.name = "Universitaire"
$Universitaire | Add-Member -MemberType NoteProperty -Name "generation" -Value $(Get-Date -Format "yyyy-MM-dd HH:mm K")

foreach ($f in $Universitaire.features) {
    $Properties = $f.properties
    $ParsedProperties = @{}

    $ParsedAddress = @{}
    $ParsedAddress.Add("civique", ($Properties.ADRS_GEO_L1_GDUNO + " " + $Properties.ADRS_GEO_L2_GDUNO))
    $ParsedAddress.Add("municipalite", ($Properties.NOM_MUNCP + ", QC" ))
    $ParsedAddress.Add("codePostal", $(If ($Properties.CD_POSTL_GDUNO.length -eq 6) {$Properties.CD_POSTL_GDUNO.Insert(3,' ')} Else {""}) )

    $ParsedProperties.Add("code", $Properties.CD_ORGNS)
    $ParsedProperties.Add("miseAJour", [Datetime]::ParseExact($Properties.DT_MAJ_GDUNO, 'yyyyMMdd', $null).ToShortDateString())
    $ParsedProperties.Add("adresse", ($ParsedAddress))
    $ParsedProperties.Add("nom", $Properties.NOM_OFFCL)
    $ParsedProperties.Add("web", $Properties.SITE_WEB)
    $ParsedProperties.Add("type", $Properties.TYPE_ORGNS)
    $ParsedProperties.Add("ordreEnseignement", $Properties.ORDRE_ENS)
    $ParsedProperties.Add("originales", $Properties)

    $f.properties = $ParsedProperties
}

$Universitaire | ConvertTo-Json -Depth 100 -Compress | Set-Content "..\dist\universitaire\universites.geojson"