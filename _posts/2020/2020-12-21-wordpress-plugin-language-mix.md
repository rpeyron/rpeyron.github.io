---
post_id: 5159
title: 'WordPress plugin Language-Mix'
date: '2020-12-21T12:04:07+01:00'
last_modified_at: '2020-12-21T12:14:28+01:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=5159'
slug: wordpress-plugin-language-mix
permalink: /2020/12/wordpress-plugin-language-mix/
image: /files/2020/12/globe-world-languages-stockpack-pixabay-scaled.jpg
categories:
    - Informatique
tags:
    - Plugin
    - Wordpress
    - language-mix
    - polylang
lang: en
---

I am using the great plugin [language-mix](https://wordpress.org/support/plugin/language-mix/) for quite a while and having the same need described by the author the feature request “[Group posts / show only the primary article](http://projects.andriylesyuk.com/issues/2276)“. Even if polylang pro has a feature to overcome this, I was not happy with buying the license for a small personal blog, and also not happy with the solution that involves many post duplication.

So I implemented it. It works by building an exclusion list of posts that are translated in the least wanted language to keep only the most wanted translation. This list is given to the query. By doing so, it will behave ok with pagination. The exclusion list is cached if the site does implement a persistent object cache.

I also added a settings page, to allow to customize the way the best language will be chosen, and enabling/disabling some features. It is so possible to set the original behavior of the plugin, or use the new features.

![](/files/2020/12/wordpress-language-mix-options.png){: .img-center}

The GitHub repo for this new version : <https://github.com/rpeyron/wordpress-language-mix>  
The WordPress new version announcement: <https://wordpress.org/support/topic/new-version-implemented-show-only-the-primary-article/>

Many thanks to [Andriy Lesyuk](http://projects.andriylesyuk.com/project/wordpress/language-mix) for this great plugin (and for making it open source)