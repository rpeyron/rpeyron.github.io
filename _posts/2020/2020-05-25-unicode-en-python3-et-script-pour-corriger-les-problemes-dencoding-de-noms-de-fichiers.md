---
post_id: 4368
title: 'Unicode en python3 et script pour corriger les problèmes d&#8217;encoding de noms de fichiers'
date: '2020-05-25T18:03:04+02:00'
last_modified_at: '2020-05-25T18:09:37+02:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=4368'
slug: unicode-en-python3-et-script-pour-corriger-les-problemes-dencoding-de-noms-de-fichiers
permalink: /2020/05/unicode-en-python3-et-script-pour-corriger-les-problemes-dencoding-de-noms-de-fichiers/
image: /files/2020/05/800px-New_Unicode_logo.svg.png
categories:
    - Informatique
tags:
    - Python
    - UTF8
    - chardet
    - convmv
    - Filesystem
    - Perl
    - Script
lang: fr
term_language:
    - Français
term_translations:
    - pll_612cf7f113ebe
---

La gestion de l’unicode a toujours été la galère en programmation, et notamment en python. Il y a une vingtaine d’année avec les Windows-1252 ou latin1, au pire on se retrouvait un affichage bizarre mais cela marchait toujours. Avec la généralisation d’UTF8, maintenant standard partout que ce soit pour l’affichage sur les consoles ou les systèmes de fichiers la donne a changé, et les scripts python se retrouvent souvent à planter à cause d’un problème d’encoding, et les messages comme celui ci-dessous sont devenus l’enfer du développeur python, surtout avec python2 :

```
UnicodeEncodeError: 'ascii' codec can't encode character u'\xb7' in position 590: ordinal not in range(128)
```

C’était devenu tellement complexe avec les conversions explicites ou implicites qu’on se retrouvait alors à tâtonner en ajoutant des `.encode` et des `.decode` un peu dans tous les sens jusqu’à ce que ça tombe en marche… Pas terrible…

# Trucs rapides pour maîtriser les encodings en python3

Python3 rationalise ça et apporte une solution bien plus efficace en séparant proprement les chaines de caractères unicode (str) des suites d’octets (bytes), et des fonctions d’encodage / décodage pour passer de l’une à l’autre : str.encode -&gt; bytes, et bytes.decode -&gt; str. Pour faire la différence sur les chaînes littérales, il faut utiliser b” devant les bytes et sinon python3 interprétera en str, en décodant depuis l’encoding de votre fichier source, qu’il faut donc penser à indiquer avec “# coding: ” en début de script.

En utilisation normale python3 va donc parfaitement se comporter, faisant implicitement pour votre compte les traductions unicode -&gt; encoding lorsque cela est nécessaire, par exemple pour ‘print’, pour l’ouverture d’un fichier en mode texte, etc.

