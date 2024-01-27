---
title: Top viewed posts in Jekyll with Piwik
lang: en
tags:
- Jekyll
- Piwik
- Javascript
- Site
- Web
categories:
- Informatique
date: '2024-01-27 16:52:00'
image: files/2024/jekyll-top-articles.jpg
---

Static site generators are cool to make simple, efficient and easy to host websites, but obviously not able to realize dynamic features. As it cannot be implemented server-side, the only way to implement such feature is to do it browser-side with some JavaScript.

I have already done that for:
- [redirects on Github Pages]({{ '/2022/11/redirects-on-github-pages/' | relative_url }})
- [dynamic multi-language]({{ '/2022/12/multi-language-jekyll/' | relative_url }})
- the search feature on this site (no dedicated article, but will be explained in this one)

# Principle

One feature I was using on my previous site engine (WordPress) was the top viewed articles. It is obviously not possible with only Jekyll and JavaScript, but if you use some website usage analytics it is possible to get data and add it with some JavaScript to your static website. As website usage analytics solution, I use [Piwik Pro](https://piwikpro.fr/), a cloud solution implementing the open source matomo, free for my low-traffic, and respectful of GPDR.

So we will have to write some JavaScript that will:
- retrieve the latest data from usage statistics
- create the content to display those data

# Setting up a public report
Analytics solutions will offer to access data with an API, which is very cool. But most of the time, it will require an API key/token, and because the script we make will need to be run at browser side, that would be the same as giving the key publicly, and with it, a malicious user will be able to access and manage all your analytics account, so do not do that!! 

With Piwik / matomo, you are able to create some public reports. The generated URL will be accessible to all, but only on the data you have chosen to include in this report. It is not quite what we are looking for as it is a web page, but if we dive a little closer in the way this page work, it is built as a web application that will fetch the data as JSON on a URL encoded as parameter of the application. Perfect!

To create the public report in Piwik Pro:
- create a custom report
- add dimension Page title and dimension Page URL (and other dimensions if you need extra information of the page)
- add metric events
- add filter Event type dimension is "Page view"
- save and share as public URL

The URL will look like `https://lprp.piwik.pro/analytics/#/sharing/aHR0cHM6Ly[...]YuanNvbg==/`  ; the first part is the URL of the web application, and the obscure last part is the base64 encoded URL of the JSON data `https://pp-core-gwc.piwik.pro/blobs/shares/QbwZ6nzfJNzyF9V8bgHFPF.json` and the data will look like:
```json
{
   "reportData":{
      "data":[
         {
            "event_title":"M\u00e9thode pour r\u00e9cup\u00e9rer des cartouches d\u2019imprimante s\u00e8ches (super bizarre) | LPRP.fr",
            "event_url":"https://www.lprp.fr/2019/08/methode-pour-recuperer-des-cartouches-dimprimante-seches-super-bizarre/",
            "events":206
         },
         {
            "event_title":"Piloter votre domotique avec Alexa gr\u00e2ce \u00e0 ha-bridge + Domoticz ou Tasmota | LPRP.fr",
            "event_url":"https://www.lprp.fr/2022/08/piloter-votre-domotique-via-alexa-grace-a-ha-bridge-domoticz-ou-tasmota/",
            "events":109
         },
         ...
      ],
      "totals":{ "events":1966, ...  },
      "count":185
   },
   "reportConfig": ...
   "siteData": ...
   "startDate":"2023-12-21T12:08:16.911Z",
   "endDate":"2024-01-19T12:08:16.911Z",
    ...
}
```

We now have the data we need to be used in our Jekyll site!

# The javascript script to create the most viewed list
The script is quite straightforward, and I have created it as include in _includes/piwik-top.html
```liquid
{% comment %}<!--
Add data URL domain to your CSP connect-src (if any), eg: connect-src *.piwik.pro;

Parameters:
- tableSelector (required): the CSS selector to the table in which the entries should be added (current content will be replaced)
- dataUrl (required, optional if reportUrl given): URL of JSON data to be fetched
- reportUrl (optional): URL of the public Piwik report
- showSelector (optional): the CSS selector to element to show when data have been loaded
- itemClassList (optional): the class list added to div items
- itemCount (optional): the max number of elements to be displayed (only if the report display more)

Implementation notes:
- data structure is .reportData.data[].event_title / .event_url / .events
- data url = atob(public report url last part)

-->
{% endcomment %}

<script>

    let config = {
        reportUrl: "{{ include.reportUrl | default: site.piwik.topArticles }}",
        dataUrl: "{{ include.dataUrl }}",
        showSelector: "{{ include.showSelector }}",
        tableSelector: "{{ include.tableSelector }}",
        itemClassList: "{{ include.itemClassList | default: 'top-post-title' }}",
        itemCount: "{{ include.itemCount | default: undefined }}"
    }

    if (config.dataUrl == "" && config.reportUrl != "") config.dataUrl = atob(config.reportUrl.split("/").slice(-2)[0])

    if (config.dataUrl) fetch(config.dataUrl).then(async (response) => {
        let json = await response.json()
        if (json && json.reportData && json.reportData.data && Array.isArray(json.reportData.data)) {
            // Add elements to table
            document.querySelectorAll(config.tableSelector).forEach(tableElement => {
                tableElement.innerHTML = ""; // Clears current contents
                json.reportData.data.splice(0,config.itemCount).forEach(d => {
                    let div = document.createElement("div")
                    div.classList = config.itemClassList.split(" ")
                    let a = document.createElement("a")
                    a.href = d.event_url
                    a.title = d.event_title
                    a.innerHTML = d.event_title.split('|')[0] + " <span class='num'>(" + d.events + ")</span>"
                    div.appendChild(a);
                    tableElement.appendChild(div)
                })
            })
            // Show element
            if (config.showSelector) document.querySelectorAll(config.showSelector).forEach(e => e.style.display = "block")
        }
    })
</script>
``` 

It will:
- load the data
- add in the provided element selected with tableSelector  the first entries with itemClassList classes to be styled ; the item will have the post title and be linked to the post
- and if you want to hide the content before it is loaded, it will display the item selected by showSelector if everything have gone well

You will be able to see the result on the right of my  [blog page]({{ '/blog-en/' | relative_url }}) 

# Going a step further with the top articles cards

If you also want to display those results as cards, the above principle can be extended and use the same technique as the one used to my [search page]({{ '/search/' | relative_url }}) :
- a Jekyll page will generate a single page with all the possible cards (in my case, the same as the one used for the search feature)
- a JavaScript script will fetch the top articles data and sort the cards accordingly (and hist he one you don't need)

It is only feasible on a relatively small site as mine with not many posts. If you need to operate on numerous posts, you can generate a Jekyll card for each page and fetch only the ones you need.

You will be able to see the result [on my home page, with the Top viewed option ]({{ '/home' | relative_url }}) 

-
