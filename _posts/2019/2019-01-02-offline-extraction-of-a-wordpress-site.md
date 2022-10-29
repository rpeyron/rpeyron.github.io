---
post_id: 3972
title: 'Offline extraction of a WordPress site'
date: '2019-01-02T17:37:54+01:00'
last_modified_at: '2021-06-12T19:30:16+02:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=3972'
slug: offline-extraction-of-a-wordpress-site
permalink: /2019/01/offline-extraction-of-a-wordpress-site/
image: /files/2018/10/wordpress_1540683760.jpg
categories:
    - Informatique
tags:
    - Wordpress
    - httrack
    - offline
lang: en
---

I want a offline browseable static version of my wordpress website to be able to put it on USB or upload to a backup static location. I searched some wordpress plugins to do that and wp2static seemed very promising. But it turned out disappointing (version 6.1) because of many flaws in the crawler (many url were missed) and in the ways url are rendered as it is mainly intended to output with a full target URL (relative URLs are really not working at all). I tried a bit to patch the plugin but the code was too difficult to understand and modify. So I decided to use a tool outside wordpress, the well known httrack I used years ago.

# Offline CSS

Some of the features of the site are not available or relevant in an offline version of the wordpress site, like comments, search box, google translate, google gallery… So I will hide them with custom CSS added in my theme :

```css
/* Offline */
.offline .widget_search, .offline .search-toggle-li,
.offline .widget_glt_widget , 
.offline .site-search-toggle, 
.offline #respond, .akismet_comment_form_privacy_notice, 
.offline .sidr-class-mobile-searchform,
.offline .photonic-google-stream
{ display:none!important }
```

That only requires the ‘offline’ class to be added to the &lt;body&gt; main tag. This function is not available in httrack out of the box and that is the purpose of the additions below.

# Method 1 : a postprocessing plugin

httrack gives you the opportunity to add plugins to enhance the main behaviour. That is exactly what we want !

Here is the code to add the offline class :

```c
/*
    From HTTrack external callbacks example 
	
    How to build: 
        gcc -O -g3 -Wall -D_REENTRANT -fPIC -shared -o offline.so offline.c -lhttrack

    How to use:
        LD_LIBRARY_PATH=<path> httrack --wrapper offline.so ..
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Standard httrack module includes */
#include "httrack/httrack-library.h"
#include "httrack/htsopt.h"
#include "httrack/htsdefines.h"

/* Local function definitions */
static int postprocess(t_hts_callbackarg * carg, httrackp * opt, char **html,
                       int *len, const char *url_address, const char *url_file);

/* external functions */
EXTERNAL_FUNCTION int hts_plug(httrackp * opt, const char *argv);

/* 
module entry point 
*/
EXTERNAL_FUNCTION int hts_plug(httrackp * opt, const char *argv) {
  const char *arg = strchr(argv, ',');

  if (arg != NULL)
    arg++;

  /* Plug callback functions */
  CHAIN_FUNCTION(opt, postprocess, postprocess, NULL);

  return 1;                     /* success */
}

// From https://creativeandcritical.net/str-replace-c
char *repl_str(const char *str, const char *from, const char *to) {

	/* Adjust each of the below values to suit your needs. */

	/* Increment positions cache size initially by this number. */
	size_t cache_sz_inc = 16;
	/* Thereafter, each time capacity needs to be increased,
	 * multiply the increment by this factor. */
	const size_t cache_sz_inc_factor = 3;
	/* But never increment capacity by more than this number. */
	const size_t cache_sz_inc_max = 1048576;

	char *pret, *ret = NULL;
	const char *pstr2, *pstr = str;
	size_t i, count = 0;
	#if (__STDC_VERSION__ >= 199901L)
	uintptr_t *pos_cache_tmp, *pos_cache = NULL;
	#else
	ptrdiff_t *pos_cache_tmp, *pos_cache = NULL;
	#endif
	size_t cache_sz = 0;
	size_t cpylen, orglen, retlen, tolen, fromlen = strlen(from);

	/* Find all matches and cache their positions. */
	while ((pstr2 = strstr(pstr, from)) != NULL) {
		count++;

		/* Increase the cache size when necessary. */
		if (cache_sz < count) {
			cache_sz += cache_sz_inc;
			pos_cache_tmp = realloc(pos_cache, sizeof(*pos_cache) * cache_sz);
			if (pos_cache_tmp == NULL) {
				goto end_repl_str;
			} else pos_cache = pos_cache_tmp;
			cache_sz_inc *= cache_sz_inc_factor;
			if (cache_sz_inc > cache_sz_inc_max) {
				cache_sz_inc = cache_sz_inc_max;
			}
		}

		pos_cache[count-1] = pstr2 - str;
		pstr = pstr2 + fromlen;
	}

	orglen = pstr - str + strlen(pstr);

	/* Allocate memory for the post-replacement string. */
	if (count > 0) {
		tolen = strlen(to);
		retlen = orglen + (tolen - fromlen) * count;
	} else	retlen = orglen;
	ret = malloc(retlen + 1);
	if (ret == NULL) {
		goto end_repl_str;
	}

	if (count == 0) {
		/* If no matches, then just duplicate the string. */
		strcpy(ret, str);
	} else {
		/* Otherwise, duplicate the string whilst performing
		 * the replacements using the position cache. */
		pret = ret;
		memcpy(pret, str, pos_cache[0]);
		pret += pos_cache[0];
		for (i = 0; i < count; i++) {
			memcpy(pret, to, tolen);
			pret += tolen;
			pstr = str + pos_cache[i] + fromlen;
			cpylen = (i == count-1 ? orglen : pos_cache[i+1]) - pos_cache[i] - fromlen;
			memcpy(pret, pstr, cpylen);
			pret += cpylen;
		}
		ret[retlen] = '\0';
	}

end_repl_str:
	/* Free the cache and return the post-replacement string,
	 * which will be NULL in the event of an error. */
	free(pos_cache);
	return ret;
}

static int postprocess(t_hts_callbackarg * carg, httrackp * opt, char **html,
                       int *len, const char *url_address,
                       const char *url_file) {
  char *old = *html;

  /* Call parent functions if multiple callbacks are chained. */
  if (CALLBACKARG_PREV_FUN(carg, postprocess) != NULL) {
    if (CALLBACKARG_PREV_FUN(carg, postprocess)
        (CALLBACKARG_PREV_CARG(carg), opt, html, len, url_address, url_file)) {
      /* Modified *html */
      old = *html;
    }
  }

  /* Process */
  *html = repl_str(*html, "<body class=\"", "<body class=\"offline ");
  
  // hts_free(old);  // Urgh ugly memory leak but else it crashed....

  return 1;
}
```

