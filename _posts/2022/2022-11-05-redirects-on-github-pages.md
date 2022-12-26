---
title: Redirects on GitHub Pages
image: files/2022/GitHubPagesRedirections.png
date: '2022-11-05 13:41:32'
tags:
- GitHub
- Jekyll
- Redirection
- Javascript
categories:
- Informatique
lang: en
---

I have recently migrated my website on Jekyll hosted by GitHub Pages. As always, redirects are a good thing to avoid 404, and I have a bunch from the very first version of my website.  However, GitHub Pages is not a webserver like Apache or NGINX and there is no settings about redirects. And if you search internet about the redirect possibility, you will mainly see "not possible" as answers. But it is possible with a little Javascript to emulate some redirects.

The principle is to inject some javascript in our pages that will take care of detecting the asked URL with `document.location`  and if needed, load the redirected page. We need to handle two different kinds of redirections:
* on existing pages like `/?p=1234` _(WordPress page id method)_ : the page `/` does exist, but we want to redirect based on `?p=1234` query string, so we will need to inject our javascript in the source code of the page `/`
* on non-existing pages like `/this-page-does-not-exists/` _(common case of redirects for renamed pages)_ : we cannot inject as above in the existing page ; hopefully GitHub Pages will serve a special page `/404.html` that we may customize while keeping `document.location` with the asked page.

# Query Strings
As in this case we are operating in a page that is not dedicated to redirects, we will split our script in two parts to avoid unnecessary data loading if no redirect is needed.

The first part to include in the page will check if we need to check if a redirect exists, and if it is the case, will load the second script.
```
<script>
  if (document.location.search.startsWith("?p=")) {
    const script = document.createElement('script');
    script.src = "{{ site.baseurl }}" + '/assets/redirect.js';
    document.body.append(script);
  }
</script>
```

The second part is the definition of the `/assets/redirect.js` script that will:
1. detect the asked page with the querystring (`document.location.search`) 
2. search in the data if we have a target for that querystring
3. if found, perform the redirect with setting the new `document.location.href`

As this patterns uses the post_id from WordPress, we will generate our redirection table with  our posts metadata in liquid language and give as permalink the url we use in the first script.

The resulting script is quite simple (to be saved in something like `/redirect-js`):
```javascript
---
layout: null
permalink: /assets/redirect.js
sitemap: false
---

var redirects = {};

{% assign all_posts = site.posts | concat: site.pages %}
{% for page in all_posts %}
{% if page.post_id %}
redirects["{{page.post_id}}"] = "{{ page.url }}";
{% endif %}
{% endfor %}

function redirect() {
    var to = null;
    var loc = document.location.search;
    if (loc.startsWith("?p=")) {
        loc = loc.replace(/^\?p=/,'');
        to = redirects[loc];
    }
    if (to) {
        var fullTo = document.location.origin + "{{ site.baseurl }}" + to;
        if (document.location.href != fullTo) {
            console.log("Redirect to: ", to, fullTo);
            document.location.href = fullTo;
        }
    } else {
        console.log("Redirect target not found")
    }
}

redirect()
```

# 404 Page
For this second method we will need to create a custom `/404.html` page that will perform the same steps as the previous method. As this is a page dedicated to not found pages, we do not need to split in two parts. What is nice is that even if the page has not been found and `404.html` served instead, the browser has still the requested url in `document.location` so we can use that in javascript.

And as I am migrating from the Redirection plugin of WordPress hosted by Apache, I will get my redirect data from parsing the exported `.htaccess`file.

The resulting script below has three parts:
- first part is what will displayed to the browser if there is no redirection with some styles and text
- second part is the injection in liquid of the .htaccess file in a javascript variable
- third part is the function to parse the .htacess data
- fourth part is the redirect functions ; note that will resolve at once multiple redirects (obviously you will need to take care no to have redirection loops in your file)

```
---
permalink: /404.html
layout: default
---

<style type="text/css" media="screen">
  .container {
    margin: 10px auto;
    max-width: 600px;
    text-align: center;
  }
  h1 {
    margin: 30px 0;
    font-size: 4em;
    line-height: 1;
    letter-spacing: -1px;
  }
</style>

<div class="container">
  <h1>404</h1>

  <p><strong>Page not found :(</strong></p>
  <p>The requested page could not be found.</p>
</div>

<script>
var htaccess = `
{% include_absolute '.htaccess' %}
`;


function extract_htaccess_redirects(htaccess) {
  const regex = /RewriteRule\s*([^\s]*)\s*([^\s]*)/gm;
  
  var redirects = {};
  var lines = htaccess.split(/\r?\n/);
  for (line of lines) {
    m = regex.exec(line);
    if (m) {
      redirects[m[1]]=m[2];
    }
  }

  return redirects;
}

var redirects = extract_htaccess_redirects(htaccess);

function findRedirect(redirect) {
  // redirects[redirect];
  var found = Object.entries(redirects).find( v => redirect.match(new RegExp(v[0])) ? v[1] : null);
  return (found) ? found[1] : null;
}

// Avoid infinite redirects
if (!document.location.hash.includes("redirected")) {
  var page = document.location.pathname.replace("{{ site.baseurl }}/", "");
  var redirect = findRedirect(page);
  while (redirect && (found = findRedirect(redirect))) redirect = found;
  if (redirect) {
    var fullTo = document.location.origin + "{{ site.baseurl }}" + redirect + "#redirected";
    document.location.href = fullTo;
  } else {
    console.log("Not found", page, redirect, {redirects, htaccess});
  }
} else {
  console.log("Already redirected, not good.")
}

</script>
```

That's it!  Now you know that there are some tricks to perform redirects on GitHub Pages even if it is not theorytically possible!
