$Etablissements = Get-Content -Path "..\source\pps_prive_etablissement.geojson" | ConvertFrom-JSON

$Etablissements.name = "Privé - Établissements"
$Etablissements | Add-Member -MemberType NoteProperty -Name "generation" -Value $(Get-Date -Format "yyyy-MM-dd HH:mm K")

foreach($Feature in $Etablissements.features){
    $Properties = $Feature.properties
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
    $ParsedProperties.Add("reseau", $Properties.RESEAU)
    $ParsedProperties.Add("originales", $Properties)

    $Feature.properties = $ParsedProperties
}

$Etablissements | ConvertTo-Json -Depth 100 -Compress | Set-Content ("..\dist\pps\prive\etablissements.geojson")