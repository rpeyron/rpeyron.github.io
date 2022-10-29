---
post_id: 4040
title: 'GCOV et la couverture de tests'
date: '2019-03-30T13:28:29+01:00'
last_modified_at: '2019-03-30T23:30:14+01:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=4040'
slug: gcov-et-la-couverture-de-tests
permalink: /2019/03/gcov-et-la-couverture-de-tests/
image: /files/2018/11/couverture_1553946035.jpg
categories:
    - Informatique
tags:
    - Couverture
    - GCOV
    - Sonarcloud
    - Tests
    - Travis
lang: fr
---

Dans mon article précédent sur la mise en place de Sonarcloud, je pensais que pour mettre en place la couverture de code il fallait recréer tous les tests unitaires, et j’avais tout faux. GCOV permet en effet de mesure le code utilisé avec n’importe quelle méthode de tests, y compris les scripts basiques que j’utilise. Donc c’est parti pour la mise en place !

Première déception, je n’ai pas trouvé de script autotools pour intégrer proprement GCOV ! Il semble exiser une macro [ax\_code\_coverage](https://www.gnu.org/software/autoconf-archive/ax_code_coverage.html) qui aurait été intéressante mais elle n’est pas distribuée par défaut, ne semble plus très maintenu et il y a beaucoup de dépendances. J’ai donc recopié certains bouts directement dans mes fichiers de configuration.

Dans configure.ac j’ai ajouté l’option –enable-gcov et intégré les options résultants dans les options de compilation :

```
dnl GCOV

AC_ARG_ENABLE(gcov,
AC_HELP_STRING([--enable-gcov],
	       [turn on test coverage @<:@default=no@:>@]),
[case "${enableval}" in
  yes) enable_gcov=true ;;
  no)  enable_gcov=false ;;
  *)   AC_MSG_ERROR(bad value ${enableval} for --enable-gcov) ;;
esac], [enable_gcov=false ])

if test x$enable_gcov = xtrue ; then
  if test x"$GCC" != xyes; then
    AC_MSG_ERROR([gcov only works if gcc is used])
  fi

  GCOV_CFLAGS="-fprofile-arcs -ftest-coverage"
  AC_SUBST(GCOV_CFLAGS)

  dnl libtool 1.5.22 and lower strip -fprofile-arcs from the flags
  dnl passed to the linker, which is a bug; -fprofile-arcs implicitly
  dnl links in -lgcov, so we do it explicitly here for the same effect
  GCOV_LIBS=-lgcov
  AC_SUBST(GCOV_LIBS)
fi

AM_CONDITIONAL(ENABLE_GCOV, test x"$enable_gcov" = "xtrue")

AC_CHECK_PROGS(GCOV, gcov, false)
AC_CHECK_PROGS(LCOV, lcov, false)

dnl Exports
DEBUG="-g"
LIBS="$DEBUG $LIBS $XML_LIBS $XSLT_LIBS -lexslt $GCOV_LIBS"
CXXFLAGS="$DEBUG $CXXFLAGS $XML_CXXFLAGS $XSLT_CXXFLAGS $GCOV_CFLAGS"
CPPFLAGS="$DEBUG $CPPFLAGS $XML_CPPFLAGS $XSLT_CPPFLAGS -Wno-write-strings $GCOV_CFLAGS"
CFLAGS="$DEBUG $CFLAGS $XML_CFLAGS $XSLT_CFLAGS - -Wno-write-strings $GCOV_LIBS"
```

Dans Makefile.am j’ai ajouté de quoi nettoyer les fichiers générés :

```
clean-local: code-coverage-clean

code-coverage-clean:
	-$(LCOV) --directory $(top_builddir) -z
	-find . \( -name "*.gcda" -o -name "*.gcno" -o -name "*.gcov" \) -delete
#	-rm -rf "$(CODE_COVERAGE_OUTPUT_FILE)" "$(CODE_COVERAGE_OUTPUT_FILE).tmp" "$(CODE_COVERAGE_OUTPUT_DIRECTORY)"

```

Je n’ai pas inclus pour l’instant la génération d’un rapport par lcov / gen\_html car je compte plutôt utiliser sonarcloud, donc j’ai commenté la dernière ligne.

Pour tester en local :

```
./configure --enable-gcov
make clean all test
cd src
lcov --directory . -c -o rapport.info
genhtml -o ../rapport -t "couverture de code des tests" rapport.info
sensible-browser ../rapport/index.html
```

Ce qui donne :

![](/files/2018/11/lcov-rapport.jpg){: .img-center}

Il faut maintenant configurer Travis-CI et Sonarcloud pour ajouter la couverture de code.

Dans .travis.yml, j’ai ajouté la target “test” de mes scripts de tests, et la compilation des résultats par gcov :

```
script:
  [...]
  - build-wrapper-linux-x86-64 --out-dir bw-output make clean all test
  - cd src && gcov -p *.cpp *.h && cd ..
```

Et dans sonar-project.properties, le chemin vers le rapport gcov :

```
sonar.cfamily.gcov.reportsPath=src
```

Voilà c’est prêt, une fois l’analyse effectuée, dans Sonarcloud on voit enfin le nouvel indicateur de couverture :

![](/files/2018/11/sonarcloud-coverage.png){: .img-center}

Il est possible ensuite de naviguer dans les différents fichiers pour voir les lignes non couvertes. La navigation n’est pas super pratique, notamment un overview par fonctions aurait été pratique, mais ça fait le boulot. Il ne me reste plus qu’à compléter les tests avec les fonctions non utilisées !

Le léger problème d’une chaine de CI, c’est que lors de la mise en place, comme tout est initié par un commit, il faut commiter pour pouvoir tester, ce qui pollue un peu avec de nombreux commits de mise au point. Il faudrait certainement mettre au point une chaine parallèle pour la mettre au point avant de l’appliquer sur l’environnement de production.

C’est donc la fin de la partie analyse et couverture de code (au moins en C/C++), peut être un complément à venir pour l’automatisation des releases.