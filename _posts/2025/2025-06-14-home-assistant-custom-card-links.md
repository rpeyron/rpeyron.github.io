---
title: Custom card Home Assistant pour des liens web (migration homer)
lang: fr
tags:
- Home Assistant
- Card
- Custom
- Links
- Web
categories:
- Domotique
date: '2025-06-14 17:48:02'
image: files/2025/homeassistant-card-links-vignette.png
---

J'aime bien pouvoir ajouter sur les dashboards les URLs des services que j'utilise souvent. Cet article décrit comment j'ai fait dans Home Assistant


# Solutions précédentes sous Domoticz et Homer

Sous Domoticz j'avais déjà ajouté la fonction pour ajouter des URL dans un menu spécifique, voir [cet article]({{ '/2020/12/domoticz-panasonic-remote-buttons-and-custom-urls/' | relative_url }}) 

![](/files/2020/12/domoticz_externalurl_menu.png){: .img-center}

Puis j'ai ensuite utilisé [Homer](https://github.com/bastienwirtz/homer) pour un dashboard hyper léger et pratique sous Raspberry Pi Zero

![]({{ 'files/2025/dashboard-homer.png' | relative_url }}){: .img-center .mw60}

J'ai donc cherché à faire la même chose sous Home Assistant, dans un dashboard. Cependant, je n'ai pas trouvé le moyen d'avoir un lien web avec une icône en image, et facilement.


# Custom Card sous Home Assistant

Heureusement, il y a la possibilité d'étendre les possibilités de Home Assistant avec les [Custom Cards](https://developers.home-assistant.io/docs/frontend/custom-ui/custom-card/) ; c'est donc ce que j'ai fait, voici ce que cela donne : 

![]({{ 'files/2025/homeassistant-card-links.png' | relative_url }}){: .img-center .mw80}

La documentation est plutôt bien faite et il y a beaucoup d'exemples sur les forums ; il faut 
- créer le fichier javascript dans `/config/www/card-links.js` (voir code ci-dessous)
- ajouter la ressource via `Dashboard / Resources / Add resource`  et ajouter `/local/card-links.js` (`/local/` correspond à `/config/www`)
- puis retourner à l'édition du dashboard et ajouter la nouvelle card

Le plus difficile dans la phase de développement est de trouver comment faire prendre en compte les modifications de code à Home Assistant ; j'ai commencé par essayer ce que j'ai trouvé sur le web, à savoir recharger les yaml, redémarrer Home Assistant, forcerle rafraichissement de la page, supprimer le cache du navigateur, mais rien n'y faisait. Au final la solution que j'ai trouvée au détour d'un forum Home Assistant est plus simple et plus pratique, et consiste à ajouter un suffixe `?v=xx` que l'on incrémente au fur et à mesure des essais, en cliquant sur la ressource concernée dans `Dashboard / Resources`.

Quelques détails:
- taille de la card : j'ai essayé initialement d'utiliser   getCardSize() et  getGridOptions()  sans succès ; au final, simplement retirer ces fonctions a permis que la taille de la card s'adapte automatiquement à la taille utile
- l'idéal serait de définir le paramétrage visuel, mais c'est plus compliqué que la card elle-même, donc je n'ai pas encore investi le temps nécessaire ; inclure `getStubConfig()` permet relativement de s'en passer, en fournissant un exemple avec l'ensemble des champs dont il est utile de se souvenir
- pour aoir la card dans la liste des card proposées, il suffit de l'ajouter dans `window.customCards` 

# Exemple de paramétrage

A éditer en YAML:

```yaml
type: custom:content-card-links
name: AI Tools
items:
  - name: Perplexity
    url: https://www.perplexity.ai/
    logo: https://www.perplexity.ai/favicon.ico
  - name: Chat GPT
    url: https://chatgpt.com/
    logo: https://chatgpt.com/favicon.ico
  - name: Mistral
    url: https://chat.mistral.ai/chat
    logo: https://chat.mistral.ai/favicon.ico
```

Le paramètre `logo:` permet  d'indiquer une image. Pour utiliser une icone, il est possible de remplacer par `icon:`  et utiliser une icone mdi ou autre. Pour utiliser une image locale, il est possible de mettre les images dans `/config/www` et d'utiliser le préfixe `/local/` (par exemple `/local/logos/chat.png` pour pointer sur `/config/www/logos/chat.png`)


# Code source pour la card content-card-links

```js
/**
 * To be added in /config/www/card-links.js
 * Add with Dashboard / Resources / Add resource /  "/local/card-links.js"
 * Update by adding & incrementing ?v=xx after "/local/card-links.js?v=2" & refresh dashboard
 */

class ContentCardLinks extends HTMLElement {

  // Static content, so we render in setConfig
  setConfig(config) {
    // Use throw to show config error 
    this.innerHTML = `
      <ha-card header="${config?.name ?? ""}">
      <style>
        ul { list-style: none; margin: 0; padding: 0; }
        li { display: flex; align-items: center; margin-bottom: 12px; }
        img, .icon { width: 28px; height: 28px; margin-right: 10px; }
        a { text-decoration: none; color: inherit; display: flex; align-items: center;}
        .card-content {}
      </style>
      <div class="card-content">
      <ul>
        ${config.items.map(item => `
          <li>
            <a href="${item.url}" target="_blank">
              ${item.logo ? `<img src="${item.logo}" />` : `<span class="icon"><ha-icon icon="${item.icon}"></ha-icon></span>`}
              <span>${item.name}</span>
            </a>
          </li>
        `).join('')}
      </ul>
      </div>
      </ha-card>
    `;
  }

  // Use if we need dynamic content, or home assistant state, but not the case here
  set hass(hass) {}

  static getStubConfig() {
    return { 
      name: 'Example',
      items: [{
        name: "Name of item",
        url: "https://target.org",
        logo: "/local/logos/logo.svg",
        icon: "mdi:home-assistant"
      }]
    };
  }

}

customElements.define("content-card-links", ContentCardLinks);

window.customCards = window.customCards || [];
window.customCards.push({
  type: "content-card-links",
  name: "Card Links",
  description: "Custom card for links",
});

```