Be careful to include in the path of your file in your LD\_LIBRARY\_PATH (or launch httrack as written in the header of the C file).

Note that hts\_free(old) crashes and after struggling a little I had to comment it out. It results in an awful memory leak, but it is not really too annoying for my use.

# Method 2 : a simple sed script

The method above is finally a little bit tiresome, so I decided to use sed to add the offline class (‘s/&lt;body class=”/\\0offline /’) and a simple shell script that is more convenient to modify and deploy. The script below will do all the work to automate a zipped offline version.

```sh
#!/bin/sh

# Use : ./httrack.sh '' lprp.zip

HTTRACK=httrack
HTTRACK_OPTIONS="-q -%i -i -I0 -%I0 -o0 -%e0 -C0 -%P -s0 -%s -%u -N0 -p7 -D -a -K0 -c8 -%k -Q  -%l fr,en"
HTTRACK_URL=$1
HTTRACK_ZIP=$2

FOLDER=`mktemp -d`
DOMAIN=` echo $HTTRACK_URL |  sed -e 's|^[^/]*//||' -e 's|/.*$||' `

#Check temp folder (to not rm -Rf a false one then)
[ "$(ls -A "$FOLDER")" ] &&  echo "Temp Folder $FOLDER not empty !! $(ls -A $FOLDER)" && exit 1

# HTTrack
"$HTTRACK" $HTTRACK_OPTIONS "$HTTRACK_URL" -O "$FOLDER"  

# Add offline class
find "$FOLDER" -name '*.html' -exec sed -i 's/<body class="/\0offline /'  '{}' \;

# Zip file (cd to zip to avoid garbage folder names)
PWD=`pwd`
ABSOLUTE=$(cd $(dirname \"$HTTRACK_ZIP\"); pwd)/$(basename \"$HTTRACK_ZIP\")
cd "$FOLDER/$DOMAIN"
zip -r9 "$HTTRACK_ZIP" .
cd "$PWD"

# remove temp folder
rm -Rf "$FOLDER"

```