---
title: Migrer des données historiques de Domoticz vers Home Assistant
lang: fr
tags:
- Home Assistant
- Domoticz
- SQL
categories:
- Domotique
toc: 1
date: '2025-06-14 13:00:00'
image: files/2025/migration-data-domoticz-vers-homeassistant.png
---

Dans le cadre de ma migration de Domoticz vers Home Assistant, je voulais récupérer l'historique de mes capteurs depuis presque dix ans. Cependant, malgré l'écosystème hyper important autour de Home Assistant, il y a peu de solution de migration de données.

Ci-dessous la méthode que j'ai utilisée, basée sur un export des données depuis la base SQLite et l'import dans Home Assistant via un plugin déjà disponible dans HACS, le store communautaire, et l'addon SQLWeb. Ce que je présente ci-dessous est encore très manuel, adapté pour quelques capteurs ciblés (pour ma part j'avais seulement 2 capteurs dont je voulais ne pas perdre l'historique) ; la méthode pourrait cependant être automatisée moyennant quelques efforts.

# Export et préparation des données via SQL
On va faire l'extraction des données et le formatage pour import via homeassistant-statistics directement en SQL. 

J'ai utilisé pour ce faire [SQLiteStudio](https://sqlitestudio.pl/) (`scoop install sqlitestudio` avec [scoop](https://scoop.sh)), mais n'importe quel client SQL pour SQLite fera l'affaire.

Pour chaque capteur il faudra repérer :
- L'identifiant de Device dans Domoticz, visible dans le menu de configuration Devices (`255` dans l'exemple ci-dessous)
- Le nom du capteur dans Home Assistant (`sensor.xxx`), ainsi que son unité (`°C`) ; vous pouvez trouver cette information dans différents écrans de paramétrage, ou plus simplement en regardant dans la table `statistics_meta` via l'addon SQLite Web qu'il est possible d'installer et de lancer via Paramètres / Modules complémentaires (Home Assistant OS uniquement)

Exemple de consultation de la table statistics_meta depuis SQLite Web:

![]({{ 'files/2025/HA_Import_Domoticz_2025-06-08 193227.png' | relative_url }}){: .img-center .mw80}

SQL pour migrer un capteur de température :

```sql
SELECT 
-- Replace by the name of the sensor in home assistant (see statistics_meta)
'sensor.cuisine_temperature' as 'statistic_id', 
'°C' as 'unit',
 strftime('%d.%m.%Y', Date) || ' 00:00' as 'start',
 Temp_Min as 'min',
 Temp_Max as 'max',
 Temp_Avg as 'mean' 
FROM Temperature_Calendar 
-- Replace by domoticz id (see DeviceStatus)
WHERE DeviceRowID = 255   
ORDER BY Date
```

Il faut ensuite exporter le résultat dans un fichier CSV (avec encoding UTF-8)

![]({{ 'files/2025/HA_Import_Domoticz_2025-06-08 192918.png' | relative_url }}){: .img-center .mw80}

Pour un autre type de capteur, la recette est la même, il faut changer la table source dans Domoticz pour extraire Min / Max / Mean

SQL pour migrer un capteur de poids :
```sql
SELECT 
-- Replace by the name of the sensor in home assistant (see statistics_meta)
'sensor.mi_body_composition_scale_b854_poids' as 'statistic_id', 'kg' as 'unit',
 strftime('%d.%m.%Y', Date) || ' 00:00' as 'start',
 Percentage_Min as 'min',
 Percentage_Max as 'max',
 Percentage_Avg as 'mean' 
FROM Percentage_Calendar 
-- Replace by domoticz id (see DeviceStatus)
WHERE DeviceRowID = 283   
ORDER BY Date
```



# Import dans Home Assistant via homeassistant-statistics

L'import s'effectue avec [homeassistant-statistics](https://github.com/klausj1/homeassistant-statistics) disponible depuis [HACS](https://www.hacs.xyz/). 

L'installation est très simple en suivant les instructions sur leurs sites. 
- Pour HACS voir également [cet article en français illustré étape par étape](https://www.lesalexiens.fr/actualites/comment-installer-hacs-home-assistant/)
- Pour homeassistant-statistics, en plus de l'installation via HACS, il faut ajouter `import_statistics:`  à la fin du configuration.yaml. Si vous ne l'avez pas déjà fait, l'installation de l'addon Studio Code Server est vraiment pratique pour modifier les fichiers de configuration par la suite (pas besoin de le mettre en démarrage automatique, vous pouvez le lancer uniquement au besoin)

il faut ensuite importer les fichiers CSV dans le même répertoire que le fichier `configuration.yaml` (vous pouvez utiliser également l'addon Studio Code Server pour importer le fichier)

L'utilisation se fait via l'onglet Actions dans les outils de développement de Home Assistant, en renseignant les différentes informations demandées :

![]({{ 'files/2025/HA_Import_Domoticz_2025-06-08 185437.png' | relative_url }}){: .img-center .mw80}

Puis cliquer sur le bouton "Exécuter l'action", qui passe en vert en cas de succès.

Vous pouvez ensuite aller sur le capteur pour aller voir son historique et voir le bon import.

À noter:
- si vous ne trouvez pas l'action import_from_file, il faut redémarrer Home Assistant après l'installation depuis HACS
- en cas d'erreur, vérifier l'identifiant du capteur dans Home Assistant, et l'encodage du fichier CSV
 

# Alternatives & Inspirations

Il existe deux autres possibilités :
- [home-assistant-import](https://github.com/Johanbos/home-assistant-import) : outil qui lit directement la base de données SQLite de Domoticz pour extraire les données et créer des requêtes SQL à passer sur la base Home Assistant. Malheureusement ne cible que les capteurs de production et consommation d'électricité, et non les types de données que je voulais importer.
- [Domoticz2HomeAssistant](https://github.com/brjhaverkamp/Domoticz2HomeAssistant) : c'est un fichier tableur (LibreOffice / Excel) qui permet de mettre en forme un export de données Domoticz pour importer via [homeassistant-statistics](https://github.com/klausj1/homeassistant-statistics) , j'ai trouvé la méthode du tableur un peu compliquée car il faut comprendre comment ça marche et mettre dans les bonnes cases, et cela ne supportait pas non plus tous les capteurs que je voulais importer ; c'est cependant ce qui a inspiré la méthode décrite ci-dessus, en remplaçant le tableur par l'extract et formatage en SQL.
