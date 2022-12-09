$Ecoles = (Get-Content -Path "..\source\pps_public_ecole.geojson" | ConvertFrom-JSON).features | Group-Object -Property {$_.properties.CD_CS}
$Immeubles = (Get-Content -Path "..\source\pps_public_immeuble.geojson" | ConvertFrom-JSON).features | Group-Object -Property {$_.properties.CD_CS}

$BaseDirectory = "..\dist\pps\public\"

foreach($Group in $Ecoles){
    $FeatureCollection = @{
        type = 'FeatureCollection'
        name = ( '(' + $Group.Name + ') - Écoles')
        generation = $(Get-Date -Format "yyyy-MM-dd HH:mm K")
        features = New-Object System.Collections.Generic.List[System.Object]
    }

    foreach($Feature in $Group.Group){
        $Properties = $Feature.properties
        $ParsedProperties = @{}

        $ParsedAddress = @{}
        $ParsedAddress.Add("civique", ($Properties.ADRS_GEO_L1_GDUNO_ORGNS + " " + $Properties.ADRS_GEO_L2_GDUNO_ORGNS))
        $ParsedAddress.Add("municipalite", ($Properties.NOM_MUNCP_GDUNO_ORGNS + ", QC " + $Properties.CD_POSTL_GDUNO_ORGNS.Insert(3,' ')))

        $ParsedProperties.Add("code", $Properties.CD_ORGNS)
        $ParsedProperties.Add("nom", $Properties.NOM_OFFCL_ORGNS)
        $ParsedProperties.Add("adresse", ($ParsedAddress))
        $ParsedProperties.Add("web", $Properties.SITE_WEB_ORGNS)
        $ParsedProperties.Add("prescolaire", $Properties.PRESC)
        $ParsedProperties.Add("primaire", $Properties.PRIM)
        $ParsedProperties.Add("secondaire", $Properties.SEC)
        $ParsedProperties.Add("formationProfessionnelle", $Properties.FORM_PRO)
        $ParsedProperties.Add("adulte", $Properties.ADULTE)
        $ParsedProperties.Add("ordreEnseignement", $Properties.ORDRE_ENS)
        $ParsedProperties.Add("immeuble", $Properties.CD_IMM)
        $ParsedProperties.Add("miseAJour", [Datetime]::ParseExact($Properties.DT_MAJ_GDUNO, 'yyyyMMdd', $null).ToShortDateString())
        $ParsedProperties.Add("originales", $Properties)

        $Feature.properties = $ParsedProperties
        $FeatureCollection.features.add($Feature)
    }

    if(!(Test-Path ($BaseDirectory + $Group.Name))){
        New-Item -itemType Directory -Path $BaseDirectory -Name $Group.Name
    }

    $FeatureCollection | ConvertTo-Json -Depth 100 -Compress | Set-Content ($BaseDirectory + $Group.Name + "\ecoles.geojson")
}


foreach($Group in $Immeubles){
    $FeatureCollection = @{
        type = 'FeatureCollection'
        name = ( '(' + $Group.Name + ') - Immeubles')
        generation = $(Get-Date -Format "yyyy-MM-dd HH:mm K")
        features = New-Object System.Collections.Generic.List[System.Object]
    }

    foreach($Feature in $Group.Group){
        $Properties = $Feature.properties
        $ParsedProperties = @{}

        $ParsedAddress = @{}
        $ParsedAddress.Add("civique", ($Properties.ADRS_GEO_L1_GDUNO + " " + $Properties.ADRS_GEO_L2_GDUNO))
        $ParsedAddress.Add("municipalite", ($Properties.NOM_MUNCP + ", QC"))
        $ParsedAddress.Add("codePostal", $(If ($Properties.CD_POSTL_GDUNO.length -eq 6) {$Properties.CD_POSTL_GDUNO.Insert(3,' ')} Else {""}) )

        $ParsedProperties.Add("code", $Properties.CD_IMM)
        $ParsedProperties.Add("numero", $Properties.009)
        $ParsedProperties.Add("nom", $Properties.NOM_OFFCL)
        $ParsedProperties.Add("adresse", ($ParsedAddress))
        $ParsedProperties.Add("prescolaire", $Properties.PRESC)
        $ParsedProperties.Add("primaire", $Properties.PRIM)
        $ParsedProperties.Add("secondaire", $Properties.SEC)
        $ParsedProperties.Add("formationProfessionnelle", $Properties.FORM_PRO)
        $ParsedProperties.Add("adulte", $Properties.ADULTE)
        $ParsedProperties.Add("ordreEnseignement", $Properties.ORDRE_ENS)
        $ParsedProperties.Add("statut", $Properties.STAT_PROP_IMM)
        $ParsedProperties.Add("miseAJour", [Datetime]::ParseExact($Properties.DT_MAJ_GDUNO, 'yyyyMMdd', $null).ToShortDateString())
        $ParsedProperties.Add("originales", $Properties)

        $Feature.properties = $ParsedProperties
        $FeatureCollection.features.add($Feature)
    }

    if(!(Test-Path ($BaseDirectory + $Group.Name))){
        New-Item -itemType Directory -Path $BaseDirectory -Name $Group.Name
    }

    $FeatureCollection | ConvertTo-Json -Depth 100 -Compress | Set-Content ($BaseDirectory + $Group.Name + "\immeubles.geojson")
}