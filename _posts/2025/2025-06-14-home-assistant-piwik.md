---
title: Intégration de statistiques Piwik Pro (Custom card et sensor command_line)
lang: fr
tags:
- Home Assistant
- Custom
- Card
- Piwik
categories:
- Domotique
toc: 2
date: '2025-06-14 18:08:00'
image: files/2025/homeassistant-piwik-cards-vignette.png
---

Home Assistant est extensible très facilement, et permet d'intégrer donc de nouvelles sources. Cet article permet de montrer comment ajouter des reports Piwik Pro (web analytics) dans un dashboard Home Assistant, et également des capteurs virtuels pour récupérer certaines valeurs de Piwik :

![]({{ 'files/2025/homeassistant-piwik-cards.png' | relative_url }}){: .img-center .mw80} 


# Custom cards Piwik
Pour les cards nous allons utiliser la même méthode de récupération des données que pour l'affichage des Top Articles sur mon site web, [décrit dans cet article]({{ '/2024/01/top-viewed-posts-in-jekyll-with-piwik/' | relative_url }}), à savoir la récupération des données via un report public, qui expose les données via un fichier json. Je vous renvoie à l'article pour le détail de la mise en place du Custom Report sur Piwik Pro et son exposition via le bouton Share / Public link. A noter que le lien est valable seulement sur un temps limité et devra être renouvelé tous les 6 mois. À noter que le code javascript des cards est exécuté  coté navigateur, il est donc tout à fait déconseillé d'y mettre des mots de passe ou token, ce qui empêche donc l'usage de l'API.

Pour plus d'information et des astuces sur la mise en place des custom cards sous Home Assistant, quelques astuces sont données dans [mon précédent article sur le sujet]({{ '/2025/06/home-assistant-custom-card-links/' | relative_url }}).

## Pour les graphiques Piwik

Voici le premier fichier (à mettre dans `/config/www/card-piwik.js`, et à déclarer avec `Tableaux de bords / Ressources / Ajouter une ressource`)
```js
class CardGraphPiwik extends HTMLElement {
  async setConfig(config) {
    if (!this.content) {
      this.innerHTML = `
          <ha-card>
            <canvas id="jsonChart" height="160"></canvas>
          </ha-card>
        `;
      this.content = true;
    }
    // Charger Chart.js si pas déjà là
    if (!window.Chart) {
      const chartJs = document.createElement("script");
      chartJs.src = "https://cdn.jsdelivr.net/npm/chart.js";
      document.head.appendChild(chartJs);
      await new Promise((resolve) => (chartJs.onload = resolve));
    }

    // Charger les données JSON
    const url = config.json_url; // || "/local/data.json";
    if (config.report_url)
      url = atob(config.report_url?.split("/").slice(-2)[0]);
    if (!url) {
      throw new Error("You must defind json_url or report_url");
    }

    this.url = url;
    this.config = config;

    this.refreshGraph()

    if (config.refresh_seconds) setTimeout(() => this.refreshGraph(), config.refresh_seconds * 1000)
  }

  async refreshGraph() {
    const response = await fetch(this.url);

    const json = await response.json();
    const reportData = json?.reportData?.data;
    const reportConfig = json?.reportConfig;

    const column_data2key = 
      ({column_id: cid, transformation_id: tid}) => (cid ?? "") + ( tid ? ("__"+tid) : "")

    // label_key
    const label_col = reportConfig.columns.find(c => c.axis == "x");
    const label_key = column_data2key(label_col?.column_data)

    // Création du graphique
    const ctx = this.querySelector("#jsonChart").getContext("2d");
    if (this.chart) this.chart.destroy();
    this.chart = new Chart(ctx, {
      type: "line",
      data: {
        labels: reportData?.map((v) => v[label_key]),
        datasets: reportConfig.columns.filter(c => c.axis != "x").map(col => {
          const colKey = column_data2key(col.column_data)
          return {
            label: col.column_meta?.column_name,
            data: reportData?.map((v) => v[colKey]),
            tension: 0.3,
            ...(this.config?.columns?.[colKey])
          }
        })
      },
      options: {
        responsive: true,
        plugins: {
          legend: { display: true },
          title: { display: true, text: reportConfig?.name }
        },
        scales: {
          x: { display: true, /* title: { display: true, text: "Date" }*/ },
          y: { display: true, /* title: { display: true, text: "Nb" },*/},
        },
      },
    });
  }

  set hass(hass) { }

  getCardSize() {
    return 2;
  }

  static getStubConfig() {
    return { 
      report_url: 'https://xxxx.piwik.pro/analytics/#/sharing/xxxxxxx/',
      refresh_seconds: 3600
    };
  }
}

customElements.define("card-graph-piwik", CardGraphPiwik);

window.customCards = window.customCards || [];
window.customCards.push({
  type: "card-graph-piwik",
  name: "Card Piwik Graph",
  description: `Custom card for Piwik Graph.
  
  You have to provide at least report_url or json_url. 
  - report_url is the URL given by Piwik when sharing a report
  - json_url is the URL of the data for the report

  You can set up the refresh rate with refresh_seconds 

  The card will get configuration from the report.
  
  You may also customize the display by setting a columns config, 
  with keys corresponding to the key of the report, having as value
  an object with key corresponding to GraphJs datasets properties`,
});
```
Cette première card fonctionne pour les reports en mode graphique. Il récupère automatiquement les bons libellés d'axes à partir des meta data Piwik et génère le graphique grâce à la bibliothèque Charts.js.

