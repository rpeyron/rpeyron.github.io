---
title: View your website locally without environment
date: '2022-11-12 20:06:36'
lang: en
tags:
- Jekyll
- offline
- Website
- miniweb
- GitHub
categories:
- Informatique
image: files/2022/miniweb.png
---

You may want for some reasons to see your website outside its deployment environment, for instance to see an older version. There are full-featured WAMP/LAMP servers with all the tools needed, and I used for my WordPress years the great MicroApache that bundle Apache+PHP+SQLite in less than 1 Mb. But as I am now using Jekyll which generate static files, I wanted an even lighter solution.

The problem is that to replicate the same URL as in WordPress, all links to articles like `"/2022/11/my-article/"` are implemented as `index.html` files in a `/2022/11/my-article/` folder. But with running on a local folder, web browser won't search index files in a folder but display the content list of the folder. So the static site will not work directly in a browser. My website uses also absolute links that will not work in the browser, even if we solve the `index.html` issue.

# Extract an offline version

I first wanted to write some scripts to add index.html to links and try the `<base>`tag to solve relative and absolute URLs, but it turned to be not so simple and web extractor exists exactly for that. So I use httrack to extract the site:

```shell
httrack http://localhost:4000  -O "./LPRP.fr" -r
``` 

It takes some times but works OK.

If you use srcset, it won't be downloaded and replaced. There is an [additional script to run on the httrack forum](https://forum.httrack.com/readmsg/36162/33879/index.html) to remove these srcset and use the img that is correctly handled. If you intend to use this on regular basis, you may want to integrate that as postprocessing plugin that will disable srcset or picture tag. You will find an example to adapt on my previous [post about WordPress offline extraction]({% link _posts/2019/2019-01-02-offline-extraction-of-a-wordpress-site.md %})

# Small local webserver

Another possibility is to simply use a web server. There is now lots of possibility of local web servers such as in npm (`npx http-server [path] [options]`)  or python (`python -m SimpleHTTPServer 8080`), or some powershell alternatives but it implies always installing or downloading large requirements. 
Hopefully there are small portable web servers that are even lighter than the MicroApache I used.

The lightest I found is [miniweb](https://github.com/avih/miniweb), with only 53kb! 
If you use some SVG files on your site you may have some problems as miniweb does not have the SVG MIME type for now. I made a [PR](https://github.com/avih/miniweb/pull/17) and a [windows binaries release with the modifications](https://github.com/rpeyron/miniweb/releases/tag/2202-11-12-svg).

You may then create a helper batch file in the same folder to start with the good folder name and open the browser on the good URL:

```batch
start miniweb -p 4242 -r _site
start "" http://localhost:4242
```

If you need SSL, there is [Rebex Tiny Web Server ](https://www.rebex.net/tiny-web-server/) that will manage https and all the certificate stuff for you in only 3.5 Mb.
