---
post_id: 4014
title: 'WordPress &#8211; Issue with latest Redirection update and SQLite Integration'
date: '2019-03-09T20:48:38+01:00'
last_modified_at: '2021-06-12T19:30:16+02:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=4014'
slug: wordpress-issue-with-latest-redirection-update-and-sqlite-integration
permalink: /2019/03/wordpress-issue-with-latest-redirection-update-and-sqlite-integration/
image: /files/2018/10/wordpress_1540683760.jpg
categories:
    - Informatique
tags:
    - Wordpress
lang: en
---

I had some issue after upgrade the Redirection plugin to 4.0. Redirections were not working anymore and I was unable to add some (with ugly “something went wrong” and a 500 API error code). It turned out that was because an incompatibility of the database upgrade with the SQLite Integration plugin : the database upgrade uses many keywords unknown to SQLite (“AFTER” keyword in ALTER TABLE, “SUBSTRING\_INDEX” and “LEFT” functions)

To fix this I fixed the “AFTER” keyword in the SQLite Integration plugin. Here is the corresponding (very simple) Pull Request : <https://github.com/aaemnnosttv/wp-sqlite-integration/pull/2>

To force the Redirection plugin to update the database I updated the “redirection\_options” in the table “wp\_options”. In the option\_value field you will find the serialized options, and in it the snippet “`s:8:”database”;s:3:”4.0″` ” (my database was in version 4.0) ; I updated to the version 2.0 (“`s:8:”database”;s:3:”2.0″` “) to be sure to get all the database evolutions, but you may start after that.

As the replacement of the missing SQLite functions was more difficult to handle, I updated the Redirection SQL code to update to the new database and executed it manually in my SQLite database :

```plsql
UPDATE wp_redirection_items SET regex=0 WHERE regex="";
UPDATE wp_redirection_items SET match_url=lower(url) WHERE regex=0;
UPDATE wp_redirection_items SET match_url=substr(match_url,0,instr(url,'?')) WHERE regex=0 AND match_url like '%?%';
UPDATE wp_redirection_items SET match_url=substr(match_url,0,length(match_url)) WHERE match_url like '%/' AND match_url <> "/";
UPDATE wp_redirection_items SET match_url="/" WHERE match_url = "";
```

Redirection is working fine now, handles redirections properly and let me adds some more again !