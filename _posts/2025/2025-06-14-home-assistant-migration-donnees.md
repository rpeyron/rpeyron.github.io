---
title: Migrer des données historiques entre deux instances Home Asssistant
lang: fr
tags:
- Home Assistant
- SQL
- Migration
categories:
- Domotique
date: '2025-06-14 13:49:48'
image: files/2025/migration-data-home-assistant.png
---

La migration vers Home Assistant s'est déroulée sur environ 6 mois, et comme j'ai expérimenté différents modes de déploiement pour déterminer celui qui me corresponde le mieux, j'ai eu pendant 6 mois une version sous docker qui a collecté un certain nombre de données que je souhaitais récupérer sur ma nouvelle instance. Or il n'existe pas d'outil qui permette de merger deux bases de données Home Assistant.

A l'instar de ce que j'ai fait pour migrer les données de Domoticz (décrit dans  [cet article]({{ '/2025/06/home-assistant-migration-donnees-domoticz/' | relative_url }})), ci-dessous la méthode que j'ai utilisée pour migrer quelques capteurs d'une autre instance Home Assistant, via un export des données depuis la base SQLite et l'import dans Home Assistant via un plugin déjà disponible dans HACS, le store communautaire, et l'addon SQLWeb. Ce que je présente ci-dessous est encore très manuel, adapté pour quelques capteurs ciblés (pour ma part j'avais seulement 2 capteurs dont je voulais ne pas perdre l'historique) ; la méthode pourrait cependant être automatisée moyennant quelques efforts.

# Export et préparation des données via SQL
On va faire l'extraction des données et le formatage pour import via homeassistant-statistics directement en SQL. J'ai utilisé pour ce faire [SQLiteStudio](https://sqlitestudio.pl/) (`scoop install sqlitestudio` avec [scoop](https://scoop.sh)), mais n'importe quel client SQL pour SQLite fera l'affaire. Pour récupérer la base SQLite de Home Assistant, le plus simple est de créer une sauvegarde (via `Paramètres / Système / Sauvegardes`), puis de télécharger la sauvegarde, puis à l'intérieur du fichier tar de sauvegarde, d'ouvrir le fichier `homeassistant.tar.gz`, et d'extraire `data/home-assistant_v2.db`

Pour trouver la liste chaque capteur à migrer en regardant dans la table `statistics_meta`. Il faut vérifier que les capteurs ont le même nom dans votre instance cible, à vérifier également ans la table `statistics_meta` via l'addon SQLite Web qu'il est possible d'installer et de lancer via Paramètres / Modules complémentaires (Home Assistant OS uniquement). S'il y a certains capteurs avec des noms différents, il faudra ajouter une conversion.

Exemple de consultation de la table statistics_meta depuis SQLite Web:

![]({{ 'files/2025/HA_Import_Domoticz_2025-06-08 193227.png' | relative_url }}){: .img-center .mw80}

Une fois ces éléments récupérés, on va extraire les données via le script SQL suivant :

```sql
SELECT 
    CASE 
      -- Pour les capteurs dont il faut modifier l'identifiant
      WHEN sm.statistic_id = 'sensor.mi_body_composition_scale_b854_mass' 
                        THEN 'sensor.mi_body_composition_scale_b854_poids'
      WHEN sm.statistic_id = 'sensor.nodemcu_temperature_salon_2' 
                        THEN 'sensor.nodemcu_temperature_salon'
      WHEN sm.statistic_id = 'sensor.nodemcu_internal_temperature_2' 
                        THEN 'sensor.nodemcu_internal_temperature'
      ELSE sm.statistic_id 
    END AS statistic_id,
    sm.unit_of_measurement AS unit,
    strftime('%d.%m.%Y %H:%M', datetime(start_ts,'unixepoch')) AS start,
    s.min AS min,
    s.max AS max,
    -- De temps en temps la valeur moyenne dépasse min/max
    MAX(s.min,MIN(s.max,s.mean)) AS mean    
FROM statistics s, statistics_meta sm
WHERE s.metadata_id = sm.id
AND statistic_id IN (
  -- La liste des capteurs à extraire
  'sensor.temperature_humidity_sensor_a408_temperature',
  'sensor.temperature_humidity_sensor_a408_humidity',
  'sensor.mi_body_composition_scale_b854_mass',
  'sensor.nodemcu_temperature_salon_2',
  'sensor.nodemcu_humidit_salon',
  'sensor.nodemcu_internal_temperature_2',
  'sensor.nodemcu_temt6000_illuminance'
)
```

Puis sauvegarder les données dans un fichier CSV au format UTF-8.



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
- pour une raison bizarre, Home Assistant peut avoir des valeurs moyennes en dehors des bornes min/max et même si c'est un écart infime, c'est refusé lors de l'import, d'ou la formule intégrée au script SQL pour ajuster aux bornes.
