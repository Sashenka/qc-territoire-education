$Centres = ((Get-Content -Path "..\source\CS_ANG.geojson" | ConvertFrom-JSON).features + (Get-Content -Path "..\source\CS_FRA.geojson" | ConvertFrom-JSON).features + (Get-Content -Path "..\source\CS_STA.geojson" | ConvertFrom-JSON).features)
$CentresSDA = ((Get-Content -Path "..\source\CS_ANG_SDA.geojson" | ConvertFrom-JSON).features + (Get-Content -Path "..\source\CS_FRA_SDA.geojson" | ConvertFrom-JSON).features + (Get-Content -Path "..\source\CS_STA_SDA.geojson" | ConvertFrom-JSON).features)

$BaseDirectory = "..\dist\pps\public\"
function New-FeatureCollection {
    param (
        $Feature,
        $Nom,
        $Code,
        $Type
    )

    $Properties = $Feature.properties
    $ParsedProperties = @{}

    $FeatureCollection = @{
        type = 'FeatureCollection'
        name = ( '(' + $Code + ') ' + $Nom + ' - Territoire')
        generation = $(Get-Date -Format "yyyy-MM-dd HH:mm K")
        features = New-Object System.Collections.Generic.List[System.Object]
    }

    $ParsedProperties.Add("code", $Code)
    $ParsedProperties.Add("nom", $Nom)
    $ParsedProperties.Add("web", $Properties.NOM_SITE_WEB_GDUNO)
    $ParsedProperties.Add("type", $Type)
    $ParsedProperties.Add("superficie", $Properties.VALR_SUPRF_KM2)
    $ParsedProperties.Add("version", $Properties.NOM_VERSN)
    $ParsedProperties.Add("originales", $Properties)

    $Feature.properties = $ParsedProperties
    $FeatureCollection.features.add($Feature)

    return $FeatureCollection
}

foreach($Feature in $Centres){
    $Properties = $Feature.properties

    if($Properties.CD_CS_ANG){
        $Nom = $Properties.NOM_OFFCL_CS_ANG
        $Code = $Properties.CD_CS_ANG
        $Type = 'Anglophone'
        $PropCode = 'CD_CS_ANG'
    } elseif($Properties.CD_CS_FRA){
        $Nom = $Properties.NOM_OFFCL_CS_FRA
        $Code = $Properties.CD_CS_FRA
        $Type = 'Francophone'
        $PropCode = 'CD_CS_FRA'
    } elseif($Properties.CD_CS_STA){
        $Nom = $Properties.NOM_OFFCL_CS_STA
        $Code = $Properties.CD_CS_STA
        $Type = 'Particulière'
        $PropCode = 'CD_CS_STA'
    }

    $FeatureSDA = $CentresSDA | Where-Object { $_.properties.$PropCode -eq $Code }

    $FeatureCollection = New-FeatureCollection -Feature $Feature -Nom $Nom -Code $Code -Type $Type
    $FeatureCollectionSDA = New-FeatureCollection -Feature $FeatureSDA -Nom $Nom -Code $Code -Type $Type

    if(!(Test-Path ($BaseDirectory + $Code))){
        New-Item -itemType Directory -Path $BaseDirectory -Name $Code
    }

    $FeatureCollection | ConvertTo-Json -Depth 100 -Compress | Set-Content ($BaseDirectory + $Code + "\territoire.geojson")
    $FeatureCollectionSDA | ConvertTo-Json -Depth 100 -Compress | Set-Content ($BaseDirectory + $Code + "\territoire.sda.geojson")

}
