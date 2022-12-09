$Collegial = Get-Content -Path "..\source\es_collegial.geojson" | ConvertFrom-JSON

$Gouvernemental = @{
    type = 'FeatureCollection'
    name = 'Collégial - Gouvernemental'
    generation = $(Get-Date -Format "yyyy-MM-dd HH:mm K")
    features = New-Object System.Collections.Generic.List[System.Object]
}

$Public = @{
    type = 'FeatureCollection'
    name = 'Collégial - Public'
    generation = $(Get-Date -Format "yyyy-MM-dd HH:mm K")
    features = New-Object System.Collections.Generic.List[System.Object]
}

$Prive = @{
    type = 'FeatureCollection'
    name = 'Collégial - Privé'
    generation = $(Get-Date -Format "yyyy-MM-dd HH:mm K")
    features = New-Object System.Collections.Generic.List[System.Object]
}

$Autre = @{
    type = 'FeatureCollection'
    name = 'Collégial - Autre'
    generation = $(Get-Date -Format "yyyy-MM-dd HH:mm K")
    features = New-Object System.Collections.Generic.List[System.Object]
}

foreach ($f in $Collegial.features) {
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
    $ParsedProperties.Add("reseau", $Properties.RESEAU)
    $ParsedProperties.Add("originales", $Properties)

    $f.properties = $ParsedProperties

    if($f.properties.RESEAU -eq "Gouvernemental"){
        $Gouvernemental.features.Add($f)
    }    
    elseif($f.properties.RESEAU -eq "Public"){
        $Public.features.Add($f)
    }
    elseif($f.properties.RESEAU -eq "Privé"){
        $Prive.features.Add($f)
    }
    else {
        $Autre.features.Add($f)
    }
}

$Gouvernemental | ConvertTo-Json -Depth 100 -Compress | Set-Content "..\dist\collegial\gouvernemental.geojson"
$Public | ConvertTo-Json -Depth 100 -Compress | Set-Content "..\dist\collegial\public.geojson"
$Prive | ConvertTo-Json -Depth 100 -Compress | Set-Content "..\dist\collegial\prive.geojson"

if($Autre.features.Count -gt 0){
    $Autre | ConvertTo-Json -Depth 100 | Set-Content "..\dist\collegial\autre.geojson"
}