L'utilisation est très simple, via le code yaml suivant:
```yaml
type: custom:card-graph-piwik
json_url: https://pp-core-p-gwc.piwik.pro/blobs/shares/xxxxxxxxxxx.json
```

Vous devez soit indiquer l'URL json avec `json_url:` ou directement l'URL du rapport fourni par Piwik lors du bouton Share en utilisant `report_url:`.

Comme indiqué sommairement dans la documentation, vous avez également la possibilité de customiser l'affichage du graphique en utilisant l'option `columns:`, le nom de la série, et le paramètre Charts.js à modifier 

Par exemple pour spécifier la couleur de la série `visitors` :
```yaml
columns:
  visitors:
    borderColor: blue
```

Si vous souhaitez rafraichir les données automatiquement, vous pouvez utiliser `refresh_seconds: 600`  pour actualiser toutes les 5 minutes par exemple. À noter que l'actualisation est automatique lors de l'affichage du dashboard, ce paramètre est donc seulement utile si vous laissez le dashboard ouvert.



## Pour les tableaux Piwik

Et voici la deuxième card pour les tableaux  (à mettre dans `/config/www/card-piwik-table.js`, et à déclarer avec `Tableaux de bords / Ressources / Ajouter une ressource`)
```js
class CardTablePiwik extends HTMLElement {
  async setConfig(config) {
    // Charger les données JSON
    var url = config.json_url; // || "/local/data.json";
    if (config.report_url)
      url = atob(config.report_url?.split("/").slice(-2)[0]);
    if (!url) {
      throw new Error("You must define json_url or report_url");
    }

    if (!config.columns?.length) {
      throw new Error("You must define columns")
    }

    this.url = url;
    this.config = config;

    this.refreshGraph()

    if (config.refresh_seconds) setTimeout(() => this.refreshGraph(), config.refresh_seconds * 1000)
  }

  async refreshGraph() {

    const response = await fetch(this.url);

    const json = await response.json();
    const reportData = json?.reportData?.data;
    const reportConfig = json?.reportConfig;
    
    const column_data2key = 
      ({column_id: cid, transformation_id: tid}) => (cid ?? "") + ( tid ? ("__"+tid) : "")

    this.innerHTML = `
      <ha-card>
        <style>
        td { overflow: hidden; text-overflow: ellipsis; -webkit-line-clamp: 1; }
        </style>
        <table style="width:100%;">
         <tr> 
         ${ this.config.columns.map(col => 
           `<th>
           ${reportConfig.columns.find(c => column_data2key(c.column_data) == col)?.column_meta?.column_name ?? col}
           </th>`).join("") }
         </tr>
         ${ reportData.slice(0, this.config.max ?? 10).map( l => 
          `<tr>
           ${ this.config.columns.map(col => `<td>${l[col]}</td>`).join("") }
          </tr>`).join("") }
        </table>
      </ha-card>
    `;

  }

  set hass(hass) { }

  /*
  getCardSize() {
    return 2;
  }
  */

  static getStubConfig() {
    return { 
      report_url: 'https://xxxxx.piwik.pro/analytics/#/sharing/xxxxxxx/',
      refresh_seconds: 3600,
      columns: ['event_title', 'events'],
      max: 10
    };
  }

}

customElements.define("card-table-piwik", CardTablePiwik);

window.customCards = window.customCards || [];
window.customCards.push({
  type: "card-table-piwik",
  name: "Card Piwik Table",
  description: `Custom card for Piwik Table.
  
  You have to provide at least report_url or json_url. 
  - report_url is the URL given by Piwik when sharing a report
  - json_url is the URL of the data for the report

  You can set up the refresh rate with refresh_seconds 

  You have to define the columns config to list the columns you want in 
  which order.`,
});

```

