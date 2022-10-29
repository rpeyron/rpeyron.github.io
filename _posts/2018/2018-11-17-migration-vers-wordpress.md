---
post_id: 1552
title: 'Migration vers WordPress !'
date: '2018-11-17T15:38:48+01:00'
last_modified_at: '2020-12-21T12:16:47+01:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=1552'
slug: migration-vers-wordpress
permalink: /2018/11/migration-vers-wordpress/
tc-thumb-fld: 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
post_slider_check_key: '0'
image: /files/2018/10/wordpress_1540683760.jpg
categories:
    - Général
    - Informatique
tags:
    - Blog
    - Wordpress
lang: fr
toc: true
---

Après plus de 15 ans de bons et loyaux services, mon [ancien site web](/2000/11/site/) commençait à nécessiter un bon lifting. Par ailleurs étant un mix d’une solution maison sur php pour le coeur du site, sur lequel était greffé dokuwiki pour la section wiki, serendipity pour le blog, et gallery1 pour les photos, la modernisation de tout ça n’était pas bien pratique.

Après de nombreuses hésitations et essais, j’ai finalement opté pour wordpress pour remplacer l’ensemble. La migration pouvait commencer…

# Installation de WordPress

Je suis initialement parti sur le package wordpress de la distribution debian. Seulement au bout de quelques jours, il a fallu se rendre à l’évidence que le paquet n’était pas mis à jour avec les mises à jour de wordpress. Sans vouloir trop rentrer dans le détail si ça n’était que lorsqu’il n’y avait pas de mise à jour de sécurité, j’ai décidé de faire une installation custom.

Par ailleurs pour faciliter les sauvegardes / transfert sur mon poste fixe / développements, j’ai préféré opter pour une installation sqlite, grace au plugin “**SQLite Integration**“. Ce n’est pas vraiment recommandé, mais pour l’instant cela semble bien fonctionner.

# Migrations des contenus

## Migration de dokuwiki

