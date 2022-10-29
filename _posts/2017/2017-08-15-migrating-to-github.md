---
post_id: 1400
title: 'GitHub Migration'
date: '2017-08-15T17:46:00+02:00'

author: 'Rémi Peyronnet'
layout: post
guid: '/2017/08/migrating-to-github/'
slug: migrating-to-github
permalink: /2017/08/migrating-to-github/
tc-thumb-fld: 'a:2:{s:9:"_thumb_id";s:4:"1601";s:11:"_thumb_type";s:5:"thumb";}'
post_slider_check_key: '0'
image: /files/2017/10/github_1507835012.png
categories:
    - Informatique
tags:
    - Blog
lang: en
---

GitHub is a great collaborative development platform for Open Source. My projects were currently only published in source zip files, and my SVN repository was private. Having played a while with GitHub, this is now a must have if you want some contributions. So I decided to publish my projects to GitHub.

But I had some exigences :

- Keep separate a ‘private’ repository and the GitHub public one : I use a repository to sync files between my Linux and Windows development environments with a lot of technical commits
- Have history commits (but cleaned of those technical commits and rubbish comments)

As I use SVN for my private repository, it is very easy to distinguish from git commits. And both tools perfectly works alongside each other.

To migrate contents, I wrote two scripts, inspired by this article about GIT commits in the past : [https://leewc.com/articles/making-past-git-commits/](https://leewc.com/articles/making-past-git-commits/ "https://leewc.com/articles/making-past-git-commits/")

# Migration from Files

The first one is for projects for which I have kepts history of source files

```
# Should empty dir  # rm -Rf *
git init
for FILE in "$@"
do
	STRIP=`tar tf "$FILE" | cut -d/ -f1 | uniq | wc -l`
	if [ $STRIP -eq 1 ]
	then
		TARSTRIP="--strip-components=1"
	else
		TARSTRIP=""	
	fi
	# Should clean here except .git  # rm -Rf (!.git)
	tar xzf "$FILE" $TARSTRIP
	export GIT_COMMITTER_DATE="` stat -c %y $FILE`"
	export GIT_AUTHOR_DATE="$GIT_COMMITTER_DATE"
	echo "$FILE > $GIT_AUTHOR_DATE"
	git add -A > /dev/null
	RELEASE=`basename -s .tar.gz $FILE`
	git commit -am "Release $RELEASE (See Changelog)" > /dev/null
	git tag -a "$RELEASE" -m "Release $RELEASE"
done

export GIT_COMMITTER_DATE=
export GIT_AUTHOR_DATE=
```

Note that the files removed in files are not removed. If you want to, uncomment rm -Rf items, at your own risk. I prefered a cleanup commit at the end.

```
./files-to-git.sh /home/www/soft/rphoto/rphoto-0.2.0.tar.gz /home/www/soft/rphoto/rphoto-0.3.2.tar.gz /home/www/soft/rphoto/rphoto-0.4.0.tar.gz /home/www/soft/rphoto/rphoto-0.4.1.tar.gz /home/www/soft/rphoto/rphoto-0.4.2.tar.gz /home/www/soft/rphoto/rphoto-0.4.3.tar.gz /home/www/soft/rphoto/rphoto-0.4.4.tar.gz
```

Once finished, you may push to an uninitialized repository at GitHub.

You may also move the .git repository created at your current repository, and commit extra changes.

# Migration from SVN

There is a lot of great tools to migrate SVN to GIT, but I found no one that could merge some commits to have a clean history. Too bad it is not supported by SVN or GIT.  
So I decided to select some revisions to build GIT history.

```
#xmlTreeNav
#SVNPATH="file:///home/svn/trunk/projects/xmltreenav/"
#REVS="112:v0.1.0	296:v0.2.3 351:v0.3.0 389:v0.3.1 576:v0.3.2 640:v0.3.3"

 # libxmldiff
SVNPATH="file:///home/svn/trunk/projects/libxmldiff/"
REVS="84:v0.2.0 301:v0.2.5 396:v0.2.6 402:v0.2.7 608:v0.2.8"

git init
echo .svn > .gitignore
for ITEM in $REVS
do
	REV=`echo $ITEM | cut -d : -f 1`
	VER=`echo $ITEM | cut -d : -f 2`
	svn co -r "$REV" "$SVNPATH" . # > /dev/null
	export GIT_COMMITTER_DATE="`svn log -r $REV --xml | xmlstarlet sel -T -B -t -v //date`"
	export GIT_AUTHOR_DATE="$GIT_COMMITTER_DATE"
	echo "$REV = $VER > $GIT_AUTHOR_DATE"
	git add -A > /dev/null
	git commit -am "Release $VER (See Changelog)" > /dev/null
	git tag -a "$VER" -m "Release $VER"
done

export GIT_COMMITTER_DATE=
export GIT_AUTHOR_DATE=
```

With this method deleted items are handled ok. No need of a cleanup commit. You may move the .git folder to your repository and push extra changes.