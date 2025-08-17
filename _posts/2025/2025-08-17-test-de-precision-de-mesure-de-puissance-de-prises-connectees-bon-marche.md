---
title: Test de précision de mesure de puissance de prises connectées bon marché
lang: fr
tags:
- Conso
- Compteurs
categories:
- Domotique
- Avis Conso
date: '2025-08-16 11:00:00'
ia: Perplexity
toc: 1
New field 4: fr
image: files/2025/Perplexity_conso_clim_illustration.jpg
---

L’idée de ce test est simple : vérifier si des prises connectées à bas prix peuvent mesurer la consommation d’un climatiseur avec la même précision qu’un **wattmètre dédié**. Toutes les prises ont été branchées ensemble, et la consommation intrinsèque des prises étant négligeable par rapport à celle de la climatisation.

![]({{ 'files/2025/dispo_clim_conso.jpg' | relative_url }}){: .img-center .mw40}

Trois prises bon marché différentes ont été comparées, toutes les trois chinoises, sans marque, achetées séparément, sans doute différentes mais rien de visible. Le test s’est déroulé sur trois sessions : **6,5 h**, **10 h** et **9 h**.  C'est bien sûr tout à fait insuffisant pour une étude sérieuse, mais suffisant pour quelques tendances et ordres de grandeur.

Je souhaite également me rendre compte si cette méthode de test peut permettre de calibrer ces prises si je parviens à les passer sous Tasmota, car le changement de firmware peut nécessiter une recalibration.

# Puissance instantanée (W)

|  Prise |  M1 |  M2 | M3  | M4 | M5 | Variation | Écart |
| :-- | --: | --: | --: | --: | --: | :--: | :--: |
| Wattmètre (Ref) | 694 | 680 | 690 | 690 | 690.0 | 1.0% |  |
| Prise 1 | 734 | 749.3 | 766 | 770 | 770.0 | 2.4% | **10%** |
| Prise 2 | 705 | 652.6 | 687 | 693 | 689.0 | 3.8% | <1% |
| Prise 3 | _570_ | 709 | 716 | 716 | 717.0 | **10.7%** |  <1% |

La colonne "Variation" décrit la stabilité de la mesure de la prise. La colonne "Ecart" mesure l'écart absolu à la valeur de référence.

La prise 2 est plutôt exacte, la prise 1 est stable, mais très en écart par rapport à la référence, contrairement à la prise 3, avec de grosses variations au début, mais un écart faible ensuite. Trois prises, trois profils différents. Il ne faut pas attendre mieux de ces prises bon marché qu'une précision de 10% (et encore une belle illustration de la différence entre précision et résolution, au dixième de Watt)

Notes :
- A la lecture les mesures des 3 prises sont très instables
- Les conditions thermiques étant similaires, il est raisonnable de penser que la consommation de la climatisation était proche d'être fixe sur la période des tests (soit ~690W)
- Les premières mesures sont les plus en écart, puis semblent se stabiliser ensuite ; de l'auto-calibration ?
- La première mesure de la prise 3 n'est pas une erreur, c'est également confirmé par la consommation du jour


# Consommation du jour (kWh)

|  Prise | J1 (6,5h) | J2 (10h) | J3 (9h) | Écart | 
| :-- | --: | --: | --: | :--: | 
| Wattmètre (Ref) | 4.5 | 6.9 | 6.2 |  | 
| Prise 1 | 4.48 | 6.91 | 6.2 | 0.1% |
| Prise 2 | 4.67 | 6.78 | 6.08 | 2.5% | 
| Prise 3 | 4.14 | 7.01 | 6.29 | 3.7%  | 

Les résultats cumulés sur une journée sont bien meilleurs, avec un écart de moins de 5%, voire moins de 2% si on exclue le premier jour.

Les résultats sont également compatibles avec d'une part la consommation instantanée probable de 690 W et l'écart de consommation relevé par Enedis (merci Linky) :

![]({{ 'files/2025/clim_conso.png' | relative_url }}){: .img-center .mw60}

# Tendances
Ces prises bon marché sont très bien pour **suivre la tendance** de consommation sur plusieurs jours , par contre il ne faut pas attendre de mesure précise de la puissance instantanée, il faut imaginer une erreur pouvant aller jusqu'à 10%

En résumé :  
📊 **Conso cumulée → OK sur toutes**  
⚡ **Puissance instantanée → gros écarts selon modèle**


# Et finalement, elle consomme combien cette climatisation ?
Le climatiseur utilisé est un KLINDO KMAC7KM-21   *(Marque d'import Carrefour - Je passe sur l'arnaque de Carrefour Drive qui a substitué un KMAC9KM-21  plus puissant de 20% avec ce modèle sans prévenir et sans réduction de prix ; et comme seule réponse du service client que je pouvais le ramener pour un remboursement...)* 

Manifestement la puissance mesurée 690 W

Sur le carton et sur l'étiquette, il est mentionné une puissante de 2 kW ; en retrouvant la fiche descriptive de Carrefour sur leur site, on trouve la double mention suivante :
- Puissance max (en W) 2     *(imaginons qu'il s'agisse plutôt de 2 kW)*
- Puissance (en W) 980

L'écart est énorme (je serai curieux de connaître à quelles conditions correspond la puissance max), et a priori très éloigné de l'usage réel, c'est plutôt bizarre de mettre en avant commercialement la valeur la plus élevée, mais tant mieux c'est une bonne surprise pour moi de voir que ça consomme moins que ce que je craignais. Bien sûr, la performance énergétique n'en ait pas meilleure pour autant, et si le sujet vous intéresse, [cette vidéo youtube](https://youtu.be/7CXrygsg6_4) est assez intéressante en vulgarisation de la performance énergétique des climatisations.
