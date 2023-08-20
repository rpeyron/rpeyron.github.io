---
title: Profil BASH
lang: fr
tags:
- Scripts
- Linux
- Bash
categories:
- Informatique
toc: 'yes'
date: '2023-08-20 11:46:00'
image: files/2023/bash_replace_zsh.jpg
---

À l'occasion de mon passage sur debian 12, un problème avec `zsh`que j'utilisais depuis 25 ans m'a forcé à passer sur bash, et donc à me définir un profil bash adapté à mes besoins.

# Cahier des charges

Je n'ai pas un usage très avancé du terminal, mais un usage fréquent, avec quelques exigences :
- un prompt coloré et lisible, visible dans la barre de titre du terminal
- de l'auto complétion
- un certain nombre d'alias sur des commandes fréquentes

Petite spécificité, j'utilise également le shell avec l'utilisateur root, et je partage le fichier de configuration de mon utilisateur avec l'utilisateur root. Pour que cela fonctionne, il faut donc éviter d'utiliser la variable `$HOME` pour charger les fichiers en path relatif, d'où la définition d'un path racine absolu `$basedir`.


# .profile

Je positionne dans le fichier `.profile` tout ce qui est non spécifique à bash et commun à tous les shell. A noter que le .profile n'est pas chargé si un fichier .bashrc existe, il va donc falloir le charger.

.profile 
```sh
export LANG=fr_FR.UTF-8

alias ll='ls -lh'
alias df='df -h'
alias dff='df -x tmpfs -x fuse -x fuse.encfs -x devtmpfs -h'
alias du='du -H'
alias dum='du --max-depth 1'
alias dums='du -k --max-depth 1 | sort -r -n'
alias ai="sudo apt-get install"
alias acs="apt-cache search"
alias au="sudo apt-get update"
alias ag="sudo apt-get upgrade"
alias sc="sudo systemctl"
alias j="sudo journalctl"
alias sb='sudo -b $*'

# [ -n "$DISPLAY" ] && xhost +si:localuser:root > /dev/null

export PATH="$HOME/bin:$HOME/.local/bin:/usr/bin:/usr/sbin:/bin:/usr/local/bin:/sbin:/usr/local/sbin:$PATH"
export PYTHONPATH=$PYTHONPATH:$HOME/bin/lib/python:$HOME/bin/lib/misc
```
# .basrhc

Tout ce qui est spécifique bash sera positionné dans `.bashrc` 

.bashrc
```sh
#bash options
. /etc/bash_completion
shopt -s histappend
(
bind "TAB:menu-complete"
bind "set show-all-if-ambiguous on"
bind "set menu-complete-display-prefix on"
) >& /dev/null  # avoid warnings

# remove mail check as it conflicts with autocomplete
MAILCHECK=""

# comme le bashrc de root référence celui ci on ne doit pas utiliser le répertoire home
basedir=/home/remi

# Include .profile file
. $basedir/.profile

#Add autocomplete for aliases (https://github.com/cykerway/complete-alias)
. $basedir/complete_alias

complete -F _complete_alias ll
complete -F _complete_alias ai
complete -F _complete_alias acs
complete -F _complete_alias ag
complete -F _complete_alias au
complete -F _complete_alias sc
complete -F _complete_alias j


PS1='\[\033[31;1m\]\u\[\033[0m\]\[\033[33;1m\]@\[\033[0m\]\[\033[34;1m\]\h\[\033[0m\]\[\033[32;1m\]\w\[\033[0m\]\[\033[33;1m\]>\[\033[0m\] '

#with remi / server stripped
PS1='\[\033[31;1m\]$( whoami | sed 's/remi//')\[\033[0m\]\[\033[33;1m\]@\[\033[0m\]\[\033[34;1m\]$( hostname | sed 's/server//')\[\033[0m\]\[\033[32;1m\]\w\[\033[0m\]\[\033[33;1m\]>\[\033[0m\] '

# PROMPT_COMMAND='echo -en "\033]0;$(whoami)@$(hostname)|$(pwd)\a"'
PROMPT_COMMAND='echo -en "\033]0;$(echo $(whoami)@$(hostname) | sed 's/remi@server//' | sed 's/remi@/@/' | sed 's/@server/@/' )$(pwd | sed "s!$HOME!~!")\a"'

if [ "$TERM" = "screen" -o "$TERM" = "screen-w" -o "$TERM" = "screen.linux" ]
then
 export PS1="S-$PS1"
fi

```
J'active quelques options sur l'autocomplétion pour qu'en cas de plusieurs possibilités, le premier `<TAB>` liste les choix et le deuxième boucle dans les choix. 

Pour activer l'autocomplétion également sur les alias, il existe un script très pratique [complete-alias](https://github.com/cykerway/complete-alias) à télécharger et qui va se charger de définir tout seul la fonction d'autocomplétion qui correspond à la fonction de l'alias. 

La customisation du prompt se fait via la variable `$PS1`. Je passe sur la gestion des couleurs que je n'ai pas pris le temps d'apprendre, traduite automatiquement par ChatGPT depuis mon prompt zsh automatiquement (ce qui est assez bluffant pour un LLM, de plus avec un prompt très simple).  

La structure  de mon prompt est assez classique, tout la forme `user@host/current/path> `, la seule originalité étant sur le caractère de fin que je trouve plus élégant que le classique `$`ou `#`. Pour avoir un prompt très compact, je souhaite retirer `ùser`ou `host` s'il s'agit de l'utilisateur ou du host sur lequel j'ai l'habitude d'être. Pour cela, on peut jouer avec les capacité d'évaluation des variables. On peut jouer notamment sur le moment de l'évaluation:
- lors de la lecture du bashrc si on positionne une évaluation immédiate en utilisant des double quotes`"`  (par exemple `"$HOME"`ou `"$( hostname )"` pour l'exécution d'une commande
- lors de l'affichage du prompt (rafraichi avant chaque commande) en empechant l'évaluation à l'assignation, soit en utilisant des simple quotes `'`, ou en échappant la substitution via l'ajout d'un basckslash`\$` comme `'$HOME'`ou `"\$( hostname)"` ; et on peut mettre des pipes au sein des commandes.

Pour le titre d'un terminal, il existe une séquence d'échappement particulière pour indiquer au terminal qu'on veut lui donner un titre (`echo -ne '\033]0;<Titre>\a`), et pour le rafraîchir, on va utiliser un peu le même fonctionnement que pour le prompt en utilisant `$PROMPT_COMMAND` (on pourrait dans l'absolu également l'inclure en évaluation directement dans `$PS1`, mais c'est plus propre en distinguant les deux), et on peut jouer de la même façon que dans PS1 pour distinguer les temps de substitution des variables.

Il reste un truc pénible, avec l'alerte mail qui se déclenche au milieu de l'autocomplete et casse la ligne. Comme je n'utilise pas le mail unix, on peut désactiver en ajoutant `MAILCHECK=""` (voir le [code source mailcheck.c](http://git.savannah.gnu.org/cgit/bash.git/tree/mailcheck.c?h=bash-5.2#n85) pour plus de détails sur le fonctionnement)