Pour la migration de dokuwiki, j’ai trouvé ce script (https://dentedreality.com.au/2013/01/29/import-dokuwiki-pages-into-wordpress/) que j’ai adapté pour mieux correspondre à mon wiki. Le résultat n’est pas parfait car on récupère le code html produit par dokuwiki, il faut donc prévoir de retoucher les différentes pages. Pour une première approche avec peu de pages c’est correct, mais à éviter si vous avez trop de pages. Je pense éventuellement ajouter une extension pour le support de la grammaire dokuwiki et copier le source des pages. Vu le peu de nombre de vraies pages wiki de mon wiki, je les ai converties en articles, ce qui est plus juste pour la majorité des cas. Je l’ai également adapté pour générer les redirects.

## Migration de serendipity

Pour la migration de la partie blog sous serendipity, j’ai commencé par l’import RSS qui permet d’importer les billets. Par contre cela ne migre pas les commentaires. J’ai trouvé un autre script de migration (https://github.com/ascg/s9y-to-wp). Mon instance serendipity étant sous sqlite et ce script ne supportant que mysql je n’ai rien trouvé de plus simple que de migrer mes posts sous mysql avec sqlite-to-mysql (https://github.com/vwbusguy/sqlite-to-mysql). L’import s’est ensuite très bien passé. Je n’ai pas fait toutes les étapes SQL décrites, je pense que c’est pour une ancienne version du script uniquement.

J’ai généré ensuite les associations de redirection via SQL, en ouvrant la base serendipty dans DB Browser For SQLite, en attachant la base wordpress, et en appairant sur le timestamp. Première requête pour analyser la correspondance et corriger les éventuelles non correspondances :

```sql
SELECT e.id, title, timestamp, permalink, isdraft, wpp.ID, wpp.post_title, wpp.guid, wpp.post_status 
FROM `sr_entries` e, `sr_permalinks` p 
LEFT OUTER JOIN  wp.wp_posts wpp ON strftime("%s",post_date_gmt)=timestamp 
WHERE e.id = p.entry_id AND p.type='entry' AND post_status IS NOT 'inherit'
```

Et deuxième requête pour générer le fichier de redirection à importer :

```sql
SELECT "Redirect	301	" || permalink || "	" || wpp.guid 
FROM `sr_entries` e, `sr_permalinks` p, wp.wp_posts wpp 
WHERE strftime("%s",post_date_gmt)=timestamp 
AND e.id = p.entry_id AND p.type='entry' AND post_status IS NOT 'inherit'
```

## Migration des médias

Les articles étaient maintenant correctement importés, mais il restait les liens orginaux vers les images. J’ai utilisé l’extension “**Import External Images**” pour les importer. Petit problème, comme les adresses étaient sur le même serveur, l’extension ne les considérait pas comme externes. J’ai du dans un premier temps utiliser l’extension “**Search Regex**” pour convertir les URL relatives en URL absolues sur un virtual host. Seulement wordpress n’aime pas les URL externes qui pointent sur le même serveur, considère qu’il s’agit d’un problème de sécurité, et interdisait ainsi l’import des photos. La solution est d’ajouter la ligne suivante dans le plugin pour lui dire de ne pas en tenir compte.

```php
add_filter( 'http_request_host_is_external', '__return_true' );
```

N’oubliez pas de la retirer une fois la migration terminée !

## Migration du site précédent

J’avais un site précédent généré via PHP. Il fallait donc une solution qui sache aspirer le contenu sans les en-têtes pré-générés. J’ai opté pour le plugin HTML Import 2 que j’ai modifié pour traduire en français, pouvoir importer tout type de contenu, en conservant la structure originale, éventuellement préfixée. J’ai poussé une pull request mais elle n’a pas encore été pris en compte par l’auteur. Vous pouvez donc consulter mon [fork sur github](https://github.com/rpeyron/HTML-Import-2).

Si cela permet de faire le plus gros du travail d’import, il reste un travail de fourmi pour mettre au propre les articles, supprimer les pages qui ne servaient que pour la navigation et corriger les quelques problèmes de mise en page.

## Nettoyage des articles

Commence la partie la plus fastidieuse avec la mise au propre de tous les articles. Au bout de quelques uns à la main, j’ai pu constater que le code importé était vraiment très moches, d’une part à cause de l’éditeur wysiwyg pour serendipity, et d’autre part par du fait de l’import de la conversion html pour dokuwiki. J’ai donc passé un script pour nettoyer toutes les balises et styles inutiles. L’extension Search Regex ne fonctionnant visiblement pas sur un tel volume (plus de 18000 remplacements) j’ai fini par faire un script php quick’n dirty en direct sur la base de donnée.

```php
<?php

$db = new PDO('sqlite:wpdb.sqlite','','');
//$db = new PDO('sqlite:/home/wp/wp-content/database/.ht.sqlite','','');

$updt = $db->prepare("UPDATE wp_posts SET post_content = :post_content WHERE ID=:ID");

foreach($db->query("SELECT * FROM wp_posts") as $post) {
	$content = $post['post_content'];
	//print "<<<<<".$content;
	$content = strip_tags($content, "<p><a><strong><em><b><i><blockquote><img><ul><ol><li><h1><h2><h3><h4>");
	$content = preg_replace("# style=['\"][^'\"]*['\"]#","", $content);
	$content = preg_replace("# class=['\"][^'\"]*['\"]#","", $content);
	//print ">>>>>" . $content;
	$updt->bindValue(":post_content", $content);
	$updt->bindValue(":ID",$post['ID']);
	$updt->execute();
}

?>
```

# Choix du thème

Trouver un bon thème est sans doute l’étape la plus compliquée… difficile de trouver un thème qui soit fonctionnel, un peu moins basique que les thèmes wordpress par défaut, gratuit, bien maintenu, et pas trop moche.

J’ai finalement opté pour **OceanWP**, qui est un thème très riche par défaut, bien maintenu, très fonctionnel avec Elementor. Contrairement à d’autres thèmes qui limitent les fonctionnalités pour aller souscrire le thème premium et vous le rappelle à chaque écran, OceanWP a basé son business model sur un thème gratuit, mais des plugins complémentaires payants. Le pack est cependant bien trop cher pour un particulier.

J’ai comme ambition de faire un thème fils, pour compléter OceanWP avec différentes fonctions que je trouve bien faites sur d’autres thèmes avec lesquels j’ai longtemps hésité :

- Customizr : plusieurs éléments intéressants : 
    - le header fixe transparent (avec retrécissement, disparition sur mobile et réapparition sur scroll up)
    - la liste d’article avec l’image alternée gauche / droite
- Zerif Lite : le design par défaut est très sympa, notamment les couleurs et le souligné rouge

# Plugins

J’utilise les plugins suivants :

- Pour compléter OceanWP : 
    - Ocean Extra
    - Ocean Social Sharing : plugin gratuit pour ajouter des liens de partage sur les articles
    - Elementor : un outil de création avancé des pages super puissant et intuitif (utilisé uniquement sur certaines pages)
- sqlite-integration : pour utiliser une base de donnée sqlite plutôt que mysql ; bien plus facile à gérer, backuper, transporter, restaurer,… et suffisante a priori pour un site de taille modeste comme le mien (avec ajout d’un gestionnaire de cache pour compléter en cas de “succès” d’une des pages)
- WP Super Cache… pour un super cache ! (et compatible avec sqlite-integration)
- Polylang pour une gestion minimaliste du multilinguisme (je préférais l’ergonomie de qTranslateX mais il n’est pas compatible avec Elementor)
- Language Mix pour afficher quand même les articles non traduits (j’ai du l’adapter un peu pour filtrer les articles traduits et la page d’accueil, voir ci-dessous)
- Photonic pour la création d’une gallerie de photos stockées sur Google+
- Admin Post Navigation : pour ajouter des boutons pratique pour éditer les posts suivants / précédents
- Change Last Modified Date : permet de maîtriser la date de mise à jour ; notamment utile pour les modifications lors de l’import des posts sans changer la date
- Collapsing Archives : pour avoir les archives présentées en arborescence années / mois plutôt que la très longue liste par défaut
- Crayon Syntax Highlighter : pour l’inclusion de code source colorisé ; pas encore complètement satisfait d’un point de vue simplicité d’usage, pas de fonction facile de téléchargement du fichier, mais pas trouvé mieux pour l’instant
- Enable Media Replace : permet de remplacer un media dans la bibliothèque plutot que de devoir supprimer le précédent, uploader avec le même nom, etc. Très pratique par exemple pour mettre à jour un fichier zip de code source ou autre en conservant l’url.
- Pixabay images : très pratique pour importer directement des images gratuites depuis pixabay, notamment pour les images de mise en valeur.
- Post Type Switcher : pour passer un contenu d’un post blog à une page, ou inversement. Pratique notamment pour retyper des pages wiki qui finalement n’ont jamais été mises à jour en post unique.
- Redirection : pour mettre en place plus facilement les règles de redirection du site précédent à celui ci (cependant bien que déclaré compatible avec sqlite integration, il y a un problème sur la création d’une table ; voir patch ci-dessous)
- Search Regex : super pratique pour appliquer des regex sur tous les articles, pratique pour changer l’adresse du site par exemple ; par contre ne marche pas très bien pour de trop grosses regex / modifications. Pas trouvé mieux cependant
- Shortcode Ultimate : plein de shortcode bien réalisés pour faire un peu tout, des boutons, des tabs,… remplace avantageusement en un seul package pas mal de shortcodes qu’on pourrait trouver sur des plugins séparés ; dispose d’une version premium mais la version de base est déjà bien dotée et pas trop enquiquinante pour souscrire le premium
- WP Media Folders : pour gérer des répertoires dans la bibliothèque de media, notamment utile pour les fichiers de distribution de logiciel ou autre. J’ai d’ailleurs déplacé le répertoire /wp-contents/uploads par /files pour avoir des URL plus jolies via la directive define(‘UPLOADS’,’files’); dans le wp-config.php (et un lien symbolique pour éviter d’avoir à mettre à jour les articles)
- Organize Media Library by Folders et Extend Media Upload : pour pouvoir déplacer les médias (répertoire de stockage)
- Display posts shortcode pour inclure une liste d’articles avec l’affichage du thème via customisation d’une fonction dans functions.php du site (voir le tutoriel sur le site)
- Posts sliders and Post Grids pour avoir un affichage sympa du blog sous forme de grille pour la page d’accueil.
- Table of Contents Plus pour générer des sommaires sur les pages un peu longues
- WP Add Mime Types pour ajouter facilement des types de fichiers autorisés en upload (attention, prend un peu de temps à être effectif)
- WP Static Generator pour extraire un site statique

## Compatibilité collapsing-archives avec Sqlite

Un petit patch pour avoir la compatibilité ([thread sur la page support](https://wordpress.org/support/topic/compatibility-with-sqlite-integration/))

```patch
diff -u collapsing-archives-2.0.5/collapsArchList.php collapsing-archives/collapsArchList.php
--- collapsing-archives-2.0.5/collapsArchList.php	2017-08-18 14:30:00.000000000 +0200
+++ collapsing-archives/collapsArchList.php	2017-10-24 20:15:05.000000000 +0200
@@ -95,8 +95,7 @@
 
   $postquery= "SELECT $wpdb->terms.slug, $wpdb->posts.ID,
     $wpdb->posts.post_name, $wpdb->posts.post_title, $wpdb->posts.post_author,
-    $wpdb->posts.post_date, YEAR($wpdb->posts.post_date) AS 'year',
-    MONTH($wpdb->posts.post_date) AS 'month' ,
+    $wpdb->posts.post_date, 
     $wpdb->posts.post_type
     FROM $wpdb->posts LEFT JOIN $wpdb->term_relationships ON $wpdb->posts.ID =
     $wpdb->term_relationships.object_id 
@@ -128,6 +127,14 @@
   $lastMonth=-1;
   $lastYear=-1;
   for ($i=0; $i<count($allPosts); $i++) {
+	// Restore Month & Year
+	if (isset($allPosts[$i]->post_date)) {
+	$dateparts = explode('-',$allPosts[$i]->post_date);
+	if (count($dateparts) > 2) {
+	$allPosts[$i]->year = $dateparts[0];
+	$allPosts[$i]->month = $dateparts[1];
+	}}
+	
     if ($allPosts[$i]->year != $lastYear) {
       $lastYear=$allPosts[$i]->year;
     }
Les sous-rÃ©pertoires collapsing-archives-2.0.5/img et collapsing-archives/img sont identiques

```

## Compatibilité Redirection avec SQLite

Il y a un problème à la création de la table wp\_redirection\_items par le plugin, sans doute à cause de l’utilisation du type enum non supporté par SQLite. Il suffit d’ouvrir la base de données et de créer la table à la main (modifier le préfixe wp\_ si modifié sur votre site) :

```sql
CREATE TABLE IF NOT EXISTS `wp_redirection_items` (
			`id` int(11) NOT NULL AUTOINCREMENT,
			`url` mediumtext NOT NULL,
			`regex` int(11)  NOT NULL DEFAULT '0',
			`position` int(11)  NOT NULL DEFAULT '0',
			`last_count` int(10)  NOT NULL DEFAULT '0',
			`last_access` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
			`group_id` int(11) NOT NULL DEFAULT '0',
			`status` varchar(20) NOT NULL DEFAULT 'enabled',
			`action_type` varchar(20) NOT NULL,
			`action_code` int(11)  NOT NULL,
			`action_data` mediumtext,
			`match_type` varchar(20) NOT NULL,
			`title` text,
			PRIMARY KEY (`id`));
			
CREATE INDEX  `redir_url` on wp_redirection_items(`url`)
CREATE INDEX  `redir_status` on wp_redirection_items(`status`)
CREATE INDEX  `redir_regex` on wp_redirection_items(`regex`)
CREATE INDEX  `redir_group_idpos` on wp_redirection_items(`group_id`,`position`)
CREATE INDEX  `redir_group` on wp_redirection_items(`group_id`)

```

## Modification de langage-mix pour filtrer les articles traduits

**Edit 21/12/2020:** nouvelle version compatible avec la pagination [/2020/12/wordpress-plugin-language-mix/](/2020/12/wordpress-plugin-language-mix/)

Il suffit d’ajouter les lignes ci-dessous :

```php
/**
 *   Remove duplicated posts tanslated
 */
function pllx_filter_the_posts($post_list) {
    global $locale;
    global $polylang;
	
	$cur_lang = pll_current_language();

  // Index post_list
  $post_index=array();
  foreach ($post_list as $post) { $post_index[] = $post->ID; }

  // Filter post_list
  foreach ($post_list as $k => $post) {
	$post_lang = $polylang->model->get_post_language($post->ID);
	// Check if current post in current locale
	//if ($post_lang && ($post_lang->locale != $locale)) 
	if ($post_lang && ($post_lang->slug != $cur_lang)) 
	{
		// If not, get translations
		$trans = $polylang->model->post->get_translations($post->ID);
		if ($trans && (count($trans) > 1))
		{
			unset($trans[$post_lang->slug]);
			// S'il existe une traduction, on supprime le post
			foreach($trans as $slug => $post_id){
				// Skip current
				if ($post_id != $post->ID) {
					// Test if in list
					if (in_array($post_id, $post_index)) {
						// Found, deleting
						unset($post_list[$k]);
					}
				}
				
			}
		}
	}
	 
  }
  //var_dump($post_list);*/
  return(array_values($post_list));
}
add_filter('the_posts','pllx_filter_the_posts');

```

A noter également la modification de la ligne suivante de pll\_posts\_where pour ajouter la compatibilité avec la page principale (ajout de is\_front\_page) :

```php
            if (is_home() ||  is_front_page() ) {
```

# Mise en place finale

Le contenu dans WordPress est malheureusement stocké de manière dépendant à l’URL et à l’emplacement sur le serveur web, or pour basculer à son emplacement définitif, je devais modifier les deux, j’ai du opérer les actions suivantes :

- Mettre la nouvelle URL du serveur dans Réglages / Général
- Remplacer dans tous les articles l’ancienne URL par la nouvelle avec le plugin Search Regex
- Remplacer les éventuelles URLs manuelles dans les menus
- L’emplacement du cache dans le fichier wp-config.php
- Le plugin Organize Media Library by Folders scanne les répertoires et les stocke dans la table wp\_options ; j’ai changé le nom de la clé “organizemedialibrary\_settings\_1” pour le forcer à scanner à nouveau les bons répertoires et tout est rentré dans l’ordre

Au final la migration aura duré presque une bonne année, entre les tests des différents logiciels possibles, la très difficile sélection du thème, la migration proprement dite et la remise au propre des principales pages.