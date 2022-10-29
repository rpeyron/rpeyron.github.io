---
post_id: 5210
title: 'Optimisation de WordPress avec Cloudflare'
date: '2021-01-23T20:57:48+01:00'
last_modified_at: '2021-01-23T20:57:48+01:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=5210'
slug: optimisation-de-wordpress-avec-cloudflare
permalink: /2021/01/optimisation-de-wordpress-avec-cloudflare/
image: /files/wordpress_rocket_cloudflare.jpg
categories:
    - Informatique
tags:
    - CDN
    - Cloudflare
    - Optimisation
    - 'Plugin organizer'
    - Wordpress
    - cache
lang: fr
toc: true
---

Outre le confort d’utilisation pour les visiteurs, optimiser un site lui donnera une meilleure visibilité et permettra de décharger votre serveur et votre bande passante.

# Disclaimer et notions

Quel que soit le domaine, l’optimisation est une affaire de spécialistes. Et pour le web encore plus, tant les technologies et les solutions se complexifient et évoluent vite. Les solutions décrites dans cet article sera sans doute obsolète dans peu de temps. Par ailleurs je ne suis pas du tout un spécialiste du sujet, et je me suis intéressé au sujet dans un contexte bien particulier qui est celui d’un blog personnel (celui que vous lisez en ce moment) à zéro budget (les solutions seraient très différentes dans un contexte professionnel ou via des recours à des solutions spécialisées payantes). Cet article a vocation à faire la synthèse de ce que j’en ai appris, et un peu de vulgarisation sur le sujet. Il y a sans doute beaucoup d’approximations dont je m’excuse d’avance auprès des spécialistes.

L’optimisation d’un site couvre plusieurs aspects :