Pour utiliser, il faut également paramétrer la card en yaml:
```yaml
type: custom:card-table-piwik
report_url:  https://lprp.piwik.pro/analytics/#/sharing/xxxxxx/
columns:
  - event_title
  - events
max: 10
```

Comme la card précédent, il faut également fournir soit `json_url:`, soit `report_url:`. Et vous pouvez définir également `refresh_seconds:`.

Il vous faudra déclarer en plus la liste des colonnes à utiliser dans `columns:` (et dans l'ordre dans lequel vous voulez l'affichage), en listant les identifiants des séries (que vous pouvez voir dans le JSON, ou déduire du libellé dans Piwik)

Vous pouvez enfin indiquer le nombre maximum d'entrées à afficher avec `max:` ; en l'absence, toutes les entrées sont affichées.


# Virtual Sensors Piwik
Contrairement aux cards ci-dessus, qui affichent des données externes mais sans que les données soient importées dans Home Assistant, nous allons ici intégrer quelques données dans Home Assistant (et avoir la capacité de les historiser et de les afficher avec les cards classiques)

Le code étant exécuté coté serveur, nous allons pouvoir ici utiliser l'API Piwik Pro, et s'authentifier via OAuth2. La documentation de l'API semble plutôt bien fournie, et pourtant il n'est pas simple de trouver les bons paramètres pour obtenir ce que l'on veut. Des exemples de la communauté permettent de s'y retrouver.

Il y a la possibilité de définir des capteurs "ligne de commande", qui appellent simplement une ligne de commande pour raffraichir la valeur du capteur. Il y a également plein d'autres options décrites [dans la documentation](https://www.home-assistant.io/integrations/command_line/).

