---
title: Sécuriser votre infrastructure maison avec Proxmox, OPNsense, Traefik, Home
  Assistant et PKI XCA
lang: fr
tags:
- Proxmox
- Docker
- Securite
- LAN
- PKI
categories:
- Informatique
toc: 2
ia: Perplexity, Copilot
image: files/2026/auth_post_vignette.jpg
date: '2026-06-19 10:30:00'
---

Cette stack regroupe le routage, le firewall, la gestion des certificats, le reverse proxy et l'authentification autour d'une logique simple : un point d'entrée clair, des services bien isolés, et une séparation nette entre certificats internes et publics.

# Présentation de la stack

La stack s'articule autour de plusieurs briques complémentaires :

![]({{ 'files/2026/Server-SecureStack.svg' | relative_url }}){: .img-center .mw80}


- **Box opérateur** : accès Internet avec NAT IPv4 et firewall IPv6
- **Proxmox Firewall** : filtre le trafic au niveau des VM et de l'hyperviseur.
- **Routeur OPNsense** : gère le routage, le proxy HTTPS externe avec LetsEncrypt, et une partie des certificats locaux.
- **XCA** : sert à créer et administrer l'autorité de certification interne.
- **Traefik** : reverse proxy pour les services Docker avec SSL.
- **TinyAuth + PocketId** : brique d'authentification et d'OpenID Connect.
- **Nginx Proxy Manager** : reverse proxy SSL pour Home Assistant.

Il serait possible d'utiliser des certificats publics LetsEncrypt pour tous, ce qui simplifierait le setup, mais cela impose d'exposer les services internes à l'extérieur (en HTTP ou en DNS).  Une autorité de certification interne (AC) permet plus de souplesse, et également de générer des certificats pour des systèmes qui n'ont pas le support LetsEncrypt, avec l'inconvénient de devoir installer le certificat sur tous les appareils et dockers ayant besoin de valider une connexion https avec des certificats issus de cette AC.

# Firewall
## Box opérateur

Les box opérateurs proposent généralement deux fonctions de protection à utiliser :
- NAT (Network Address Translation, typiquement pour IPv4) : est une première forme de protection, car les ports non exposés sont de facto filtrés ; n'exposez que les ports utiles et sécurisés (typiquement https/443), sur une association fixe (les box modernes permettent souvent d'associer à l'adresse MAC de la cible, pour que ce soit indépendant de l'adresse IP donnée par le DHCP ; si ce n'est pas le cas, configurez votre DHCP ou votre cible pour avoir une IP fixe)
- Firewall (typiquement pour IPv6) : assurez-vous que le firewall est bien actif (souvent par défaut maintenant), sinon vos appareils sont directement  tous exposés sur internet en IPv6 ; les accès IPv6 sont maintenant plus courants, vous pouvez également ouvrir les ports que vous avez ouverts en NAT sur les IPv6 concernées

## Proxmox Firewall

Le firewall Proxmox sert de premières barrières sur l'infrastructure virtuelle. Il permet de filtrer les accès aux nœuds Proxmox eux-mêmes, mais aussi aux VM comme le routeur OPNsense, le serveur Docker ou Home Assistant.

Il est nécessaire d'activer l'option Firewall à tous les niveaux (Datacenter, nœud et VM) pour que le firewall soit actif. Il est ensuite possible de définir (ou non) des règles de filtrage à chaque niveau. Vous pouvez également définir des politiques de filtrage par défaut, par exemple pour interdire tout trafic par défaut, ou au contraire laisser ouvert. Sur le nœud et le datacenter, Proxmox intègre automatiquement les règles pour ouvrir les ports utiles à la gestion de Proxmox.

