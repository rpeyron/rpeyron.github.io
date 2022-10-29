---
post_id: 4323
title: 'New releases of RPhoto, libmldiff &#038; xmlTreeNav'
date: '2020-05-09T22:50:20+02:00'
last_modified_at: '2020-05-09T22:50:20+02:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=4323'
slug: new-releases-of-rphoto-libmldiff-xmltreenav
permalink: /2020/05/new-releases-of-rphoto-libmldiff-xmltreenav/
image: /files/2017/10/github_1507835012.png
categories:
    - Informatique
tags:
    - RPhoto
    - libxmldiff
    - xmltreenav
lang: en
---

Hey, after more than three years, here are new releases of my main software! It is mainly maintenance releases, merely to test my new vcpkg / visual studio 2019 installation, and aggregate the small bugfixes, small features of previous commits. See the full changelog for details on GitHub and grab the latest release on their pages ([RPhoto](/rphoto-en/), [libxmldiff ](/libxmldiff/)&amp; [xmlTreeNav](/xmltreenav-en/))

A note about the current building &amp; release process: the building part was already quite efficient on Linux, and is now much better on Windows with vcpkg dependencies management. But the release process is still quite difficult, because over time multiple destinations have been added, and take time to build :

- Windows release is OK with Inno Setup: the file configuration is stable over the release, you just click and it works
- Debian build is OK too; the scripts I have since 10-15 years are still working, even it is not fully compliant with packaging rules
- Ubuntu Launchpad PPA is somewhat more difficult: dependencies may vary between ubuntu versions, and at each failure you have to rebuild, increment changelog, upload, wait; very long to set up if not used for a long time, but very useful then
- Snapcraft to create snaps for Ubuntu is a real piece of crap, very difficult to build and take ages when you cannot use VM to use snapcraft locally (as the ubuntu I use is already in a VM) ; the store is a nightmare, with a lot of rules that will prevent your software being published. So I guess I will stop Snap releases in the future…
- Github commits: I still manage my projects on a local svn, that I use intensively to synchronize Linux and Windows environments; I guess I should better use only git with branches, but I haven’t yet, so I must take some time to be sure to commit to Git all relevant files
- Website update: I have webpages that refer to the contents published to github (direct links, changelogs,…), and that need some time to update…

In a proper software factory architecture, all this should be simplified with a full CI toolchain. I already set up Travis-CI pour libxmldiff to have build status, code analysis, and code coverage, but it should be extended to binaries generation and publication. As these projects are not really active, more in maintenance mode, that may never happen.