---
post_id: 4110
title: 'JSweet &#8211; Convert applets to javascript'
date: '2019-08-21T16:58:59+02:00'
last_modified_at: '2019-08-21T17:12:30+02:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=4110'
slug: jsweet-convert-applets-to-javascript
permalink: /2019/08/jsweet-convert-applets-to-javascript/
image: /files/2019/08/jsweet-logo-full.jpg
categories:
    - Informatique
tags:
    - Contrib
    - Java
    - Javascript
    - Prog
lang: en
---

[JSweet](http://www.jsweet.org/) is a tool that can convert java to javascript. I have in 2001 written a couple of Java applets that don’t work anymore with the disappearance of java applets from browsers. I decided by curiosity to look at JSweet to convert those applets in javascript, and that was not that easy.

JSweet has an [online converter](http://www.jsweet.org/jsweet-live-sandbox/) that is quite easy to use, but it uses only the basic libraries of JSweet (JSweet core and J4TS). Unfortunately, it does not include AWT and Applet functionalities needed to migrate an applet. JSweet has a good software architecture with the ability to add extra Java language features that JSweet call “candies”. And there is quite a bunch of “candies”, with one for AWT that is called j4ts-awt-swing.

Cincheo has created a [project template](https://github.com/cincheo/jsweet-quickstart) to help migrate applets with JSweet. It helped a lot, and I finally manage to have a working javascript but had to solve a lot of problems, like the need to list all imports, the setColor not working for the background (with a very disappointing black screen as a result!), resize not working… While digging a bit in the original code and preparing myself to make a patch, I realized that the repository had already the fixes, but had not released the corresponding candy to the JSweet maven repository. So I decided to retry the applet’s migration with the latest versions of libraries.

As that was my first use of maven, I ran into a nightmare of version conflicts. For a tool that aims at solving that kind of issues, it did not seem to help a lot… Anyway, I finally found the following combination seemed to work. It need a working installation with maven, node.js and Oracle’s JDK 1.8 (problems have been reported with other JDK in JSweet forums).

- Use 2.0.1 version of JSweet transpiler
- Use 5-SNAPSHOT version of jsweet-core
- Recompile other dependancies from their github, in that order : 
    - j4ts ([original github](https://github.com/j4ts/j4ts)) : `mvn install`
    - j4ts-file ([tmatz fork, migrated to JSweet 2.0.1](https://github.com/tmatz/j4ts-file)) : `mvn install`
    - j4ts-awt-swing ([original github](https://github.com/j4ts/j4ts-awt-swing)) : `mvn install` *(note : when redoing this step while writing this article, I ran into problems with TS2322 errors with swing, as the project is only using AWT the removal of the folder src/main/java/javax/swing will do the trick)*

Then let’s start for what is specific to the project. I started with Cincheo’s [project template](https://github.com/cincheo/jsweet-quickstart) but removed almost everything except the pom file and the src/main/java and webapp folder (but removed their contents). I added my laby.java in src/main/java and changed the pom.xml file to leave only the depandancies to jsweet-core and j4ts-awt-swing with above versions.

[Here is a zip file](/files/2019/08/jsweet-laby.zip) with the full project.

```xml
    <dependencies>
        <dependency>
            <groupId>org.jsweet</groupId>
            <artifactId>jsweet-core</artifactId>
            <version>5-SNAPSHOT</version>
        </dependency>
        <dependency>
            <groupId>org.jsweet.candies.j4ts</groupId>
            <artifactId>j4ts-awt-swing</artifactId>
            <version>0.0.1-SNAPSHOT</version>
        </dependency>       
    </dependencies>
```

Then I had to change some parts of my file :

Firstly the function getParameter has not been ported so I used a quick workaround with defining a getParameter function in my appel class to provide defaults values :

```java
	public String getParameter(String param)
	{
		switch(param) {
			case "xmax" : return "100";
			case "ymax" : return "60";
			case "updt" : return "true";
			case "dbg" : return "false";
			default: return "";
		}
	}
```

But this is not really efficient, so as I have a development environment ready for j4ts-awt-swing, I made a simple patch to add this function to take parameters from the Applet tag, in src/main/java/java/awt/Applet.java :

```java
	public String getParameter(String param) {
		return this.htmlElement.getAttribute((String)("param-").concat(param));
	}
```

Simple, isn’t it ? And no need to modify the original source code.

Then the original java applet uses a offscreen buffer to avoid flickering, but Image is not fully implemented in the AWT candy (just basic external image functions) and there is no more flickering problem with modern canvas, so I just removed the offscreen part. Note this is the only change I needed to make on the original file.

The file now compiles with `mvn generate-sources`

Last thing to do is to create the HTML file using the generated javascript, by adapting the original one with the candies and versions used, and adding the new “param-xx” attrbibutes :

```html
<html>
<head>
<script type="text/javascript" src="j4ts-0.6.0-SNAPSHOT/bundle.js"></script>
<script type="text/javascript" src="j4ts-file-0.0.1-SNAPSHOT/bundle.js"></script>
<script type="text/javascript" src="j4ts-awt-swing-0.0.1-SNAPSHOT/bundle.js"></script>
<script type="text/javascript" src="../target/js/laby.js"></script>
</head>
<body>
<div class="applet" data-applet="laby" data-width="1600" data-height="640" param-xmax="200" param-ymax="60" param-updt="true" param-dbg="false"></div>
</body>
</html>
```

Open this HTML file in a browser, and hurray, it should work! (if not, enjoy some debug time ;-))

A little improvement: when resizing, the whole canvas disappear. This is caused by the resize function that always resize the canvas but not repaint it. And an resized canvas is always cleared. So I modified the function in Panel.java to not resize if the HTML element is not resized (typical case of fixed width elements, which is exactly the case of our Appel html tag), and even if resized, to add a call to the repaint function.

```javascript
window.onresize = e -> {
	if ((htmlCanvas.width != htmlElement.offsetWidth) || (htmlCanvas.height != htmlElement.offsetHeight)) {
		htmlCanvas.width = htmlElement.offsetWidth;
		htmlCanvas.height = htmlElement.offsetHeight;
		repaint();
	}
	return e;
};
```

And last of all, to make the storage and distribution of the resulting files easied, I wanted to have the whole in a single HTML file. I used inliner tool to install with `npm install -g inliner` and to use very simply with `inliner laby.html > laby-inline.html` .

The resulting pull request of j4ts-awt-spring is [here](https://github.com/j4ts/j4ts-awt-swing/pull/8).

Below is a screenshot with the javascript version to the left, and with the original applet to the right :
![](/files/2019/08/jsweet-laby-1024x470.jpg){: .img-center}

You will notice the result is not quite the same, because of the antialiasing in my browser that cannot be programmatically disabled.

Want to try it ? [click here !](/files/2019/08/laby-inline.html)

In conclusion, I am not sure that it took me less time as a clean native javascript rewrite, but it was fun to discover JSweet and I learned a lot. It is very efficient for conversion of logic part of the source, but have several limitations on the UI part.

