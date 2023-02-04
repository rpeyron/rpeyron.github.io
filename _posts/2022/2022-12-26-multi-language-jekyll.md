---
title: Multi-language Jekyll
toc: true
date: '2022-12-26 18:13:16'
image: files/2022/09/migration-wordpress-to-jekyll/logo-jekyll.png
categories:
- Informatique
tags:
- Jekyll
- Javascript
- Multi-language
- Google
- Translate
- Liquid
- Website
lang: en
---

In the migration process of my website from WordPress to Jekyll, I had to deak with some multilanguage. I usually write in english what is susceptible to interest a large worldwide audience (like some article on jekyll), in french what is mainly targetted on french users or topics already widely covered in english, and translate both in english and french only popular contents (or old ones, when I had more time)

# Needed features

In my WordPress setup, the following features were working:
- multiple languages for posts, using [Polylang](https://polylang.pro/) plugin ; the principle of Polylang is to have separate post for each translation, and to add some links between them, so it is very flexible to translate only some posts
- Polylang is also capable of auto-selecting the language based on the browser setup (this feature was deactivated by the use of Cloudflare caching regardless of browser language)
- Polylang adds a language menu with available translations of a post so that the user can select the one he prefers
- Polylang also translates menus, theme strings, categories, tags, etc.
- by default, Polylang will display only the posts of the current selected language, and that is a problem because I have no time to translate all posts, but it is still useful to list the untranslated ones, because now most of French internet visitors of my site are likely to undestand english, and english visitors of my site can use Google Translate on french posts ; there is a nice Wordpress plugin [language-mix](https://wordpress.org/plugins/language-mix/) to be able mix posts of different language
- Still, language-mix won't deduplicate translated posts, and display both posts, so I [forked the plugin](https://github.com/rpeyron/wordpress-language-mix) to select the best translation for a post and hist the others ; the plugin is not perfect as it won't play nicely with pagination, but with infinite scroll it is not a problem
- And to finish with, the plugin Google Translate was integrated to be able to use directly Google Translate 

# Jekyll multi-language basics

Jekyll is not language aware out of the box, but there are a lot of good solutions based on plugins to add multiples language management. But none of those I found was meeting my requirements, so I decided to create my own system.

I kept the principles I used to have with Polylang in WordPress:
- there is one distinct post for each translation
- they are linked together with front-matter properties:
  - `lang`property is used to specify the current language of the post
  - `lang-ref`property is used to identify all the translations belonging to the same posts ; all posts with same `lang-ref` should be considered as translations of the same posts
  - `lang-translations` property is an associative array that lists all translations _(lang: translation slug)_ ;  it is fully deductible from `lang`and `lang-ref` but simplifies and speeds up things to resolve translations ; as I am not using that much translated pages (and most of them are automatically migrated from WordPress), I decided to keep also this system for the new pages, and may replace that by a plugin if needed

I decided to simplify the complex Polylang system to translate categories and tags : posts will be associated to only one common list of categories and tags, currently untranslated, but I may very easily add a data file to provide some translations for categories and tags.

# List translations in the menu

It is then quite easy to add translation support in the template, for instance to list available translation in the menu:
```liquid
{%- for lang in include.lang-translations -%}
{%- if lang[0] != include.curLang -%}
{% assign translated_post = all_posts | where:"slug", lang[1] %}
<a class="link-menu" href="{{- site.baseurl -}}{{ translated_post[0].url }}#lang={{ lang[0] }}">
    {% assign lang_id = lang[0] %}
    <img class="lang-flag" src="{{- site.baseurl -}}{{- site.data.langs[lang_id].flag -}}" alt="{{- lang[0] -}}"></img>
</a>
{%- endif -%}
{%- endfor -%}
```

It will simply loop trough `lang-translations` and display links. I have added a data file langs.yml to specify language data as name and picture:
```yaml
fr:
  id: fr
  name: Français
  flag: /assets/img/fr.svg
  date_format:  "%d/%m/%Y"
en: 
  id: en
  name: English
  flag: /assets/img/gb.svg
  date_format:  "%b %-d, %Y"
```

# Translate theme strings

As I want to use the browser's language settings or the user choice, there are only two solutions to do that:
- generate on server side all possible pages, and even if the post is not translated, a generated one for each language with the template serving only the translated strings ; it is the cleaner scenario from the client side perspective, as only the translated contents will be transferred, but at the cost to extra site complexity, longer generation times, larger site storage to have for lots of nearly duplicated pages
- serve all the language strings and do the selection on the client side ; as there are very few theme strings to translate (menu, some structure texts, etc.) that is the solution I have chosen

The principle is very simple, and based on CSS, a class will be generated for each language, and only the one selected by the browser will be displayed. For instance:
```html
        <h1>
            <lang class="lang-fr">Etiquettes</lang>
            <lang class="lang-en">Tags</lang>            
        </h1>
````

Both languages are included in the webpage, but some CSS will select the language you want to display. To select the french language, you only have to provide the browser with a CSS that hide `.lang-en`class, and to select english, to hide `.lang-fr`class with a simple CSS:
```css
.lang-fr { display: none }
```

It will then be possible to dynamically change the CSS or the class visibility depending on client side preferences.

And for search engines to be aware of the language, the post language is added in the generated page; in the default template:
```liquid
{%- assign lang = page.lang | default: site.lang | default: "en" -%}
<html lang="{{ lang }}">
```



# Select cards that match the current language 

The same principle goes for card selection. As defined in the requirements, we also want to display untranslated posts. So we will add a new `.lang_untranslated` class that we exclude from our hiding CSS:
```css
.lang-fr:not(.lang_untranslated) { display: none }
```

And in the card generator, we will generate the corresponding class in the posts' cards:
```liquid
<article id="{{include.post.url}}" class="card 
   {%- if include.post.lang %} lang-{{ include.post.lang }} {% endif -%}
   {%- if include.post.lang-translations -%}
   		{%- for lang in include.post.lang-translations %} lang_translated-{{ lang[0] }} {% endfor -%}
   {%- else %} lang_untranslated {% endif -%}
	">
```

We then generate the default CSS to select current page language:

```liquid
{% assign curLang = page.lang | default: site.lang %}
<style>
    {% for lang in site.data.langs %}
    {% assign langid = lang[0] %}
    {% if langid != curLang %}
    .lang-{{ langid }}:not(.lang_untranslated)  {
        display: none !important; 
    }
    {% endif %}
    {% endfor %}
</style>
```

There are some drawbacks with this method:
- You will transfer data that will actually be hidden  ; it may be acceptable if you have only a low percentage of translated contents that will be hidden, but if not, you should really consider another method
- It won't play nicely with pagination, as the pagination will always output the same number of posts regardless their translation status. So if you have a page size of 10, and you have 2 posts that are translated with a total of 2 languages, you will display at the end only 8 of the 10 posts paginated. And if your layout is designed for 10 items, you will have some "holes" that may confuse the user that will see a page as if it has no more article event if it is not the last page ; a simple workaround is to use infinite scroll and a fully responsive layout.

It is also useful for pages generated by `jekyll-archives` and also for my client-side javascript full text search based on lunr, and a special page with all the text from all the pages, and all the cards of the site. The page is very heavy, so you will need to load it only when required, and with some loading spinner. As it is not complicated you can have a look at my [GitHub](https://github.com/rpeyron/rpeyron.github.io/blob/main/search.html) to see how it works.

# Auto redirects based on browser's language

To achieve that, we will require some javascript. Note that until now, your site will display nicely if your viewer has deactivated javascript. With the below javascript it will still be rendered OK, the user won't simply be redirected.

So somewhere in your default template:
```js
<script type="text/javascript">
let curLang = "{{ include.curLang }}"
let pageTrans = {
    {%- for lang in include.lang-translations -%}
    {%- assign translated_post = all_posts | where:"slug", lang[1] -%}
    '{{ lang[0] }}':'{{- site.baseurl -}}{{ translated_post[0].url }}', 
    {%- endfor -%}
};

let navLangs = [navigator.language]; // Use navigator.langages to match all browsers langages
// navLangs = [...navLangs, ...navigator.languages];
navLangs = navLangs.map(lang => lang.split("-")[0]); // Keep only first part of langage
let navLang = navLangs[0];
let navLangFiltered = navLangs.filter(value => ((value == curLang) || (Object.keys(pageTrans).includes(value))))

function detectIfRedirectNeeded() {
  if ((navLangFiltered.length > 0) && (navLang != curLang) && (!document.location.hash.includes("lang"))) {
    document.location.href = document.location.origin + pageTrans[navLang]
  }
}

detectIfRedirectNeeded();
</script>
```

The liquid part will generate in javascript the list of available translations so that the client javascript will be able to interpret the `navigator.language` variable with the browser settings, and redirect if needed.



# Add Google Translate

With all that, adding Google Translate is quite easy:

In your template:
```html
<!-- Google Translate is not loaded and not shown before cookie consent -->
<div id="menu-google-translate" class="link-menu menu-google-translate" style="display:none">
    <img class="lang-flag img-google-translate" alt="Google Translate" title="Google Translate this page" src="{{- site.baseurl -}}{{ '/assets/img/google_translate_logo.svg' }}" onclick="startGoogleTranslate()">
    <div id="google_translate_element"></div>
</div>
```

In your javascript:
```js
function startGoogleTranslate() {
  // Load Google only when asked
  var script = document.createElement('script');
  script.src = "//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit";
  document.head.appendChild(script); //or something of the likes
  document.querySelector(".img-google-translate").style.display = "none";
  document.querySelector(".lang-cur-menu").style.display = "block";
}

function googleTranslateElementInit() {
  new google.translate.TranslateElement({
      pageLanguage: curLang,  
      layout: google.translate.TranslateElement.InlineLayout.SIMPLE,
      autoDisplay: true,
      // gaTrack: true, gaId: 'UA-xx'
    }, 'google_translate_element');
  doGTranslate(navLang +  '|' + curLang);
}

function detectIfGoogleTranslateNeeded() {
  if (navLangFiltered.length > 0) { 
    // If we have a translation for the browser langage we mask google translate
    document.querySelector(".menu-google-translate").style.display = "none";
  } else {
    document.querySelector(".menu-google-translate").style.display = "";
  }
}

// Move this out and in your GDPR code to detect and load  Google Translate only if accepted
detectIfGoogleTranslateNeeded();
```

Also, please note that Google may include in the Google Translate library some non GDPR compliant contents (and use cookies), so it is safer to include the file only once the user has accepted this feature. You will only have to move the 

That's it for now! There are still some missing features as giving the user the possibility to select its favorite language and store that, but as it is exactly the purpose of the browser's preference, I haven't taken the time to do it.
