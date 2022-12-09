$Installations = Get-Content -Path "..\source\pps_prive_installation.geojson" | ConvertFrom-JSON

$Installations.name = "Privé - Installations"
$Installations | Add-Member -MemberType NoteProperty -Name "generation" -Value $(Get-Date -Format "yyyy-MM-dd HH:mm K")

foreach($Feature in $Installations.features){
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
    $ParsedProperties.Add("prescolaire", $Properties.PRESC)
    $ParsedProperties.Add("primaire", $Properties.PRIM)
    $ParsedProperties.Add("secondaire", $Properties.SEC)
    $ParsedProperties.Add("formationProfessionnelle", $Properties.FORM_PRO)
    $ParsedProperties.Add("adulte", $Properties.ADULTE)
    $ParsedProperties.Add("ordreEnseignement", $Properties.ORDRE_ENS)
    $ParsedProperties.Add("reseau", $Properties.RESEAU)
    $ParsedProperties.Add("responsable", $Properties.CD_ORGNS_RESP)
    $ParsedProperties.Add("originales", $Properties)

    $Feature.properties = $ParsedProperties
}

$Installations | ConvertTo-Json -Depth 100 -Compress | Set-Content ("..\dist\pps\prive\installations.geojson")