---
title: devcontainer for dokuwiki plugin development
lang: en
tags:
- Dokuwiki
- vscode
- container
- Docker
- PHP
categories:
- Informatique
image: files/2023/dokuwiki_devcontainer.jpg
date: '2023-08-20 16:49:56'
---

I am maintainer of a [dokuwiki plugin](https://www.dokuwiki.org/plugin:button) and as I am no more a dokuwiki user, nor PHP developer, it is not always easy to get a running environment to fix and test. But now we are in 2023, and there is a cool thing called {devcontainers](https://containers.dev/) that will help us a lot. 

In this post I use vscode as editor, but it should work with any modern code editor. You also need to have a working docker setup (see [official docker documentation if needed](https://docs.docker.com/get-started/)).

# Define base container to use
By default, vscode will help you to create a devcontainer with various programming languages, such as PHP. To do that, you can click on the green connect button on the bottom left of the vscode window (see [vscode documentation](https://code.visualstudio.com/docs/devcontainers/containers)). You can create a base file with the most accurate options. 

But you can also use docker containers. In my case, I have found a [dokuwiki docker container](https://hub.docker.com/r/linuxserver/dokuwiki) built by linuxserver that seems perfect. It uses the latest dokuwiki version (you may override the version if needed), uses a recent nginx and PHP version and seems to be updated frequently. To use this image, you will need to replace the image variable of the `.devcontainer/devcontainer.json` file :
```
   "image": "linuxserver/dokuwiki:latest",
   "overrideCommand": false,	// to use dockefile command
   "forwardPorts": [80],
```
You will also need to add:
- `overrideCommand: false` so the command defined in the Dockerfile definition of the container won't be overridden and in this container it is this command that starts the web serveur
-  `forwardPorts` to define the port to use ; note that if you don't use the default 80, you may need the update dokuwiki configuration

At this time, you should be able to build the devcontainer and connect to it, and `http://localhost/` should display the dokuwiki setup page.

# Mount your project in the image
By default, vscode will mount your workspace somewhere in the devcontainer. To be sure of the location, you can force the location by using:
```
   "workspaceMount": "source=${localWorkspaceFolder},target=/workspace/button,type=bind",
   "workspaceFolder": "/workspace/button",
```

Please be careful not to be inside the devcontainer when changing the workspacefolder, and be sure to use option "Reopen locally" to quit the devcontainer. If not, you may lose all your workspace contents.


# Use a default configuration for dokuwiki
The provided docker is not configured, and you need to go through the installation setup, what is not very handy in our case. You can simply configure dokuwiki and save the modified files. In Docker Desktop, you may simply click on the container, and select the Files tab to browse files in the container and download the files you want. In my basic setup, I have seen that the relevant files are `acl.auth.php`, `local.php`, `plugins.local.php` and `users.auth.php` located in `/config/dokuwiki/conf/`. I have stored these files in my project, in the `./tests/conf/` folder, and I set up a postCreateCommand script to copy the files at the container build time.

```
   // Copy default configuration file with admin test:test
   "postCreateCommand": "cp -rf /workspace/button/tests/conf/* /config/dokuwiki/conf && chown -R abc:abc /config/dokuwiki",
```

Note that you may choose two different methods to make available these files to dokuwiki:
- the copy method used above, that will be run after container creation ; you may then update the configuration in the container, but the configuration will be lost the next time you build the container ; the source files won't be modified
- the bind method, that we will use for the pages ; in this method, any modification in the container will impact the files in your project

Also this container runs with user abc. So we need to change ownership of files to be able to use it.

For pages and medias, we want to be able to retain modifications of the files in our repository (but you may use the copy method if you prefer) ; we can simply add mounts to the devcontainer:
```
   // Mount data/pages and data/media (other contents will be lost)
   "mounts": [
      "source=${localWorkspaceFolder}/tests/data/pages,target=/config/dokuwiki/data/pages,type=bind,consistency=cached",
      "source=${localWorkspaceFolder}/tests/data/media,target=/config/dokuwiki/data/media,type=bind,consistency=cached",
   ]
```
# Use our plugin in the dokuwiki installation

Finally, we want to use our plugin :) we can use a third method and link the mounted workspace where we want by adding a symbolic link in the postCreateCommand:

```
   // Copy default configuration file with admin test:test
   "postCreateCommand": "cp -rf /workspace/button/tests/conf/* /config/dokuwiki/conf && chown -R abc:abc /config/dokuwiki && ln -sf /workspace/button /config/dokuwiki/lib/plugins",
```

# Resulting devcontainer

```
{
	"name": "dokuwiki-devcontainer",
	"image": "linuxserver/dokuwiki:latest",
	"overrideCommand": false,	// to use dockefile command
	"forwardPorts": [80],

	// Copy default configuration file with admin test:test
	"postCreateCommand": "cp -rf /workspace/button/tests/conf/* /config/dokuwiki/conf && chown -R abc:abc /config/dokuwiki && ln -sf /workspace/button /config/dokuwiki/lib/plugins",

	// Mount workspace
	"workspaceMount": "source=${localWorkspaceFolder},target=/workspace/button,type=bind",
	"workspaceFolder": "/workspace/button",

	// Mount data/pages and data/media (other contents will be lost)
	"mounts": [
		"source=${localWorkspaceFolder}/tests/data/pages,target=/config/dokuwiki/data/pages,type=bind,consistency=cached",
		"source=${localWorkspaceFolder}/tests/data/media,target=/config/dokuwiki/data/media,type=bind,consistency=cached",
	]
}

```
