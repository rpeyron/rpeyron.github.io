---
title: Migrate WordPress to Jekyll
lang: en
date: '2022-10-27 21:42:46 +0000'
image: /files/2022/09/migration-wordpress-to-jekyll/logo-jekyll.png
toc: true
categories:
- informatique
tags:
- jekyll
- website
- blog
- wordpress
- migration
- GitHub
modules:
- gallery
---

I had migrated [this site LPRP.fr to WordPress in 2018]({% link _posts/2018/2018-11-17-migration-vers-wordpress.md %}) and I was very happy with it on many topics, but still, only 4 years after this migration I have decided to move to [Jekyll](https://www.jekyllrb.com).

# Why?

I love WordPress on many aspects:
- Very simple to use
- Impressive community to get great plugins and themes
- Customizable easily in PHP

All these great features come with some drawbacks:
- I ended with more than 40 active plugins (and almost 10 inactive plugins for maintenance that I activate only when I need). Beside the generated complexity, it work quite well, but need frequent updates to avoid security exploits (almost 2-3 updates per day)
- Although I found some [offline extraction techniques]({% link _posts/2019/2019-01-02-offline-extraction-of-a-wordpress-site.md %}) it did not perform well and was not really useable as offline site
- Although I [installed many plugins to cache, minify, optimize, and added CloudFlare as CDN]({% link _posts/2021/2021-01-23-optimisation-de-wordpress-avec-cloudflare.md %}), it was much better, but still didn't perform very well on speed tests like Lighthouse
- It requires hosting, without free / long-term options, meaning that the site will disappear if for some reasons I am not able to maintain it myself.


# Install Jekyll

I will not explain much this part as it is well described in the [official installation documentation](http://jekyllrb.com/docs/installation/)

The only advice I can give is not to loose some time to use the ruby gems that may be included in your Linux distribution as you will run sooner or later in versions mismatch hell with the gems you will want to add. So just start with bundler as described in the documentation and everything will go smoothly.

On my debian:
```
sudo apt-get install ruby-full build-essential
gem install jekyll bundler
```

If you want later to update the gems you use, the command to use is:
```
bundler update
```

To create your site:
```
jekyll new myblog
cd myblog
bundle install --path vendor/bundle
# To build
bundle exec jekyll build --profile --trace
# To develop with autorefresh (and host exposition to be accessible outsite the localhost)
bundle exec jekyll serve --livereload --host 0.0.0.0 
```

# Migrate WordPress posts to Jekyll

I discovered only at the end of my migration that an official [WordPress importer](https://import.jekyllrb.com/docs/wordpress/) exists. So I won't described that, but you definitely should look at it first.

The solution I used is a WordPress plugin called [wordpress-to-jekyll-exporter](https://github.com/benbalter/wordpress-to-jekyll-exporter). It will export all your posts and files in a format and directory structure suitable for Jekyll. If your WordPress is not small, it is likely the plugin won't work if triggered by the admi panel, but you can run it by command line.

Just go inside the plugin folder (`wp-contents/plugins/wordpress-to-jekyll-exporter`):
```
php jekyll-export-cli.php > jekyll-export.zip
```
Be sure to have a command line PHP installed (`apt install php-cli`)

As this open source, it is very easy to modify it to fit exactly to your need, so I modified it to:
- export extra metadata (slug, last_modified_at,...) ans ignore useless ones (ocean_*,...)
- convert some wordpress tags I use, as [su_spoiler] and better code blocks support
- export polylang specificities
- convert image position to css classes
- force export to HTML  (I run export once in markdown, once in HTML, and replace markdown by HTML on some very specific pages)
- export comments (either in posts, in data file, or as github discussions for use with giscus - see below)

It is quite messy for the moment but I may take some time later to publish it on GitHub and propose a PR.


# Choose hosting mode

Before going further you must figure out what kind of hosting you want, as it will impact what is possible for themes and plugins. For now you have the choice between:
- Standard HTML hosting; no specific restrictions here, you will need to build your site with `jekyll build` command and serve the files oon a standard web server 
- GitHub built-in Jekyll hosting: you will only need to put your jekyll files in a GitHub repository and activate GitHub Pages and GitHub will take care of the rest and serve your files directly ; but this great ease comes with some limitations, as you only will be able to use themes and plugins whitelisted by GitHub ([see GitHub documentation for list and details](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/about-github-pages-and-jekyll))
- GitHub Pages with actions: it is kind of the best of both world, the principle is to put your source jekyll files in a GitHub repository, and configure a GitHub action to build your site and publish it to GitHub Pages, and be able to use any theme or plugin you want. There is even a default GitHub action template to help. GitHub actions is for now free so that sound the best options at this time. And the one I have chosen.


# Create layout

Then comes the time to choose and tweak the theme you will want to use. If you want to use GitHub built-in Jekyll hosting, the choice will be quite easy as there isn't many options. If you can use any theme, there is tons of it and you can find the best places to search on the [Jekyll themes page](https://jekyllrb.com/docs/themes/).

Personally I was quite happy with the current design of my [WordPress blog](), and choose to re-implement what was the result of the use of Ocean Wordpress customized theme, and many plugins.

Below was the screenshots of my WordPress site as of this migration:

- ![Home Page](/files/2022/09/migration-wordpress-to-jekyll/LPRP-WordPress-00-Accueil.png)
- ![Articles view on Home Page](/files/2022/09/migration-wordpress-to-jekyll/LPRP-WordPress-01-Articles.png)
- ![Blog view](/files/2022/09/migration-wordpress-to-jekyll/LPRP-WordPress-02-Blog.png)
- ![Article view](/files/2022/09/migration-wordpress-to-jekyll/LPRP-WordPress-03-Article.png)
- ![RPhoto page](/files/2022/09/migration-wordpress-to-jekyll/LPRP-WordPress-04-RPhoto.png)
- ![libxmldiff page](/files/2022/09/migration-wordpress-to-jekyll/LPRP-WordPress-05-libxmldiff.png)
- ![xmlTreeNac pag](/files/2022/09/migration-wordpress-to-jekyll/LPRP-WordPress-06-xmlTreeNav.png)
- ![Gallery page](/files/2022/09/migration-wordpress-to-jekyll/LPRP-WordPress-07-Galerie-1.png)
- ![Gallery Album view](/files/2022/09/migration-wordpress-to-jekyll/LPRP-WordPress-08-Galerie-2.png)
- ![Gallery Photo view](/files/2022/09/migration-wordpress-to-jekyll/LPRP-WordPress-09-Galerie-3.png)
- ![WordPress comments](/files/2022/09/migration-wordpress-to-jekyll/LPRP-WordPress-10-Comments.png)
{: .gallery .slide .gallery-thumbs .img-center .mw80 }


There is not much to say about the layout creation, everything is quite well [documented](http://jekyllrb.com/docs/layouts/) ; you will basically have to play with:
- The `_layouts` folder to define the main layout to use ; I created: default (common base), page (for pages), post (for posts), home-layout (for the home page), blog-layout (for the blog view), and archive (for auto-generated tags, categories and date pages generated by jekyll-archives plugin)
- The `_includes` folder to define reuseable widgets between your layouts (I created: header, footer, menu, menu-item, main-loop-card, sidebar, toc, favicon, cookies-consent, comments )
- The `_sass` folder to define your stylesheet parts with the SASS language ease
- The `assets` folder to define assets to be included (and the main.css that will include your saas parts)

There is no specific difficulties for this part for a frontend developed, what I am not. I got some help with [Kevin Powell YouTube videos](https://www.youtube.com/kevinpowell) that are quite useful and inspiring for use of CSS.

Some main choices I made:
- Use **modern CSS** without bothering too much with compatibility with old browsers, as nowadays, it is quite crazy unconscious to use an old browser and all browser includes auto-update features to get with latest version and security patches. I know a few percents will have a not optimal browsing experience, but still will be able to view the contents, and this few people will get lower and lower with the years
- Use **only standard CSS** without specific addition from browsers (like `--webkit-*` and so on) to have less compatibility issues along the years
- Full **responsive design** 
- Use pagination and infinite scroll to get more loading time performance

The main features or my layout:
- **All the basics**: responsive, dynamic menu, responsive images,...
- **Infinite scroll** (on multiple pages, but with only one pagination as the jekyll-paginate plugin generates)
- **Multi-languages** support: link to translations, filter translated articles, redirect, Google Translate untranslated,...
- **Modules** activated by front-matter: `bootstrap`, `jquery`, `owl-carousel`, `gallery`
- `Content-Security-Policy` management (even still too much `unsafe-inline` used)
- **GDPR** compliance (cookies consent, usage tracking with [Piwik Pro](https://piwikpro.fr/) that has been GDPR-compliant validated, and features like Google Translate activated only after consent to avoid personal data collected only with the inclusion of the javascript)
- **Full-text search** with javascript search loaded when needed (because we cannot process it server-side)
- **Redirects** to ensure URI compatibility over time (and yes, that is possible on GitHub Pages with a little bit of javascript, see below)

Of course as my site is on a public GitHub repository, you have access to the source of all above features if you want to see how it is done.

I took the opportunity to make some improvements o the Jekyll version:
- Blog view share the same design of card (one is vertical, the other horizontal)
- The whole site reactivity behave better, especially on high density screens
- There is a dark mode automatically selected depending on your browser settings
- Simplify the complex designs of RPhoto, xmlTreeNav and libxmldiff pages (from Elementor predefined layouts)


# Review posts

Maybe the longest and boring part of the migration is the little tweaks to be done to the automatic conversion. Indeed at some point it is quicker to do make changes manually than implement full complexity in the converter PHP script to handle some few specific cases.

I intensively used `git` for this part, as it is very useful to merge manual changes and new automatic conversion features. I use a `export` branch for automatically exported posts with the PHP script, and the `main` branch to make the manual changes. Merging the export branch in the main branch will keep the manual changes.

Markdown does not offer advanced styling possibilities, and that can be sometimes annoying for some simple things that centering an image, a disclaimer panel, a folding zone for extra details, etc.

But there is two good news:
- HTML is supported, so you can add extra style with HTML. Some markdown parsers allow a `markdown="1"` attribute to get markdown parsing inside the HTML. Be sure to leave one empty line between HTML and markdown.
- Many markdown parsers allow to add styles or attributes to the generated markdown elements with `{: <additions> }` tags. To add a class, use `{: .my-class }`, to add a id `{: #my-id }`, to add any attribute `{: my-attribute="my-attribute value" }`, and to you even can add inline custom CSS `{: style="float: right;" }`.

I tried to restrict my markdown specificities as low as possible:
- the less HTML possible : there is no point using markdown to do HTML ; Jekyll can use HTML pages, so if you want to do HTML, use HTML... I use HTML for folding features with `<details markdown="1"><summary>title</summary> ... </details>` and frames for very specific posts.
- the less styling possible, and to keep all the styles in one single SASS file to easily spot them
- for advanced features, the use of javascript libraries handled by the jekyll layout in the front-matter (as the gallery, the slider, the carousel,...)


# Plugins

You may have guessed that I love extending possibilities to best fit my needs, and jekyll ist quite extensible for that. You have so much possibilities to extend things:
- Use code snippets / includes (see [the Jekyll Codex](https://jekyllcodex.org/without-plugins/) for many useful resources without plugins)
- Use gems: there is some plugins lists like [the one from Planet Jekyll GitHub](https://github.com/planetjekyll/awesome-jekyll-plugins) or search GitHub with [`jekyll-plugin`](https://github.com/topics/jekyll-plugin)
- Add plugins in `_plugins/` folder
- Add javascript features to your layout

You will be able extend many things:
- Create new liquid tags or filter
- Generate new pages
- Alter content conversion
- Optimize the build speed

At the time of this article, the gems I use:
- `kramdown` as markdown converted with `rouge` as source code highlighter
- `jekyll-paginate` to create pagination for the post lists
- `jekyll-sitemap` and `jekyll-seo-tag` to generate sitemap and all the needed Search Engine Optimization (SEO) features
- `jekyll-fontawesome-svg` to include the awesome fontawesome icons in your site
- `jekyll-archives` to generate pages for tags, categories, years and months
- `jekyll-relative-links` to generate relative links
- `jekyll-admin` (which requires `webrick`)  to have a nice GUI for editing articles (see below)
- `jekyll_picture_tag` to generate responsive image sizes and formats (add needed dependencies with `apt install libvips libvips-tools libwebp6`)
- `jekyll-include-cache` to speed-up build time with cached include pages

I also have activated the gem `liquid-c` to speed up build process.

And the custom plugins I use:
- `array_intersection.rb` ([source](https://github.com/abelards/jekyll-array-intersect/blob/master/array_intersection.rb)) to add array_intersection filter that is very helpful for advanced liquid filters
- `fa_icon.rb` (adapted from `jekyll-fontawesome-svg` source code) to include svg without need of `fa_svg_generate` that is quite useful for cached include that won't be processed by `fa_svg_generate`
- `include_absolute.rb` ([source](https://github.com/tnhu/jekyll-include-absolute-plugin/blob/master/include_absolute.rb)) to include contents for anywhere of your source files (`include` liquid tags only search files in `_includes` without the possibilities to navigate outside)
- `md_link_relative.rb` ([adapted from this](https://ivovalchev.medium.com/jekyll-responsive-images-with-srcset-5da131415d0f)) to make markdown links work with baseurl (I don't understand why this is not in the standard Jekyll behavior...)
- `protect_code.rb` to avoid conflicts with liquid tags in code blocks
- `reading_time_filter.rb` ([source](https://github.com/risan/jekyll-reading-time/blob/master/reading_time_filter.rb)) to add reading time to post meta data
- `related_posts.rb` ([adapted from this](https://github.com/SimonBackx/related_posts-jekyll_plugin/blob/master/_plugins/related_posts.rb)) to get better related_posts based on tags and categories (the default one is only the latest posts, LSI is so slow, and give not really relevant results) ; I have also a liquid only version adapted from Jekyll Codex, but this should be faster.

For decent build time I suggest you think twice before using complex liquid algorithms or plugins that generates pages as it will grow your build time. To reduce the build time, some advice:
- Use `bundle exec jekyll build --profile` to see what is time expansive and you should focus on optimizing
- Use `jekyll-include-cache` ; that may need a little rework to get all variables in include scope, but it is really very effective to speed up things
- Try to reduce and split the page-specific part of widget or menus to benefit more from cache
- Use `jekyll serve --incremental` when developing to get faster updates
- Use `liquid-c` gem


# Add commenting system and redirects

The comment system is maybe the part that needed the most thinking, and still I don't have found the perfect solution. The requirements source of the dilemma:
- It is quite odd to want dynamic comments with a static site... but yes, comments are useful to get feedback and help readers with unclear parts of the article
- You don't want leaving a comment to be too difficult for users, but you also must anticipate that there will be a lot of spam, so systems based on e-mails must be avoided and user accounts are quite inevitable. Systems like wordpress comment system without accounts but with anti-spam from akismet is the smartest solution, bt I did not found an equivalent
- There isn't hosted commenting systems with free plans without advertising 
- There is quite good free self-hosted system, but it is not very consistent to strive to have your site non self-hosted and self-host your commenting system

But having decided to host my site on GitHub, there are a few solutions that use issues or discussions to handle comments. The one that seemed to me the most convincing at this time is [Giscus](https://giscus.app) that will store the comments as replies to a discussion that correspond to the page/post. Giscus offers also a way to embed all that very nicely in your page, and it is free. This come with some drawbacks: commenting will require that user have a GitHub account (quite easy to create on GitHub, and shouldn't be a problem for my readers given the topics I cover on this site), and to be able to embed nicely, it requires the use of the Giscus app ; I hope it will keep online and free on the long term.

Setting up Giscus is very easy as there is a form to generate the code to embed in your site with the options you want on [Giscus](https://giscus.app) 

I had a small problem with current version that does not have yet a good basepath support, so I made this [Pull Request](https://github.com/giscus/giscus/pull/739)

Giscus does not come with a system to migrate existing comments to GitHub discussions, and that is quite logical in a way because it cannot impersonate the original authors of the comments, but still I wanted to keep history. There is also the option to include statically the WordPress comments, but it wouldn't have had the same design as newer, and it will not be shown in the GitHub discussion.

So I figured out a way to migrate comments by adapting the `wordpress-to-jekyll-exporter` PHP plugin to export comments, and make some GraphQL calls to GitHub to create the comments as discussion replies. I will make soon a dedicated post to cover that topic.


# Author with jekyll-admin and _config_dev.yml

I must say that WordPress has a very nice authoring experience, and that I am not a full command line addict guy... VSCode is a quite decent editor for markdown articles to be included in a Jekyll site with code spell and other plugins, but I was quite happy to discover the gem [`jekyll-admin`](https://github.com/jekyll/jekyll-admin) which offer a decent editor interface to edit your markdown posts.

It is very simple to set up:
1. Add the `jekyll-admin` gem
2. Serve your jekyll site with `bundle exec jekyll serve  --livereload`
3. Navigate on `/admin` (eg http://localhost:4000/admin)

Be sure to secure or not expose this path.

You may also want to have specific settings for your development experience. To avoid to duplicate your `_config.yml` you can create a specific one that will be merged after:

1. Create `_config_dev.yml` 
    ```
    # Override settings for dev mode
    title: '[dev] LPRP.fr'

    # Remove generation of archives in development to speed up things
    jekyll-archives:
    enabled: []

    show_drafts: true

    jekyll_admin:
    homepage: drafts
    ```

2. Run with `bundle exec jekyll serve  --livereload --incremental --drafts --profile --config "_config.yml,_config_dev.yml" --host 0.0.0.0`

Also if you run your site with a base path (the case on GitHub if you don't use the default user repository), you will need:
- to be sure that all your layouts and includes take care of adding `{{  site.baseurl }}` in front of every path, or use the filter `| relative_url` (avoid the latter in cached includes as it won't work if all your pages are not on the same folder structure)
- to append `-b <your-base-path>` to your build or serve command



# Comparing Lighthouse speed tests

At this time of reading, due to the size of this post you may have forgotten why we run into this process, and a part of it was speed performance. So let's see the result of the Lighthouse scores.

| Lighthouse WordPress Mobile scores | Lighthouse Jekyll Mobile scores |
| ![Lighthouse WordPress Mobile scores](/files/2022/09/migration-wordpress-to-jekyll/Lighthouse_WordPress_Mobile.png) | ![Lighthouse Jekyll Mobile scores](/files/2022/09/migration-wordpress-to-jekyll/Lighthouse_Jekyll_Mobile.png) |
| --- |
| Lighthouse WordPress Desktop scores | Lighthouse Jekyll Desktop scores |
| ![Lighthouse WordPress Desktop scores](/files/2022/09/migration-wordpress-to-jekyll/Lighthouse_WordPress_Desktop.png) | ![Lighthouse Jekyll Desktop scores](/files/2022/09/migration-wordpress-to-jekyll/Lighthouse_Jekyll_Desktop.png) |
{: .center}


# More articles to come

As this post is already very long, and that some topics may be useful outside my personal migration process, I forecast some more articles to zoom on these topics:
- Redirects for GitHub Pages  and for WordPress direct page links
- Migrate WordPress comments to Giscus
- Multi-language Jekyll

Stay tuned!
