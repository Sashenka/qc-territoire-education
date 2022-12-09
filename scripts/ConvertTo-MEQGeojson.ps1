Write-Host("Conversion du Réseau Universitaire")
& .\universitaire.ps1
Write-Host("Conversion du Réseau Collégial")
& .\collegial.ps1
Write-Host("Conversion des CSS - Territoire Complet")
& .\css_territoirecomplet.ps1
Write-Host("Conversion des CSS - Territoires")
& .\css_territoire.ps1
Write-Host("Conversion des CSS - Établissements")
& .\css_etablissements.ps1
Write-Host("Conversion du Réseau Privé - Établissements")
& .\prive_etablissements.ps1
Write-Host("Conversion du Résea Privé - Installations")
& .\prive_installations.ps1
Write-Host("Conversion du Réseau Public - Gouvernemental")
& .\pub_gouvernemental.ps1