Proxmox offre plusieurs options utiles pour définir efficacement vos règles :
- les **IPSets** permettent de définir des groupes d'adresses IP ou réseaux qui seront utilisables dans les règles par la suite ; j'ai défini par exemple un IPset `LAN` et `LAN-broadcast`avec les réseaux IPv4 et IPv6 correspondant, ce qui facilite l'écriture des règles, et leur maintenance si par exemple le préfixe IPv6 change
- les **Security Groups** permettent de définir des groupes de règles, qu'on pourra ensuite ajouter dans chacun des firewall ; j'ai par exemple défini des groupes générique `lan-generic`et `lan-mdns` avec des règles par défaut, que je peux activer sur chaque VM si j'ai besoin d'un filtrage LAN classique, d'ajouter le support UPNP / discovery, etc. La prise en compte des modifications nécessite parfois de décocher / cocher le security group sur la VM.

Enfin, sur une VM donnée, pour identifier les ports réellement écoutés et potentiellement candidats à être ouverts, une commande utile est  `ss -tulnrp` qui permet de lister tous les ports TCP ou UDP exposés, et par quel processus (Si la commande n'est pas disponible, sous debian`apt install iproute2`). Tous n'ont bien sûr pas vocation à être exposés, mais cela permet d'étudier chaque port et d'éviter d'en oublier.

## Routeur OPNsense

En plus du premier filtrage de la box opérateur, j'ai choisi d'ajouter une seconde couche de sécurité via un routeur OPNsense. C'est notamment utile pour ajouter une couche de sécurité et utiliser des fonctions de filtrage IP par des blacklists communautaires, des règles de filtrage plus avancées, etc.  Et bien sûr, il intègre des fonctions de routeur avancé que nous ne traiterons pas ici.

Le principe est de déclarer deux interfaces réseaux sur la VM OPNsense :
- une interface WAN : c'est sur cette interface qu'on fera pointer nos règles NAT ou notre exposition externe, et sur cette interface que nous définirons nos règles firewall
- une interface LAN : c'est via cette interface qu'on proxifiera les services exposés


# Proxy HTTPS
## Gestion des certificats avec XCA et OPNsense

[XCA](https://www.hohnstaedt.de/xca/) sert à gérer l'autorité de certification interne. C'est la brique qui permet de créer votre autorité de certification racine (AC), d'émettre les certificats internes et d'organiser leur cycle de vie. C'est une application desktop disponible pour Windows, Mac et Linux (selon la distribution, ou en compilation) 

J'ai opté pour la logique suivante :
- une AC root définies dans XCA ; qui permet de gérer certains certificats en direct dans XCA
- une AC secondaire gérée par OPNsense ; il faut créer cette AC dans XCA, puis l'importer dans OPNsense ; OPNsense pourra ensuite l'utiliser et signer de nouveaux certificats avec cette AC secondaire, qui sera automatiquement reconnu dans la mesure où on a installé l'autorité racine
- un certificat wildcard pour le server docker exposé par Traefik (ce n'est pas une bonne pratique, mais suffisant pour mon cas)

Un point d'attention dans OPNsense dans la gestion des certificats, il faut déclarer uniquement les noms de domaines (en CN ou en SAN) que doivent gérer ces certificats, et ne pas inclure des noms de domaine destinés à Let's Encrypt, car dès que Caddy trouve un certificat qui correspond, il prendra celui là et n'en demandera pas à Letsencrypt, même si les options "Auto HTTPS" sont activées.

Les champs à bien remplir pour des certificats correctement retenus :
- **CN** (Common Name) : l'adresse DNS principale sécurisée (l'adresse seule, sans le préfixe https)
- **Extension SAN** (Subject Alternative Names), en cochant critical : toutes les adresses DNS et/ou IP qui peuvent être utilisées avec ce certificat (toujours les adresses seules, mais vous pouvez utiliser un wildcard `*.madns.com`)
- **Key Usage**, en cochant critical : Digital Signature, Key Encipherment
- **Extended Key Usage** : TLS Web Server Authentication, TLS Web Client Authentication
- et n'oubliez pas bien sûr de créer une clé privée, sélectionner la signature par la bonne AC et ajuster la durée de validité selon votre convenance

## Caddy pour OPNsense

Comme proxy HTTPS, j'utilise caddy, qui est très bien intégré dans OPNsense, avec une interface complète et facile à utiliser, et la possibilité de demander automatiquement des certificats ACME/LetsEncrypt, ou des certificats locaux via la gestion des certificats intégrée à OPNsense, et très pratique également.

Si vous souhaitez rediriger vers des DNS pointant vers des IP locales définies avec un DNS qui ne serait pas géré par OPNsense (comme OVH, Cloudflare, etc. si vous avez un domaine personnalisé), il vous faudra les déclarer également dans OPNsense, car par défaut pour des raisons de sécurité, OPNsense interdit des adresses DNS qui se résolvent sur une IP locale. Il faut alors les déclarer dans **Unbound DNS / Contournements**.

## Traefik pour les containers docker

Il serait possible d'utiliser seulement Caddy comme proxy https, en exposant sur le réseau interne tous les ports http des containers docker. Le problème est que cela ne permettrait pas de les protéger des autres périphériques connectés sur votre réseau local (y compris les IoT type prises connectées ou autres qui ouvrent un tunnel avec leur cloud et peuvent présenter des risques de sécurité), ni de les protéger par l'authentification qui sera ajoutée ensuite.

L'usage de traefik permet ainsi d'avoir un autre étage de proxy SSL au niveau du server docker, et de n'ouvrir au niveau du firewall que le port https. Si on cumule avec caddy pour l'exposition externe on aura donc :
- pour les services externes : Internet --> Box (NAT / Firewall) --> Caddy/OPNsense (Firewall + SSL avec Letsencrypt) --> VM Docker (Firewall Proxmox) --> Traefik (SSL avec AC interne et authentification) --> service docker  
- pour les services internes, on aura seulement : LAN --> VM Docker (Firewall Proxmox) --> Traefik (SSL avec AC interne et authentification) --> service docker  

L'utilisation de Traefik est particulièrement pratique avec `docker compose`.  Pour sécuriser, on va déclarer un réseau `proxy` qui sera partagé entre traefik et les différents containers. Si on veut sécuriser encore plus, et éviter qu'un service docker compromis puisse accéder à d'autres services docker sans sécurisation, on peut créer un réseau dédié pour chaque service docker `proxy_xxx`. 

Exemple de docker compose pour Traefik :
```yaml
services:
  traefik:
    image: traefik
    restart: always
    command:
      - "--providers.docker=true"
      - "--providers.docker.watch=true"
      - "--providers.docker.exposedByDefault=false"
      - "--providers.docker.network=proxy"
      - "--providers.file.filename=/config/dynamic.yml"
      - "--entrypoints.websecure.address=:443"
      - "--entrypoints.web.address=:80"
      - "--entrypoints.web.http.redirections.entrypoint.to=websecure"
      - "--entrypoints.web.http.redirections.entrypoint.scheme=https"
      - "--api.dashboard=true" # Pour l'interface graphique
    ports:
      - "80:80"
      - "443:443"
    networks: ["proxy"]
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - /docker/auth/traefik-config:/config
      - /docker/auth/traefik-certs:/certs

networks:
  proxy:
    external: true
```
Notez `"--providers.docker.network=proxy"` qui permet d'indiquer à traefik quelle IP sélectionner pour les containers qui ont plusieurs networks.


Fichier `dynamic.yml:
```yaml
tls:
  stores:
    default:
      defaultCertificate:
        certFile: /certs/wildcard.crt
        keyFile: /certs/wildcard.key

  options:
    default:
      minVersion: VersionTLS12

serversTransport:
  insecureSkipVerify: false   # Optionel, utile pour router vers du HTTPS autosigné
```

`wildcard.crt` et `wildcard.key`sont le certificat wildcard et la clé privée générée par XCA pour ce server, et exporté au format PEM.


Sur chaque docker, on pourra ajouter :
```yaml
# dans le service
    networks:
      - proxy
    labels:
      - traefik.enable=true
      - traefik.http.routers.monservice.rule=Host(`monservice.customdns`)
      - traefik.http.routers.monservice.tls=true
      # Si le port n'est pas directement déductible par Traefik
      #- traefik.http.services.monservice.loadbalancer.server.port=80
      
networks:
  proxy:
    external: true
```
Si plusieurs services doivent partager un réseau commun sans pour autant le partager avec tout le monde (comme par exemple entre un backend et sa base de données), vous pouvez ajouter un réseau `internal`, le déclarer sur chacun des containers concernés.

Et comme l'exposition est maintenant assurée par Traefik, on peut retirer ou commenter l'exposition des ports en commentait les options `ports:`. Il ne sera plus possible d'accéder au service par `http:///<IP>:<PORT>`mais seulement via `https://monservice.customdns`

Traefik offre également une interface graphique permettant la lecture des configurations actives (lecture seule, la configuration ne se fait que via les labels ou les fichier yaml) ; vous pouvez également l'exposer et la sécuriser via Traefik en ajoutant
```yaml
    labels:
      - traefik.enable=true
      - traefik.http.routers.traefik.rule=Host(`traefik.customdns`)
      - traefik.http.routers.traefik.tls=true
      - traefik.http.routers.traefik.service=api@internal
      - traefik.http.routers.traefik.middlewares=tinyauth  # Pour la sécurisation tinyauth qu'on verra par la suite
```

Il est facile de faire une erreur dans la configuration de Traefik et que le service ne fonctionne pas ; dans les erreurs courantes : 
- **404** :
  - vérifier que les noms de router et de service sont bien distincts dans le YAML.
  - vérifier que le conteneur a bien terminé son démarrage (éventuellement forcer sa recréation)
  - vérifier que le port exposé est correct et non déjà utilisé
  - vérifier que Traefik voit bien les configurations (éventuellement forcer la relecture en redémarrant Traefik)
- **Gateway Timeout** :
  - le container peut avoir un problème, vérifier qu'il est bien `healthy`dans docker et que tout va bien dans les logs du container
  - si le container a plusieurs réseaux, Traefik peut ne pas prendre la bonne IP ; il faut indiquer a Trafik quel réseau utiliser

## Nginx Proxy Manager pour Home Assistant

Dans Home Assistant il existe deux addons pour sécuriser en SSL :
- `NGINX Home Assistant SSL proxy`est le plus simple, il est préconfiguré pour Home Assistant, vous pouvez fournir un certificat ou laisser un autosigné généré automatiquement
- `Nginx Proxy Manager` est un reverse proxy simple et complet administrable avec une interface graphique efficace, vous pouvez le paramétrer pour Home Assistant (activer le support WebSockets), mais également d'autres services 

Dans tous les cas, suivez bien la documentation pour ajouter la configuration `http:`pour l'ajout du proxy de confiance.

# Authentification
Deux mécanismes d'authentification sont possibles :
- via un Identity Prodiver OIDC (OpenID Connect / OAuth2) : l'application supporte nativement l'authentification OIDC et on va créer pour chaque un client_id / client_secret et déclarer le server dans l'application ; on va utiliser **PocketID** pour cela
- via authentification dans Traefik : pour les applications sans authentification, on va demande à Traefik de s'en occuper, et de vérifier auprès d'un service que l'utilisateur a le droit d'utiliser le service ; on va utiliser **TinyAuth** pour ça

## Serveur OIDC PocketID
[PocketID](https://pocket-id.org/) est un serveur OIDC hyper léger, et pourtant avec l'ensemble des fonctions utiles pour un homelab et une interface graphique très simple à utiliser pour le paramétrage. La spécificité de PocketID est qu'il gère seulement et exclusivement les passkeys. Donc notamment, pas de support de login / mot de passe.  Les passkeys sont cependant maintenant bien gérées par les navigateurs, et assez pratique à utiliser, mais définissez en autant que possible pour ne pas être bloqué (par exemple Windows Hello sur PC, Google sur android et chrome,...)

Il existe de nombreuses alternatives de serveur OIDC comme [Keycloak](https://www.keycloak.org), [Authentik](https://goauthentik.io), [Zitadel](https://zitadel.com/), [LemonLDAP::NG](https://lemonldap-ng.org/) et beaucoup d'autres ; généralement nécessitant plus de ressources, et avec des interfaces plus ou moins abouties ou plus ou moins simples.

La configuration est également ultra-simple en docker :
```yaml
  pocketid:
    image: ghcr.io/pocket-id/pocket-id:latest
    restart: always
    networks: ["proxy"]
    environment:
      - APP_URL=https://id.customdns
      - ENCRYPTION_KEY=supersecret
      - TRUST_PROXY=True
      - PORT=3000
      - POCKETID_CA_CERT=/certs/internal_ca.pem
    volumes:
      - /docker/pocketid-data:/app/data
      - /docker/crt:/certs
    labels:
      - traefik.enable=true
      - traefik.http.routers.pocketid.rule=Host(`id.customdns`)
      - traefik.http.routers.pocketid.tls=true
      - traefik.http.services.pocketid.loadbalancer.server.port=3000
      - traefik.http.services.pocketid.loadbalancer.server.scheme=http
```

On en profite aussi pour l'exposer en https via Traefik. A la première connexion, on va pouvoir créer une passkey admin, en créer d'autre et configurer d'autres utilisateurs.

L'interface d'administration est très complète:
![]({{ 'files/2026/auth_pocketid_ui.png' | relative_url }}){: .img-center .mw80}

 et permet de :
- paramétrer de nouvelles applications OIDC (client_id / client_secret / redirect_uri / ...    très simple et pourtant tout ce qui sert pour un homelab)
- paramétrer de nouveaux utilisateurs
- paramétrer des groupes, afin de restreindre des applications à des groupes utilisateurs

L'interface de connexion quant à elle est hyper simple : 

![]({{ 'files/2026/auth_pocketid_login.png' | relative_url }}){: .img-center .mw60}

Le bouton permet ensuite la sélection de la passkey à utiliser, et la suite est gérée par le navigateur / l'OS.



## Proxy d'authentification TinyAuth

PocketId n'intègre pas nativement d'intégration pour s'authentifier dans Traefik, et Traefik ne supporte pas nativement d'authentification OIDC (il existe un plugin tiers). Pour faire le pont entre les deux, on va utiliser un serveur d'authentification très léger [TinyAuth](https://tinyauth.app/). TinyAuth sait également faire server OIDC (et remplacer à ce titre PocketId), cependant :
- il ne supporte pas les passkeys
- il ne dispose pas d'une interface graphique d'administration, la configuration doit passer par des fichiers de configuration ou labels docker, ce qui n'est pas le plus pratique au quotidien pour ajouter une application ou un utilisateur

Pour le configurer sous docker
```yaml
  tinyauth:
    image: ghcr.io/tinyauthapp/tinyauth:latest
    restart: always
    networks: ["proxy"]
    # entrypoint:  'sh -c "set -a; source /data/oidc_clients.env; set +a; exec /tinyauth/tinyauth" '
    environment:
      - TINYAUTH_APPURL=https://auth.customdns
      #- TINYAUTH_AUTH_USERSFILE=/data/users
      - TINYAUTH_ANALYTICS_ENABLED=false
      - TINYAUTH_AUTH_SESSIONEXPIRY=86400
      - TINYAUTH_UI_TITLE=RP Auth
      
      # --- OIDC PocketID ---
      - TINYAUTH_OAUTH_PROVIDERS_POCKETID_CLIENTID=<client_id>
      - TINYAUTH_OAUTH_PROVIDERS_POCKETID_CLIENTSECRET=<client_secret>
      - TINYAUTH_OAUTH_PROVIDERS_POCKETID_AUTHURL=https://id.customdns/authorize
      - TINYAUTH_OAUTH_PROVIDERS_POCKETID_TOKENURL=http://pocketid:3000/api/oidc/token
      - TINYAUTH_OAUTH_PROVIDERS_POCKETID_USERINFOURL=http://pocketid:3000/api/oidc/userinfo
      - TINYAUTH_OAUTH_PROVIDERS_POCKETID_REDIRECTURL=https://auth.customdns/api/oauth/callback/pocketid
      - TINYAUTH_OAUTH_PROVIDERS_POCKETID_SCOPES=openid email profile
      - TINYAUTH_OAUTH_PROVIDERS_POCKETID_NAME=PocketID
      - TINYAUTH_OAUTH_PROVIDERS_POCKETID_INSECURE=true   # CA privé

      # Redirection automatique vers PocketID (passkeys)
      - TINYAUTH_OAUTH_AUTOREDIRECT=pocketid
    volumes:
      - /docker/tinyauth-data:/data
    labels:
      - traefik.enable=true
      - traefik.http.routers.tinyauth.rule=Host(`auth.customdns`)
      - traefik.http.routers.tinyauth.tls=true
      - traefik.http.services.tinyauth.loadbalancer.server.port=3000

      # Middleware ForwardAuth
      - traefik.http.middlewares.tinyauth.forwardauth.address=http://tinyauth:3000/api/auth/traefik
      - traefik.http.middlewares.tinyauth.forwardauth.trustForwardHeader=true
      - traefik.http.middlewares.tinyauth.forwardauth.authResponseHeaders=remote-user,remote-email

```

Quelques précisions :
- TinyAuth permet aussi une gestion de login / mot de passe ; vous pouvez ajouter un fichier `users` (voir ligne commentée + fichier avec des lignes `<username>:<bcrypt-hash>` et pour créer le hash `mkpasswd --method=bcrypt --rounds=12` ( `mkpasswd` dans `apt install whois` )
- Pour faciliter la configuration et éviter de tout mettre dans le docker compose, une option est de déplacer les variables dans un fichier d'environnement et de décommenter la ligne entrypoint ; il faut restart le container à chaque modification.
- Notez les subtilités dans la configuration OIDC PocketID (qui sera également à suivre avec les autres clients OIDC de PocketId) : 
  - pour les URL qui passent par le navigateur de l'utilisateur (auth, redirect,...), il faut utiliser l'adresse externe `https://id.customdns`
  - pour les URL directes entre TinyAuth et PocketId, on utilise directement l'adresse interne docker via le nom du service et le port exposé en http `http://pocketid:3000` 


L'option `TINYAUTH_OAUTH_AUTOREDIRECT=pocketid` permet de se connecter automatiquement via PocketId, cependant en cas d'échec (ou sans cette option), l'écran de login ci-dessous est proposé et permet le choix entre PocketId ou le mot de passe si vous l'avez activé : 

![]({{ 'files/2026/auth_tinyauth_login.png' | relative_url }}){: .img-center .mw60}



## Quelques points de configuration spécifiques

Certains clients OIDC peuvent avoir des contraintes particulières, notamment :
- de devoir paramétrer les utilisateurs via OIDC (notamment le mapping pour déterminer quel champ OIDC utiliser pour le nom d'utilisateur), ou une création automatique des utilisateurs par OIDC
- d'exiger des emails validés ; il est préférable de systématiquement renseigner une adresse email dans l'utilisateur PocketId, et il est possible d'activer l'option Administration / Configuration de l'application / E-mail / E-mail vérifiés par défaut ; après l'activation de cette option, il faut mettre à jour les emails de vos utilisateurs pour que le paramètre fasse effet.
- de devoir paramétrer l'autorité de confiance interne SSL également coté client OIDC (certains vérifient que l'adresse d'authentification est valide) ;  voir les différentes méthodes ci-dessous


# Configuration des servers/containers pour utilisation de l'AC interne

Pour que les applications fassent confiance à l'AC interne, il faut importer le certificat racine dans l'environnement concerné. Certaines applications le permettent directement dans leur configuration, soit globale, soit liée à la partie OIDC, d'autres nécessitent de l'ajouter en dehors de l'application, via les composants logiciels utilisés. Certains cas ne permettent pas d'importer un certificat AC, mais de désactiver la vérification SSL.

## Debian

Sur Debian, le certificat racine doit être copié dans le répertoire des autorités locales, puis le trust store doit être régénéré.

```bash
sudo cp internal_ca.crt /usr/local/share/ca-certificates/internal_ca.crt
sudo update-ca-certificates
```

Après cela, le certificat est pris en compte par les outils système qui s'appuient sur le trust store Debian.

## Java

Pour créer le keystore (une seule fois) :
```bash
keytool -importcert -trustcacerts -alias internal_ca -file /crt/internal_ca.crt -keystore /keystore/internal_ca.p12 -storepass changeme_not_that_secret -storetype PKCS12
```

Pour utiliser ce keystore au démarrage de l'application, ajouter en `JAVA_OPTS` :

```bash
-Djavax.net.ssl.trustStore=/keystore/internal_ca.p12
-Djavax.net.ssl.trustStorePassword=changeme_not_that_secret
```

Si l'application utilise des variables d'environnement ou un fichier `java_opts`, il suffit d'y ajouter ces options.

## Node.js

Pour Node.js et les outils npm, le plus simple consiste à utiliser la variable d'environnement `NODE_EXTRA_CA_CERTS`.

```bash
export NODE_EXTRA_CA_CERTS=/crt/internal_ca.crt
```

## Go

Pour Go, la variable `SSL_CERT_FILE` peut être utilisée pour pointer vers le certificat racine de l'AC interne.

```bash
export SSL_CERT_FILE=/crt/internal_ca.crt
```

Selon le contexte, `SSL_CERT_DIR` peut aussi être nécessaire si l'environnement attend un répertoire de certificats plutôt qu'un fichier unique.

## Python

En Python, le plus simple est d'utiliser `REQUESTS_CA_BUNDLE` ou `SSL_CERT_FILE` selon l'outil utilisé.

```bash
export REQUESTS_CA_BUNDLE=/crt/internal_ca.crt
```

Ou, pour un usage plus générique :

```bash
export SSL_CERT_FILE=/crt/internal_ca.crt
```


# Appliquer les mises à jour

Vouloir se sécuriser sans suivre les mises à jour serait complètement inutile. Il n'y a qu'à voir à quelle fréquence sortent les failles de sécurité à l'heure de l'IA. L'inconvénient d'avoir de nombreux applicatifs dans la stack est que cela peut faire beaucoup d'éléments à mettre à jour (OS, VM, dockers,...). 

Il existe généralement des options de mise à jour automatique, comme :
- Unattended upgrades pour Proxmox, [Debian](https://slash-root.fr/debian-configuration-complete-dunattended-upgrades-pour-une-securite-sans-effort/), [OPNsense](https://docs.opnsense.org/manual/updates.html) ; n'oubliez cependant pas de redémarrer lors des mises à jour de kernel
- Mise à jour automatique des containers docker avec [Dockhand](https://dockhand.pro/) ou [watchtower](https://github.com/containrrr/watchtower)
- 
Alors oui, ça vous expose aux attaques type "Supply chain", mais si vous n'êtes pas admin au quotidien sur votre homelab, c'est sans doute le moins pire...
