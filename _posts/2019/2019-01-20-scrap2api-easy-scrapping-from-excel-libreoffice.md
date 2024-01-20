---
post_id: 3985
title: 'Scrap2API &#8211; Easy scrapping from Excel / LibreOffice'
date: '2019-01-20T17:55:00+01:00'
last_modified_at: '2019-01-20T17:55:00+01:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=3985'
slug: scrap2api-easy-scrapping-from-excel-libreoffice
permalink: /2019/01/scrap2api-easy-scrapping-from-excel-libreoffice/
image: /files/2018/12/Scrap2API.jpg
categories:
    - Informatique
tags:
    - API
    - Excel
    - PHP
    - Scrap
lang: en
featured: 170
---

You may want to have in Excel some contents from the Internet. In some case, the basic functionalities of Excel / LibreOffice will be enough to get the data, but in most of the case, you will need more complex processing. So I wrote a simple script that will scrap the content with regular expression, xpath or css selector, and expose the results in a very simple API so that Excel / LibreOffice will be able to use it.

The script is available on [github.com/rpeyron/scrap2api/](https://github.com/rpeyron/scrap2api/) with full documentation.

A simple example to get the number of results of a google search with the different methods is provided (replace `/path-to/scrap.php` with the path where you have put the scrap.php script on your PHP webserver)

- See the result in your browser: `/path-to/demo/scrap.php/google-numresults-css/test?token=test`
- Get the result in Excel / LibreOffice, use formula : `=WEBSERVICE("/path-to/scrap.php/google-numresults-css/test?token=test")` or in French editions : `=SERVICEWEB("/path-to/scrap.php/google-numresults-css/test?token=test")`
- See the Swagger UI of the definition of the API : `/path-to/scrap.php/openapi-ui`

The script is also extensible through plugins, please refer to developer’s documentation.