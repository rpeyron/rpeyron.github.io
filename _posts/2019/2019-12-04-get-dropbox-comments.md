---
post_id: 4155
title: 'Get Dropbox comments'
date: '2019-12-04T21:46:56+01:00'
last_modified_at: '2019-12-04T21:46:56+01:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=4155'
slug: get-dropbox-comments
permalink: /2019/12/get-dropbox-comments/
image: /files/2019/12/dropbox.png
categories:
    - Informatique
tags:
    - Dropbox
lang: en
---

The comment feature is very handy on dropbox documents, but there is no functionality to export them, and no API to use them. Fortunately, it seems it exists an undocumented /comments2/list\_comments API. I made a proof of concept of this API to get the ability to exports comments.

The HTML dropbox application uses a /comments2/list\_comments API that gives us what we want. You need a proper authentication and the id of the file you want to see.

The application is very straight forward, uses the Dropbox Chooser to pick a file and allow the user to download comments. Below it a screenshot and here is the github repository with full source code and some documentation : <https://github.com/rpeyron/dropbox-comments-downloader>

![](/files/2019/12/dropbox-comments-downloader.jpg){: .img-center}