Malheureusement, si le contenu que vous traitez comporte des erreurs, python3 est toujours aussi intolérant et vous retrouverez les exeptions UnicodeEncodeError &amp; co… Comme la distinction str / bytes est maintenant bien marquée il n’est plus aussi simple qu’avant que de l’embrouiller… Heureusement il y a cependant quelques astuces pour ce faire. Votre bible est la [section python specific encodings de la page 7.2 codecs de la documentation python3](https://docs.python.org/3.3/library/codecs.html#python-specific-encodings). Vous y trouverez des codecs particuliers pour faire des choses pas très catholiques, et un peu plus haut dans la page, la liste des errors handlers possibles.

En gros à chaque endroit où vous pouvez specifier un paramètre `encoding` il existe également un autre paramètre `errors` qui va spécifier le comportement du codec en cas d’erreur d’encoding. Si vous ne spécifiez rien, cela correspond à ‘`strict` ‘ et la fameuse exception sera levée. Dans la liste possible, ‘`ignore` ‘ est sans doute le plus simple : le caractère fautif est simplement ignoré. Vous pouvez redéfinir les options de stdout pour spécifier le comportement de print et ne plus avoir de plantage liés à des print de debugging…

```
# To avoid display problems of wrong encodings on utf8 terminal 
import sys 
sys.stdout.reconfigure(errors="ignore")
```

Si vous n’avez pas besoin d’un comportement exact c’est sans doute le plus simple, sinon il faut regarder de plus près les autres, qui vont tous substituer le caractère fautif en une autre forme acceptée (le cas des \*replace), ou temporairement tolérée (le cas de surrogateescape). Le problème se pose alors si vous avez besoin de retrouver la chaine de caractère originale avec son problème d’encoding (c’est le cas des fichiers qu’on veut renommer). Pour sa gestion interne des systèmes de fichiers python3 semble avoir adopté la gestion du surrogateescape ; ainsi un os.listdir ne retournera pas d’exception si un nom de fichier ne suit pas l’encoding du filesystem mais la chaine de caractère unicode comportera des caractères ‘surrogate’. L’avantage sur surrogateescape est qu’il est simple de retrouver la forme d’origine, il suffit d’encoder en ajoutant le paramètre `errors=”surrogateescape”` ; l’inconvénient est que par défaut tout codec renverra une erreur sur les caractères surrogate et qu’il faut donc spécifier systématiquement un comportement. Il existe “`surrogatepass` ” pour les ignorer. Donc par exemple pour afficher sur la console des chaines potentiellement avec surrogate :

```
sys.stdout.reconfigure(errors="surrogatepass")
```

Le plus confortable pour ne pas craindre à chaque instant une exception est donc d’utiliser un des modes ‘\*replace’ qui va remplacer le caractère fautif par une séquence d’échappement acceptée. Il n’est cependant pas toujours facile de revenir à la version initiale. Après avoir galéré un certain temps avec ‘backslashreplace’, j’ai trouvé dans [ce fil stackoverflow](https://stackoverflow.com/questions/14820429/how-do-i-decodestring-escape-in-python3) une méthode simple pour le faire, qui se base en partie sur le codec unicode-escape, et en partie sur la capacité du codec latin1 de convertir 100% des bytes en string et inversement pour pallier le fonctionnement de unicode-escape uniquement sur des bytes. Pour inverser un ‘backslashreplace’, la fonction est donc :

```
# Adaptation to revert backslashreplace content 
def backslashreplace_revert(s): 
  return (s.encode('latin1') # To bytes, required by 'unicode-escape' 
          .decode('unicode-escape') # Perform the actual octal-escaping decode 
          .encode('latin1') ) # 1:1 mapping back to bytes
```

# Assainir les noms de fichiers de son filesystem

Cette longue introduction pour présenter une application directe de ces éléments sur le cas qui m’intéresse, à savoir pouvoir faire en sorte que mon filesystem ne comporte que des noms de fichiers valides en UTF8. En effet, au fil de plus de 20 ans, entre le passage initial à utf8, les copies depuis des Windows plus ou moins au fait d’utf8, la décompression de vieux fichiers zip mal encodés, j’avais plus de 1000 noms de fichiers dont l’encoding n’était pas correct. Ça ne me gênait pas outre mesure jusque là, mais en voulant mettre en place un backup via [rclone](https://rclone.org/), ce dernier râle copieusement lorsque le nom de fichier n’est pas conforme… Pas facile à identifier et corriger à la main, donc j’ai fait un script.

Si identifier les fichiers fautifs est assez facile, c’est plus compliqué de deviner le bon encoding d’origine. Il existe un très bon outil [chardet](https://pypi.org/project/chardet/) qui permet d’identifier l’encoding d’un texte inconnu. Malheureusement il ne supporte que quelques encodings et pas tous ceux que j’avais sur mon disque, c’est à dire à peu près tous ceux utilisés pour du français : latin1/15 le classique européen, cp1252 la déclinaison par Windows, et cp850, l’ancienne version sous DOS/Windows. Ce dernier n’est pas supporté par chardet (et l’ajout d’un nouvel encoding ne semble pas hyper simple dans cet outil). Il me fallait donc trouver un autre moyen. J’ai fait sale, mais ça marche pas si mal 🙂 : j’ai basiquement fait une liste des caractères qui peuvent légitimement se retrouver dans mes noms de fichiers. Si un encoding me sort un nom de fichier qui n’utilise que ces caractères il est alors sans doute correct, sinon il est sans doute faux. Je fais le test sur la liste de ceux que je suis susceptible de rencontrer, et si plusieurs matchent, je privilégie celui trouvé par chardet qui est un peu plus intelligent que ce que j’ai fait… Si aucun ne correspond, je sélectionne celui qui comporte le moins de caractères en écart et sort une alerte pour l’utilisateur.

Pour les besoins de la mise au point de ce script, plutôt que de scanner à chaque fois mon disque j’ai préféré travailler sur un fichier de l’ensemble de la liste des fichiers, basiquement produit par `find /` . Si c’est super simple pour détecter les fichiers fautifs, je me suis ensuite rendu compte qu’une structure à plat serait compliquée à traiter pour l’étape de renommage. J’ai donc opté pour une conversion du fichier à plat en une structure arborescente, qui serait plus facile à construire directement depuis le disque que depuis la liste des fichiers à plat.

Enfin j’aurais souhaité initialement pouvoir générer un script shell avec la liste des commandes mv plutôt que de renommer les fichiers en python (ce que je fais d’habitude et qui est plus pratique pour tester et plus sécurisant). Malheureusement la fonction `shlex.quote` pour transformer une chaîne de caractère en argument pour le shell ne semble pas se comporter à l’identique du shell sur les noms de fichiers avec un mauvais encoding, il était donc plus simple de renommer en python directement plutôt que de devoir implémenter l’échappement correct.

Voici donc le code résultant :

```python
# coding: utf8
# python3 only because of unicode support

import codecs
import json
import pprint
import os
import argparse

# for charset detection : pip install chardet
import chardet

normalchars="/ " + \
	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789" + \
	"Ã‰ÃŠÃ‹Ã€Ã&nbsp;Ã¢Ã©Ã¨Ã«ÃªÃ¯Ã®Ã´Ã¹Ã»Ã§Ã±Ã¢Ã´Ã»Ã›" + \
	"!'Â°~#$%_Â§&()+,-.;=@[]{}Â©Â®"
unwantedchars="\"^`|*?<>:\\Â²"

# defaults for debug
filelist='files.lst'
filerename='files.ren'

# To avoid display problems of wrong encodings on utf8 terminal
import sys
sys.stdout.reconfigure(errors="surrogatepass")

# From : https://stackoverflow.com/questions/14820429/how-do-i-decodestring-escape-in-python3
def string_escape(s, encoding='utf-8'):
    return (s.encode('latin1')         # To bytes, required by 'unicode-escape'
             .decode('unicode-escape') # Perform the actual octal-escaping decode
             .encode('latin1')         # 1:1 mapping back to bytes
             .decode(encoding,errors="surrogateescape"))        # Decode original encoding

# Adaptation to revert backslashreplace content
def backslashreplace_revert(s):
    return (s.encode('latin1')         # To bytes, required by 'unicode-escape'
             .decode('unicode-escape') # Perform the actual octal-escaping decode
             .encode('latin1') )        # 1:1 mapping back to bytes

# Utility function to len or 0 for None
def lenornone(var):
	if var:
		return len(var)
	else:
		return 0

# Utility function to check if filename is in the "authorized char list" 
#   (used to guess if it is right encoding or messed up...)
def check_filename(filename, setnormalchars):
	lineset = set(filename).difference(setnormalchars)
	if len(lineset) > 0:
		return lineset
	else:
		return None

# Get chars present in filenames that are not in the "authorized char list" 
def get_suspicious_chars(filelist, normalchars) :
	# Adapted from :  https://stackoverflow.com/questions/21522234/how-to-get-all-unique-characters-in-a-textfile-unix-python
	fh = open(filelist,'r', encoding="utf8", errors="backslashreplace").read()
	unique_chars = set(fh)
	suspicious = { (v if v not in normalchars else '')  for v in unique_chars }
	return suspicious

# List files that do not match the "authorized char list" 
def list_suspicious_files(filelist, setnormalchars):
	fh = open(filelist,'r', encoding="utf8", errors="ignore")
	for line in fh.read().splitlines():
		lineset = check_filename(line_utf8, setnormalchars)
		if lineset:
			print("# ", lineset)
			print(line)

# List files that present errors in UTF8
def list_utf8errors_files(filelist, setnormalchars):
	fh = open(filelist,'rb')
	for line in fh.read().splitlines():
		try: 
			line_utf8 = line.decode("utf8")
		except:
			# I should maybe have used replace, or surrogateescape, that would
			#   have been more easy to revert
			line_utf8 = line.decode("utf8", errors="backslashreplace")
			print("> ", line_utf8)
			detenc = chardet.detect(line)
			sel_encoding = None;
			for encoding in {"latin1", "cp1252", "cp850", detenc['encoding']}:
				line_enc = line.decode(encoding, errors="ignore")
				line_enc_set = check_filename(line_enc, setnormalchars)
				if (sel_encoding is None) or (sel_encoding and (lenornone(line_enc_set) < lenornone(sel_enc_set))):
					sel_encoding = encoding
					sel_enc_set = line_enc_set
			line_enc = line.decode(sel_encoding, errors="ignore")
			if lenornone(sel_enc_set) > 0:
				print("# !!! No suitable encoding found !!! Encoding: ", encoding," Set: ", sel_enc_set)
			else:
				print("# Encoding: ",  encoding)
			# shlex.quote do not seems to be working at all for encoding errors, 
			#    so we cannot create mv script as initiall intended
			#    (would have been easier to work with)
			# print("mv ", shlex.quote(line_utf8), shlex.quote(line_enc))
			print("Selected: ", line_enc)

# Clean the tree for empty renaming			
def clean_tree(tree):
	for key in list(tree.keys()):
		item = tree[key]
		if (key != '.') and (key != '..'):
			clean_tree(item)
		if (len(item) == 1) and (len(item['.']) == 0):
			del tree[key]

# Convert filename list to tree, because :
#  - for a huge bunch of files, it is more easy to work with a file 
#           that to scan the entire filesystem each time
#  - mandatory to manage properly the renaming of folders
#      (and the renaming of files contained in that folder, after renaming the folder)
def list2tree(filelist, setnormalchars):
	tree = {}
	fh = open(filelist,'rb')
	for line in fh.read().splitlines():
		try: 
			line_utf8 = line.decode("utf8")
		except:
			comps = line.split(b'/')
			cur = tree
			for comp in comps:
				enc_tips = None
				try:
					comp_utf8 = comp.decode("utf8")
					comp_enc = ""
				except:
					comp_utf8 = comp.decode("utf8", errors="backslashreplace")
					detenc = chardet.detect(comp)
					sel_encoding = None
					for encoding in {"latin1", "cp1252", "cp850", detenc['encoding']}:
						if encoding:
							line_enc = comp.decode(encoding, errors="ignore")
							line_enc_set = check_filename(line_enc, setnormalchars)
							if (sel_encoding is None) or (sel_encoding and (lenornone(line_enc_set) < lenornone(sel_enc_set))):
								sel_encoding = encoding
								sel_enc_set = line_enc_set
					comp_enc = comp.decode(sel_encoding, errors="ignore")
					if lenornone(sel_enc_set) > 0:
						enc_tips = "!!! No suitable encoding found !!! Encoding: " +  sel_encoding +" Set: " + str(sel_enc_set)
					else:
						enc_tips = "Encoding: " +  sel_encoding 
				if comp_utf8 in cur:
					cur = cur[comp_utf8]
				else:
					cur[comp_utf8]  = { '.' :  comp_enc }
					if enc_tips:
						cur[comp_utf8] ['..'] = enc_tips
					cur = cur[comp_utf8]
	clean_tree(tree)
	#pprint.pprint(tree)
	print(json.dumps(tree, indent=2,ensure_ascii=False))

# Recursive function to do the move of items in the tree
def do_mv(tree, cur):
	for key in list(tree.keys()):
		if (key != '.') and (key != '..'):
			item = tree[key]
			next = key
			if len(item['.']) > 0:
				key = backslashreplace_revert(key)
				src = cur.encode()+b'/'+ key
				dst = cur+'/'+item['.']
				print("mv ", src, " ", dst)
				os.rename(src,dst)
				next = item['.']
			do_mv(item, cur + "/" + next)

# Move the files by loading the tree file and starting the recursion
def json_do_mv(file):
	tree = json.load(open(file))
	do_mv(tree[''],"")

# Command line handling
parser = argparse.ArgumentParser(description='Helps the renaming of bad UTF8 filenames.')
parser.add_argument("command", help="the command to use", choices=['getchars', 'listsuspicious', 'listerrors', 'gettree', 'movetree'])
parser.add_argument("input", help="the input file")
args = parser.parse_args()

if args.command == "getchars":
	print(sorted(get_suspicious_chars(args.input, normalchars +  unwantedchars)))
elif args.command == "listsuspicious":
	list_suspicious_files(args.input, set(normalchars + unwantedchars))
elif args.command == "listerrors":
	list_utf8errors_files(args.input, set(normalchars + unwantedchars))
elif args.command == "gettree":
	list2tree(args.input, set(normalchars + unwantedchars))
elif args.command == "movetree":
	json_do_mv(args.input)


```

A noter que ce script est quand même assez expérimental / rudimentaire, et à ne pas utiliser aveuglement…

Il existe un script [convmv](http://freshmeat.sourceforge.net/projects/convmv) disponible dans toutes les bonnes distributions qui permet de convertir assez simplement d’un encoding en utf8. Pour les cas simples, c’est LE script à regarder en premier. J’en avais fait il y a longtemps, à l’occasion de mon premier cleanup, une variante qui utilise le module [Encode::Guess](https://metacpan.org/pod/Encode::Guess) : [convmv-detect](/files/2020/05/convmv-detect.zip) (script perl à télécharger et dézipper). L’usage est identique à convmv, il suffit d’indiquer “-f detect” pour demander la détection et changer en ligne 449 la liste des encodings “suspects” (oui c’est moche : c’est du perl et je suis nul en perl…)