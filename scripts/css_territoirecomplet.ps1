$Sources = @(
    @{ 
        Type = 'Complet' 
        Data = ((Get-Content -Path "..\source\CS_ANG.geojson" | ConvertFrom-JSON).features + (Get-Content -Path "..\source\CS_FRA.geojson" | ConvertFrom-JSON).features + (Get-Content -Path "..\source\CS_STA.geojson" | ConvertFrom-JSON).features)
    },
    @{ 
        Type = 'SDA' 
        Data = ((Get-Content -Path "..\source\CS_ANG_SDA.geojson" | ConvertFrom-JSON).features + (Get-Content -Path "..\source\CS_FRA_SDA.geojson" | ConvertFrom-JSON).features + (Get-Content -Path "..\source\CS_STA_SDA.geojson" | ConvertFrom-JSON).features)
    }
)

$BaseDirectory = "..\dist\pps\public\"

$TerritoireComplet = @{
    type = 'FeatureCollection'
    name = 'Centres de services scolaires - Territoire'
    generation = $(Get-Date -Format "yyyy-MM-dd HH:mm K")
    features = New-Object System.Collections.Generic.List[System.Object]
}

$TerritoireCompletSDA = @{
    type = 'FeatureCollection'
    name = 'Centres de services scolaires - Territoire SDA'
    generation = $(Get-Date -Format "yyyy-MM-dd HH:mm K")
    features = New-Object System.Collections.Generic.List[System.Object]
}

foreach($S in $Sources){
    Write-Host($S.Type)

    foreach($Feature in $S.Data){
        $Properties = $Feature.properties
        $ParsedProperties = @{}
    
        if($Properties.CD_CS_ANG){
            $Nom = $Properties.NOM_OFFCL_CS_ANG
            $Code = $Properties.CD_CS_ANG
            $Type = 'Anglophone'
        } elseif($Properties.CD_CS_FRA){
            $Nom = $Properties.NOM_OFFCL_CS_FRA
            $Code = $Properties.CD_CS_FRA
            $Type = 'Francophone'
        } elseif($Properties.CD_CS_STA){
            $Nom = $Properties.NOM_OFFCL_CS_STA
            $Code = $Properties.CD_CS_STA
            $Type = 'Particulière'
        }
    
        $ParsedProperties.Add("code", $Code)
        $ParsedProperties.Add("nom", $Nom)
        $ParsedProperties.Add("type", $Type)

        $Feature.properties = $ParsedProperties

        if($S.Type -eq "Complet"){
            $TerritoireComplet.features.Add($Feature)
        } elseif($S.Type -eq "SDA"){
            $TerritoireCompletSDA.features.Add($Feature)
        }
        
    }
}

$TerritoireComplet | ConvertTo-Json -Depth 100 -Compress | Set-Content ($BaseDirectory + "\territoire.geojson")
$TerritoireCompletSDA | ConvertTo-Json -Depth 100 -Compress | Set-Content ($BaseDirectory + "\territoire.sda.geojson")