- le confort pour les utilisateurs : chargement plus rapide, afficher rapidement un premier contenu lisible qui peut être complété plus tard, affichage stable (qui ne bouge pas au fur et à mesure du chargement, ce qui est particulièrement dérangeant),…
- la visibilité du site / son référencement : les moteurs de recherche comme Google tiennent compte du score de rapidité de votre site sur son outil [PageSpeed](https://developers.google.com/speed/pagespeed/insights/?hl=fr) ; optimiser ce score est donc une partie importante votre “SEO” (Search Engine Optimisation)
- protéger et économiser les ressources propres du site : s’il est correctement paramétré, un système de cache va absorber une grande partie du trafic, ce qui va permettre de diminuer l’utilisation de la bande passante du site, et sa consommation CPU, et permettre de supporter sans problème des pics de consommation (que ce soit suite à une campagne, à des buzzs, ou des attaques)
 
Pour commencer, quelques notions importantes, illustrés sur la frise ci-dessous du site [gtmetrics](https://gtmetrix.com/), qui est un outil de mesure semblable à PageSpeed de Google :![](/files/gtmetrix-1.png){: .img-center}

Plusieurs étapes sont distinguées, plus ou moins standard dans leur définition et leur calcul :

- “TTFB” : Time To First Byte ; c’est globalement le temps de réponse de votre site, qui regroupe le temps des éventuelles redirections, le temps de connexion, et le temps que met le serveur à commencer à répondre
- “First Content Paint” : c’est le temps qu’il faut pour que le navigateur puisse commencer à afficher quelque chose qui ressemble à quelque chose ; cela englobe donc le chargement de la page principale, mais également de tous les éléments (CSS, JavaScript, polices,…) que le navigateur aura estimé nécessaire pour l’affichage.
- “Largest Contentful Paint” : c’est le temps nécessaire pour afficher l’ensemble du contenu (notamment les images qui n’auront pas été chargées lors du First Content Paint)
- “Time to Interactive” : c’est le temps au bout duquel l’utilisateur peut interagir (cliquer, scroller,…) correctement avec la page
- “Onload time” : c’est le temps au bout duquel le navigateur a fini de charger la page et déclenche l’évènement ‘onload’
- “Fully Loaded time” : c’est le temps au bout duquel toutes les opérations de chargement (dont le traitement de l’évènement ‘onload’) sont effectivement terminées
 
Sur un site wordpress, les éléments qui influent sur ce temps de traitement sont :

- Le moteur WordPress
- Le thème utilisé, et notamment les différentes ressources css, javascript, images et polices qu’il charge
- Les plugins activés ; que ce soit le temps de traitement php, mais surtout les ressources complémentaires css et javascript à charger
- Et bien évidemment le contenu de la page
 
Tout cela fait que sur un site modeste comme le mien, la page d’accueil nécessite le chargement de plus de 90 fichiers. Parmi ces fichiers, certains sont spécifiques à la page et d’autres seront identiques pour tout le site. C’est également important à prendre en compte, car suivant votre site, optimiser le chargement d’une page et la navigation au travers de tout le site peut s’avérer très différent.

Enfin, les différents composants à prendre en compte dans l’architecture de l’optimisation :

- Le navigateur : il a bien sûr un rôle majeur d’une part sur les règles de chargement et d’affichage qu’il appliquera, et d’autre part avec ses fonctionnalités de cache d’éléments. Ce dernier point est particulièrement important car même s’il ne changera rien à l’affichage de la première page pour un nouvel utilisateur (et donc ne se voit pas dans les indicateurs type PageSpeed ou gtmetrics), il améliorera grandement le confort d’un utilisateur qui consulte plusieurs pages de suite, ou qui revient sur votre site régulièrement.
- Le serveur DNS : c’est lui qui va convertir l’adresse “lisible” de votre site (ex : www.lprp.fr) en adresse IP à contacter ;
- Le CDN (Content Delivery Network) : c’est un terme générique désignant un réseau de fournisseur de contenu qui peut couvrir de nombreuses fonctions ; en pratique, il s’agit de serveurs répartis un peu partout dans le monde pour servir du contenu au plus près du consommateur final et éviter de devoir parcourir des milliers de kilomètres par exemple entre un utilisateur américain et un site hébergé en Europe. Ces serveurs vont stocker du contenu souvent utiliser et se substituer au serveur d’origine lorsqu’un utilisateur va consulter ce contenu. Ces CDN ont donc des fonctions de cache, auxquelles peuvent s’ajouter de très nombreuses fonctions comme du routage intelligent, de la sécurité, de l’adaptation de contenu pour les mobiles, de la traduction automatique, etc.
- Votre serveur web : WordPress est exécuté via un moteur de traitement PHP derrière un serveur web, par exemple Apache ou Nginx. Le paramétrage de cette chaîne est également important, notamment pour le traitement du cache ; il est souvent réalisé de manière automatique par les plugins WordPress d’optimisation si vous utilisez des solutions standard (notamment Apache le plus communément)
- Votre site : en l’occurrence dans cet article, WordPress avec le thème que vous avez choisi et les plugins que vous avez activés, et bien sûr, votre contenu
 
Pour finir cette longue introduction, quelques précautions à prendre en compte :

- Évitez de tester depuis un navigateur sur le serveur qui héberge votre site web. En effet si l’adresse DNS est directement résolue en local par votre serveur, alors vous ne testerez pas la chaine complète avec CDN
- Lorsque vous faites des évolutions, assurez-vous de désactiver les caches pour tester, et de les purger avant de les remettre en fonctionnement, ou d’utiliser un mécanisme de désactivation comme “?swcfpc=1” pour Cloudflare
- Pensez également à tester depuis un téléphone portable, si votre serveur est hébergé chez vous, en dehors de votre réseau local (depuis un téléphone c’est très simple en désactivant le wifi) ; pensez également à tester régulièrement le comportement éventuel depuis un équipement IPv6 (votre mobile récent par exemple). En effet IPv6 rajoute un peu de complexité à tout cet écosystème, et nécessite que vous sachiez particulièrement ce que vous faites avant d’exposer votre serveur en IPv6, notamment d’un point de vue de la sécurité de votre réseau.
- Pour désactiver le cache sur chrome, le plus simple et le plus fiable est d’ouvrir les outils de développements (F12), d’aller sur l’onglet “Network” et de cocher”Disable cache”. D’une manière générale ces outils de développements vont être votre meilleur allié pour comprendre ce qui se passe, notamment cet onglet Network qui affiche l’ensemble des requêtes, les headers et les réponses, et également l’outil “Coverage” accessible dans le menu avec les 3 points verticaux “More tools” / “Coverage”![](/files/chrome_disable_cache.png){: .img-center}
 
Ouf, attaquons !

# <span id="Plugin_Organizer_et_selection_des_plugins_a_charger">Plugin Organizer et sélection des plugins à charger</span>

La plus simple des optimisations est de ne pas chercher à charger des éléments qui ne sont pas utiles. Et notamment les plugins. Compte tenu de la richesse de l’écosystème WordPress on se retrouve assez facilement à installer un grand nombre de plugins. Mais chaque plugin va rajouter son bout de javascript, sa feuille CSS, un peu de temps de traitement PHP, et alourdir au fur et à mesure votre site. La première chose est donc de désinstaller tous les plugins dont vous ne vous servez plus, et de désactiver les plugins que vous n’utilisez que très occasionnellement : il suffira de les réactiver lorsque vous aurez besoin d’eux (par exemple pour moi : Bulk Move, Post Type switcher, …)

Ensuite tous les plugins ne sont pas utiles sur toutes les pages, mais malheureusement WordPress ne prévoit pas de mécanisme automatique pour ne charger que les plugins réellement utiles sur la page demandée. Ça serait d’ailleurs assez complexe à mettre en place sans tout casser. Heureusement il existe un plugin pour vous faciliter un peu la vie : [Plugin Organizer](https://fr.wordpress.org/plugins/plugin-organizer/) (il existe d’autres plugins, notamment [WP Asset Clean Up](https://fr.wordpress.org/plugins/wp-asset-clean-up/) qui permet de sélectionner des fichiers à ne pas charger, dont ceux des plugins ; pour ce que j’avais à faire, j’ai trouver Plugin Organizer plus simple à utiliser et maintenir dans le temps)

Avec ce plugin, vous pouvez :

- Désactiver tous les plugins qui servent à l’administration ou l’édition de votre site ; attention, il s’agit bien seulement de ceux qui n’ont un effet actif que lors de l’édition (ex : Pixabay Images, Search Regex, WP Paint, Enable Media Replace,…), pas ceux que vous ne paramétrez en administration mais qui ont un effet lors de l’affichage des pages (ex : plugin Redirection, Table of content, Elementor, …). Si vous avez un doute, il suffit de tester 🙂 Pour désactiver ces plugins, si vous ne réalisez l’administration ou l’édition seulement via le compte administrateur, alors le plus simple est d’utiliser la liste “Global Plugins” et de désactiver l’option “Selective Admin Plugin Loading”. Ainsi, tous les plugins resteront actifs pour l’administrateur, mais seront désactivés pour tous les autres. Il existe d’autres possibilités, comme la gestion par roles, pour correspondre à votre situation.
- Si des plugins différents sont utilisés suivant le type de page, vous pouvez également définir cette liste via les liste “Post Type Plugins” ; par exemple sur mon site j’utilise des plugins très différents sur les pages dont la page d’accueil (par ex. Elementor, AnWP Post Grid,…) et les posts pour lesquels j’essaie de rester le plus standard possible.
- Enfin, si vous n’utilisez un plugin seulement sur quelques pages, vous pouvez le désactiver globalement et l’ajouter seulement sur les pages concernées. Par exemple j’utilise le plugin Photonic seulement sur ma page Galerie. Pour cela il suffit d’éditer les pages concernées, et sur la page d’édition, de descendre jusqu’aux options de Plugin Organizer pour cliquer sur “Override Post Type settings”
 
![](/files/plugin_organizer_override.png){: .img-center}

N’oubliez bien sûr de tester régulierement en désactivant le cache.

Votre thème peut également proposer dans ses options d’activer ou désactiver certaines fonctionnalités. C’est par exemple le cas de OceanWP que j’utilise. Dans “Theme Panel” / “Scripts &amp; styles” vous avez la possibilité d’activer / désactiver un certain nombre de CSS ou javascript selon votre usage. Ce n’est pas toujours très facile de savoir ce qu’on utilise ou non… mais avec de l’essai / erreur on arrive à en retirer une bonne partie.

Les plugins peuvent être plus ou moins bien optimisés sur ce plan et charger le juste nécessaire ou tout d’un coup. Pour identifier les bons élèves et les mauvais, vous pouvez utiliser la fonction “Coverage” des outils de développement de Chrome.

![](/files/outil_coverage.png){: .img-center}

En rouge tout le code qui a été chargé et non utilisé. Si toute la barre est en rouge, pas d’interrogation à avoir, il ne faut pas charger le fichier (soit en désactivant l’extension, soit si c’est uniquement une partie via un plugin type [WP Asset Clean Up](https://fr.wordpress.org/plugins/wp-asset-clean-up/) ). Pour les autres, vous pouvez au moins vous faire une idée et voir si vous souhaitez conserver le plugin / l’élément ou non. L’idéal serait d’arriver à filtrer le CSS / JS pour ne retenir que le code utile. Malheureusement ce n’est pas si simple, car le code qui pourrait être inutile sur une page pourrait être utile sur une autre… Et charcuter sauvagement les fichiers ne serait pas non plus une solution pérenne dans le temps. Le plus simple reste encore de sélectionner les plugins qui feront le plus attention à charger uniquement seulement les ressources utiles (et les découper suffisamment pour cela), mais le plugin parfait n’existe pas toujours…

Un beau contre exemple d’efficacité est le fichier de polices font-awesome qui fournit des centaines d’icones dans un seul fichier, dont on se servira certainement de seulement une dizaine. Mais c’est bien pratique 🙂

Si vous utilisez une base de données SQLite, il y a des chances que Plugin Organizer ne fonctionne pas directement. En effet, certaines commandes SQL ne sont pas supportées par SQLite. Pour rétablir le fonctionnement, il faudra modifier la structure de votre base de données SQLite (par exemple via DB Browser for SQLite) pour indiquer une valeur par défaut pour le champ permalink.

# <span id="Mise_en_place_de_Cloudflare">Mise en place de Cloudflare</span>

Il existe beaucoup de CDN différents, et vous seul pourrez choisir le ou les bons pour votre situation, dans les critères de choix :

- spécialisation : certains sont optimisés pour servir des images (et seulement des images), ou des vidéos ; d’autres vont traiter tout type de contenu
- couverture géographique adaptée à votre public : si vos utilisateurs sont principalement européens, inutile de prendre un CDN qui aurait ses serveurs principalement aux états-unis
- fonctionnalités : comme évoqué précédemment, les CDN peuvent embarquer des fonctionnalités de routage intelligent, de transformation de format, de traduction automatique, de sécurité, et bien d’autres…
- performance : pas forcément le plus simple à évaluer en simple particulier ; les avis et la réputation restent de bons repères
- prix : bien évidemment, grosses différences !
 
En tant que particulier avec un site autohébergé cherchant un CDN gratuit et non limité aux images, il y a clairement [Cloudflare](https://www.cloudflare.com/fr-fr/) qui s’impose comme choix. Si votre site web est hébergé chez un fournisseur, il est probable que celui-ci prévoit déjà un CDN dans l’offre (c’est le cas chez OVH). Cloudflare est une solution robuste, que vous utilisez certainement sans le savoir au quotidien compte-tenu de sa part de marché impressionnante. D’ailleurs en dehors du CDN vous pouvez également utiliser sur votre ordinateur son service de DNS (1.1.1.1) très performant si celui de votre opérateur ne vous convient pas et que vous ne voulez pas utiliser celui de Google (8.8.8.8). A noter que contrairement à ce que vous pourriez penser avec ce paragraphe, non cet article n’est pas sponsorisé par Cloudflare 🙂

Une solution de cache implique que votre serveur web ne verra plus passer l’intégralité du traffic. Si vous souhaitez utiliser une mesure d’audience, il vous faudra donc une solution qui ne s’appuie pas sur les logs du serveur web pour faire ça. Mais bon, avec la richesse de services gratuits type Google Analytics, qui fait encore ça ? Certes ça nécessite souvent javascript, un pixel ou un cookie (n’oubliez pas le RGPD), mais on est en 2021 🙂

Avant de commencer, il faut savoir qu’il sera nécessaire de basculer l’intégralité de la gestion DNS de votre domaine sur Cloudflare, y compris pour des sous-domaines que vous ne voulez pas proxifier. Ca m’a longtemps fait hésiter car on donne à Cloudflare plus que le controle de son site web, mais ça se comprend aussi d’une part pour être cohérent et optimiser aussi le serveur DNS, et c’est d’autre part complètement nécessaire pour des fonctions comme le routage intelligent qui vont rediriger une même DNS sur des serveurs différents suivant l’endroit d’où on les appelle.

Si vous avez activé DNSSEC sur votre zone DNS, il est impératif de le désactiver au préalable et de laisser suffisamment de temps avant de faire la bascule. J’ai eu la mauvaise idée de ne pas vouloir attendre le délai indiqué par OVH, et j’ai eu des perturbations très importantes dont le service dnsmasq de mon serveur qui a complètement perdu les pédales avec des perturbations bien plus importantes que mon site web. Bref, pour DNSSEC, suivez bien les recommandations et ça se passera bien. Si comme moi vous avez fait l’impatient, rebasculez votre DNS sur votre fournisseur initial, désactivez DNSSEC et laissez passer une semaine avant de recommencer.

La bascule vers Cloudflare se faire très simplement:

- Une fois votre compte gratuit créé sur le site, ajouter le domaine que vous voulez gérer (pour moi : lprp.fr)
- Cloudflare va inspecter votre zone DNS et vous proposer de reprendre automatiquement la liste de toutes les entrées. Pour chaque entrée, vous avez la possibilité entre “DNS uniquement” ou “Proxied”, pour choisir d’utiliser ou non le CDN sur ces entrées (certaines sont limitées au DNS, comme les adresses locales). Vous aurez possibilité ensuite de modifier ces paramètres. A noter que si vous avez plusieurs fois la même adresse IP derrière des entrées proxifiées et d’autres non, Cloudflare remonte une alerte. Si vous utilisez Cloudflare à des fins de sécurité il est nécessaire d’en tenir compte, car sinon votre adresse IP sera exposée via une autre DNS et un attaquant pourrait ainsi identifier directement l’adresse IP à attaquer en contournant Cloudflare. Si la sécurité n’est pas votre objectif premier, vous pouvez ignorer cette alerte, cela fonctionnera parfaitement quand même.
- Cloudflare va ensuite vous indiquer les adresses des serveurs DNS à indiquer pour votre zone DNS en remplacement des précédents. Il vous faudra ensuite vous connecter sur le registrar de votre nom de domaine (OVH pour moi), et faire les modifications dans la console d’administration. Une fois la modification répercutée, Cloudflare enverra un mail pour prévenir qu’il est désormais actif.
 
A cette étape, il y a déjà un peu de cache qui doit s’effectuer, mais sans doute pas beaucoup. En effet par défaut comme WordPress est en PHP, le cache-control est fixé à 0 et aucun contenu servi directement par wordpress va être caché. Par ailleurs en standard Cloudflare ne cache pas les contenus qu’il détecte comme contenu dynamique. Bref, sans réglages au mieux vous aurez 5-10% de contenu caché, ce qui ne vaut vraiment pas le coup de s’embeter.

Cloudflare propose un plugin pour WordPress, qui n’a comme seule fonction semble-t-il que de pousser quelques pré-réglages sans grande utilité. Mais il y a un plugin bien plus utile [WP Cloudflare Super Cache](https://wordpress.org/plugins/wp-cloudflare-page-cache/). Une fois installé il faut indiquer la clé API de votre compte Cloudflare disponible via la page d’accueil, pour permettre au plugin de controler Cloudflare pour votre compte. Parmi les actions de ce plugin :

- Il va activer une règle Cloudflare pour cacher tout le contenu de votre site, y compris les scripts dynamiques (vous pouvez bien sûr aussi créer cette règle à la main dans le menu Page Rules de Cloudflare)
- Il va modifier votre .htaccess pour ajouter des indications de controle de cache pertinente :
 
 ```
# BEGIN WP Cloudflare Super Page Cache
# Les directives (lignes) entre Â«Â BEGIN WP Cloudflare Super Page CacheÂ Â» et Â«Â END WP Cloudflare Super Page CacheÂ Â» sont gÃ©nÃ©rÃ©es
# dynamiquement, et doivent Ãªtre modifiÃ©es uniquement via les filtres WordPress.
# Toute modification des directives situÃ©es entre ces marqueurs sera surchargÃ©e.
[...]
ExpiresActive on
ExpiresByType application/json              "access plus 0 seconds"
ExpiresByType application/xml               "access plus 0 seconds"
ExpiresByType application/rss+xml           "access plus 1 hour"
[...]
ExpiresByType image/jpeg                    "access plus 6 months"
ExpiresByType image/webp                    "access plus 6 months"
[...]
ExpiresByType text/css                      "access plus 1 year"
ExpiresByType application/javascript        "access plus 1 year"
[...]
# END WP Cloudflare Super Page Cache
```

Renseigner une bonne valeur pour le cache-control, en outre d’être utile pour la gestion du cache par le navigateur, est absolument essentiel pour Cloudflare. En effet conservation dans le cache Cloudflare suit les règles du cache-control, et si celui-ci est toujours à 0 alors Cloudflare déterminera que ce qu’il a en cache est expiré et sollicitera le serveur.

Le plugin permet également de gérer correctement la mise à jour du cache de Cloudflare lorsque vous mettez à jour votre site, et également de précharger votre site chez Cloudflare : cela permettra que Cloudflare dispose déjà d’une copie du contenu en cache avant qu’un utilisateur ne le sollicite (sans préchargement, c’est le premier utilisateur qui provoquera la mise en cache du contenu et seulement le second qui bénéficiera du gain de vitesse du cache). Le plugin ajoute aussi le suffixe “?swcfpc=1” lorsque vous consultez le site en tant qu’administrateur, pour que l’administrateur soit sûr de voir le contenu à jour, non caché par Cloudflare. Attention à ne pas copier ce suffixe dans les liens de vos articles.

L’activation de Cloudflare peut avoir des effets de bord sur le fonctionnement de votre site. Par exemple j’utilise [Langage Mix](/2020/12/wordpress-plugin-language-mix) pour mixer les contenus français et anglais. Parmi les fonctionnalités de ce plugin, il y a la capacité à envoyer un contenu qui dépend des langues acceptées par le navigateur de l’utilisateur. Mais dans sa version gratuite, Cloudflare ne stocke en cache qu’une seule version du contenu, ce qui est incompatible avec cette fonctionnalité du plugin Langage Mix. L’optimisation est affaire de compromis, vous avez donc le choix entre souscrire au plan Entreprise de Cloudflare qui permet de distinguer la mise en cache suivant différents paramètres de la requète (dont le header Accept-Language), soit de vous passer de cette fonctionnalité. Ca tombe bien, j’avais rendu paramétrable dans Language Mix la redirection automatique qui permet de retrouver un comportement compatible CDN.

Pour vérifier avec votre navigateur la mise en cache de Cloudflare, il suffit de regarder depuis l’onglet Network des outils de développement Chrome le header “cf-cache-status” et consulter la page suivante qui explique la [signification des différentes valeurs](https://getfishtank.ca/blog/cloudflare-cdn-cf-cache-status-headers-explained).

Un autre avantage de Cloudflare est la possibilité de servir votre site même si votre serveur est tombé avec l’option “Always On”. N’oubliez d’ailleurs pas d’ajouter le suffixe “?swcfpc=1” si vous avez des robots pour vérifier l’état de votre serveur (pour ma part j’utilise le service [uptimerobot.com](https://uptimerobot.com/) qui convient parfaitement à mes besoins dans sa version gratuite.

# <span id="Autres_optimisations">Autres optimisations</span>

Les deux sections précédentes jouent sur deux tableaux : limiter le contenu nécessaire et cacher ce contenu dans un CDN pour accélerer son acheminement vers l’utilisateur. Parmi les recommandations de PageRank cela concerne seulement quelques recommandations (réduite le contenu inutile et améliorer le temps de réponse du serveur).

Il y a bien sûr beaucoup d’autres optimisations à faire, et également beaucoup de plugins qui propose les recettes miracles pour améliorer le PageRank. Il faut cependant bien comprendre chacune des méthodes proposée pour paramétrer ces plugins efficacement et qu’ils ne soient pas au contraire plus néfastes qu’autre chose. Dans les différentes techniques :

- La **minification** : c’est une technique qui vise à réécrire les fichiers css et javascript pour qu’ils prennent moins de place, par exemple en supprimant tous les espaces inutiles, les commentaires, en abrégeant les noms de variables, etc. Il n’y a pas de risque lié à cette technique, c’est toujours une bonne idée de l’activer, sauf en développement où cela rend plus difficile le débogage. Si vous utilisez Cloudflare, la minification est incluse dans les fonctions gratuites, pas besoin de prévoir un autre plugin pour cela.
- Le **regroupement** / merge des fichiers css et javascript : cette technique regroupe tous les css / javascript dans un seul fichier css / javascript pour que le navigateur n’ait qu’un seul gros fichier à charger plutôt que plein de petits. Plusieurs mises en garde : 
    - C’est efficace pour HTTP/1.1, mais obsolète avec HTTP/2 et suivants. Les outils PageSpeed et gtmetrics considèrent pour l’instant seulement HTTP/1.1 pour leur score (peut être plus pour longtemps), donc ça reste au moins utile pour le score.
    - Lorsque le paquet de fichier est toujours le même quelque soit la page du site ça peut être une bonne idée d’activer cette option. Lorsque cela dépend de la page (c’est le cas de l’usage avec l’usage de Plugin Organizer décrit ci-dessus), il est nécessaire a minima que cette opération soit compatible CDN, c’est à dire que le nom du fichier dépende du contenu. Sinon le CDN va garder une version qui n’est pas forcément la bonne pour la page.
    - Malgré tout, lorsqu’une grande partie est commune à toutes les pages c’est un peu dommage, car le navigateur devra recharger intégralement tout le fichier à chaque page alors qu’il en a certainement une grande partie en cache (mais qu’il ne peut pas identifier puisque noyé dans le fichier combiné).
    - En combinant tous les fichiers dans un seul js / css il n’est plus possible d’en charger une partie de manière asynchrone (voir ci-dessous) ; il faut donc prévoir de combiner les deux harmonieusement.
    - Bref, à partir du moment où on a l’usage de Plugin Organizer je recommande plutôt de ne pas activer cette option.
- L’**intégration dans la page** (inline) vise à pousser un cran plus loin le regroupement, en intégrant le résultat directement dans la page html. Le résultat est d’avoir une page html monolithique qui comporte tout le code html, css et javascript nécessaire. On retrouve en gros les mêmes mises en garde qu’avec le regroupement.
- Le **préchargement** de contenu (preload) : cette technique consiste à indiquer au navigateur via une balise &lt;link rel=”preload” qu’il aura besoin dans le future d’une ressource javascript / css / police / … et qu’il serait bien avisé de se préoccuper sans attendre de télécharger le contenu. Ainsi, lorsque le navigateur aura effectivement besoin d’utiliser ce contenu, il l’aura déjà chargé, ou déjà commencé à le charger.
- Le **chargement asynchrone** (async) ou **différé** (defer) : permet d’indiquer au navigateur de ne pas attendre la fin de chargement de ces éléments pour afficher du contenu. Le mode async permet l’exécution de script dès que le script est chargé, alors que dans le cas de defer, le script sera exécuté seulement une fois que la page aura été chargée. Pour que l’expérience utilisateur soit agréable il faut en gros rendre async / defer tout ce qui n’est pas vital pour la mise en page, sinon soit cela va complètement casser la mise en page, soit provoquer des sauts de mise en page très perturbants pour l’utilisateur (vous verrez le terme de “critical CSS”).
- Le principe du chargement différé peut être étendu à d’autres situations, et notamment tout ce qui se passe en dessous de la ligne d’affichage (ie tout ce qui se passe dans le bas de la page pour lequel il faut scroller pour voir le contenu). On peut alors différer le chargement, soit des images, soit même de tout le contenu (et c’est indirectement ce que font les mécanismes de infinite scroll)
- Il existe également des mécanismes pour précharger une page lorsque votre souris va s’approcher d’un lien, avant que vous ne cliquiez dessus. Ainsi, si vous cliquez effectivement dessus vous aurez gagné quelques dixièmes de seconde.
- Compresser les **images en WebP** : en utilisant un mode de compression plus performant que jpeg et png, on peut gagner plus de 30% sur la taille des images. J’utilise le plugin [WebP Express](https://fr.wordpress.org/plugins/webp-express/) pour la compression et l’adaptation des pages. Encore une fois c’est une affaire de compromis, soit vous remplacez toutes vos images par du WebP, et tant pis pour les navigateurs qui ne le supporte pas, soit vous server du WebP ou du jpg/png suivant la capacité du navigateur, mais ce n’est pas CDN-friendly et ça ne marche pas avec le plan gratuit de Cloudflare, soit vous activez le mode CDN-friendly mais qui ne va pas toucher aux images CSS et autres (ce pour quoi j’ai opté), ou vous pouvez opter pour un CDN image dédié, ou encore souscrire au mode payant de Cloudflare qui gère ça de manière transparente (option Polish)
- et encore bien d’autres …
 
Je n’ai pas essayé tous les plugins ni toutes les combinaisons, et mon choix ne correspond qu’à une situation particulière qui est celle de mon site. J’ai opté pour [Pagespeed Ninja](https://wordpress.org/plugins/psn-pagespeed-ninja/) qui s’avère utile même sans activer les fonctions de minifications puisque traitées par Cloudflare dans mon cas.

Il se trouve que le thème que j’utilise, OceanWP, ne précharge pas correctement toutes les polices utilisées. En attendant qu’ils corrigent j’ai ajouté le code suivant dans le fichier functions.php de mon thème fils pour pallier ce problème:

 ```php
function preload_oceanwpfonts() {
    ?>
<link rel="preload" href="/wp-content/themes/oceanwp/assets/fonts/simple-line-icons/Simple-Line-Icons.woff2" as="font" crossOrigin="anonymous">
<link rel="preload" href="/wp-content/plugins/elementor/assets/lib/font-awesome/webfonts/fa-brands-400.woff2" as="font" crossOrigin="anonymous">
<link rel="preload" href="/wp-content/plugins/elementor/assets/lib/font-awesome/webfonts/fa-solid-900.woff2" as="font" crossOrigin="anonymous">
   <?php
}
add_action('wp_head', 'preload_oceanwpfonts');
```

Si vous visez un site parfait pour le mobile, vous devriez aussi jeter un oeil du coté de [Accelerated Mobile Pages (AMP)](https://fr.wikipedia.org/wiki/Accelerated_Mobile_Pages). Cependant outre les polémiques sur le sujet, c’est aujourd’hui très compliqué de trouver un ensemble thème + plugins qui corresponde à ce que vous cherchez et soit 100% compatible AMP : il faut donc prévoir de concevoir dès le début un site compatible AMP ; les chances d’arriver à convertir un site non AMP en AMP sont quasi nulles. Egalement comme il faut servir du contenu différent, le plan gratuit de Cloudflare ne suffira pas.

Enfin si vous n’avez pas opté pour un CDN (Cloudflare ou un autre) pour cacher vos pages, vous devriez regarder du coté des plugins de gestion de cache. Il en existe beaucoup. [WP Super Cache](https://fr.wordpress.org/plugins/wp-super-cache/) m’a semblé pas mal avant que je bascule en CDN. (Et si vous développez des plugins, vous devriez aussi lire [la documentation WP\_Object\_Cache](https://developer.wordpress.org/reference/classes/wp_object_cache/#Persistent_Caching))

# <span id="Conclusion">Conclusion</span>

Avec ces différentes optimisations j’ai pu d’une part mettre en place le CDN Cloudflare pour décharger mon serveur et préserver ma bande passante, mais également continuer à faire fonctionne mon site web même si mon serveur est par terre, mais également un paquet d’optimisation pour augmenter mon PageSpeed de 20 / 40 à 61 pour le mobile et 82 pour le desktop, ce qui est déjà nettement mieux et pas trop mal pour un site personnel !

![](/files/pagespeed_mobile.png) ![](/files/pagespeed_desktop.png)
{: .center}