Voici le code python utilisé pour le capteur, qui réalise l'authentification et l'appel pour récupérer les données (`/config/scripts/sensor-piwik.py`)
```python
import datetime
import sys
import urllib.request
import urllib.parse
import json

instance_url = "https://xxxxxx.piwik.pro"
website_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
client_id = "xxxxxxxxxxxxx"
client_secret = "xxxxxxxxxxxxxx"

def piwik_get_token():
    token_url = instance_url + "/auth/token"
    token_data = {
        "grant_type": "client_credentials",
        "client_id": client_id,
        "client_secret": client_secret
    }
    data_encoded = urllib.parse.urlencode(token_data).encode("utf-8")
    req = urllib.request.Request(token_url, data=data_encoded, method="POST")
    req.add_header("Content-Type", "application/x-www-form-urlencoded")
    try:
        with urllib.request.urlopen(req) as response:
            token_result = json.loads(response.read())
            bearer_token = token_result['access_token']
            return bearer_token
    except:
        print("Error retrieving token")
        exit(1)
        return None

def piwik_get_data(bearer_token, date_from, date_to):
    api_url = instance_url + '/api/analytics/v1/query'
    req_data = {
        "date_from": date_from,
        "date_to": date_to,
        "website_id": website_id,
        "offset": 0,
        "limit": 10,
        "columns": [
            {"column_id": "visitors"},
            {"column_id": "page_views"}
        ]
    }
    data_encoded = json.dumps(req_data).encode('utf-8')
    req_api = urllib.request.Request(api_url, data=data_encoded, method="POST")
    req_api.add_header("Authorization", f"Bearer {bearer_token}")
    
    try:
        with urllib.request.urlopen(req_api) as response:
            api_result = json.loads(response.read())
            return api_result
    except urllib.error.HTTPError as e:
        error_body = e.read().decode()
        print(json.dumps({"error": {"code": e.code, "body": error_body}}))
        exit(1)
        return None
    except Exception as e:
        print(json.dumps({"error": {"exception:": e}}))
        exit(1)
        return None

bearer_token = piwik_get_token()

month_start = (datetime.datetime.now().replace(day=1)).strftime('%Y-%m-%d')
ago30days = (datetime.datetime.now() - datetime.timedelta(days=30)).strftime('%Y-%m-%d')
yesterday = (datetime.datetime.now() - datetime.timedelta(days=1)).strftime('%Y-%m-%d')
today = (datetime.datetime.now()).strftime('%Y-%m-%d')

match sys.argv[1] if len(sys.argv) > 1 else "":
    case "month":
        date_from = month_start
        date_to = today
    case "30days":
        date_from = ago30days
        date_to = today
    case "yesterday":
        date_from = yesterday
        date_to = yesterday
    case "today":
        date_from = today
        date_to = today
    case _:
        print("Invalid argument. Use 'month', '30days', 'yesterday' or 'today'.")
        exit(1)

try:
    data = piwik_get_data(bearer_token, date_from, date_to)
    formatted_data = {
        "date_query": datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
        "date_from": date_from,
        "date_to": date_to,
        "data":  dict(zip(data["meta"]["columns"], data["data"][0]))
    }
    print(json.dumps(formatted_data))
except Exception as e:
    print(json.dumps({"error": {"exception": str(e)}, "data": data}))
    exit(1)
```  

N'oubliez pas de customiser le script avec vos identifiants, à créer et récupérer dans l'interface Piwik Pro.

Il faut ensuite définir les capteurs dans configuration.yaml:
```yaml
command_line:
- sensor:
    name: "LPRP.fr - Visiteurs (Hier)"
    unique_id: piwik_lprp_visitors_yesterday
    command: "python3 /config/scripts/sensor_matomo_visits.py yesterday"
    scan_interval: 36000
    value_template: "{{ value_json.data.visitors }}"
    unit_of_measurement: "visiteurs"
    json_attributes:
      - date_query
      - date_from
      - date_to
- sensor:
    name: "LPRP.fr - Pages (Hier)"
    unique_id: piwik_lprp_pages_yesterday
    command: "python3 /config/scripts/sensor_matomo_visits.py yesterday"
    scan_interval: 36000
    value_template: "{{ value_json.data.page_views }}"
    unit_of_measurement: "pages"
    json_attributes:
      - date_query
      - date_from
      - date_to
```

Il faut redémarrer Home Assistant et vous pourrez utiliser vos nouveaux capteurs dans des cards, par exemple:
```yaml
type: glance
entities:
  - entity: sensor.lprp_fr_visiteurs_hier
    icon: mdi:calendar-week
    name: Hier
```

Quelques précisions:
- Home Assistant date les données au moment où elles sont récupérées, donc par exemple, même si sensor.lprp_fr_visiteurs_hier concerne le nombre de visiteurs de la veille, la donnée sera enregistré le jour de la récupération ; donc si vous regardez l'historique, rappelez vous de ce petit jour de décalage
- Il n'est pas possible d'indiquer une heure de récupération, seulement un intervalle ; il est donc impossible d'indiquer de faire l'appel à 23h59 pour avoir les visiteurs du jour. 
- Pour un capteur qui récupère par exemple les visiteurs du jour toutes les heures, vous aurez un historique en dents de scie, qui augmente au fur et à mesure de l journée, et remis à zéro tous les jours. L'affichage d'un historique sur cette valeur n'est pas très pertinent, et Home Assistant va convertir en min/mean/max, ce qui n'a pas beaucoup de sens. C'est pour cela que je préfère le nombre de visiteurs de la veille, qui a le mérite d'être correct quelque soit l'heure d'interrogation.
