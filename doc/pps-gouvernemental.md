[Index](./index.md) &gt; [PPS - Gouvernemental](./pps-gouvernemental.md)

## Scripts
|  Fichier | Chemin |
|  --- | --- |
|  [pub_gouvernemental.ps1](../scripts/pub_gouvernemental.ps1) | ./scripts/pub_gouvernemental.ps1 |

## Fichiers originaux
|  Fichier | Fiche d'information |
|  --- | --- |
|  [pps_gouvernemental.geojson](https://www.donneesquebec.ca/recherche/dataset/2d3b5cf8-b347-49c7-ad3b-bd6a9c15e443/resource/819dd537-484d-455f-85dd-af2c9cb5777d/download/pps_gouvernemental.geojson) | [Données ouvertes du Québec](https://www.donneesquebec.ca/recherche/dataset/localisation-des-etablissements-d-enseignement-du-reseau-scolaire-au-quebec/resource/819dd537-484d-455f-85dd-af2c9cb5777d) |

## Fichiers générés
|  Fichier | Chemin |
|  --- | --- |
|  [etablissements.geojson](../dist/pps/gouvernemental/etablissements.geojson) | ./dist/pps/gouvernemental/etablissements.geojson |

## Propriétés
|  Propriété | Description | Propriété originale |
|  --- | --- | --- |
|  miseAJour | Date de la mise à jour des informations de l'université.  | DT_MAJ_GDUNO |
|  code | Code de l'organisme.  | CD_ORGNS |
|  nom | Nom officiel | NOM_OFFCL |
|  adresse | Adresse | ADRS_GEO_L1_GDUNO,<br/> ADRS_GEO_L2_GDUNO,<br/> NOM_MUNCP,<br/> CD_POSTL_GDUNO  |
|  web | Site web  | SITE_WEB |
|  reseau | Reseau auquel appartient de l'organisme, soit Public, Privé ou Gouvernemental. | RESEAU |
|  prescolaire | Si l'établissement enseigne le préscolaire. (1 si oui, 0 si non)  | PRESC |
|  primaire | Si l'établissement enseigne le primaire. (1 si oui, 0 si non)  | PRIM |
|  secondaire | Si l'établissement enseigne le secondaire. (1 si oui, 0 si non)  | SEC |
|  formationProfessionnelle | Si l'établissement enseigne la formation professionnelle. (1 si oui, 0 si non)  | FORM_PRO |
|  adulte | Si l'établissement enseigne aux adultes. (1 si oui, 0 si non)  | ADULTE |
|  ordreEnseignement | Somme des ordres d'enseignements de l'établissement. | ORDRE_ENS |
|  originales | Propriétés originales |  |