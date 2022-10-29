---
post_id: 1406
title: 'Create a shared / roaming profile in Linux'
date: '2013-02-07T19:22:00+01:00'

author: 'Rémi Peyronnet'
layout: post
guid: '/2013/02/roaming-profiles-linux/'
slug: roaming-profiles-linux
permalink: /2013/02/roaming-profiles-linux/
tc-thumb-fld: 'a:2:{s:9:"_thumb_id";s:4:"1669";s:11:"_thumb_type";s:5:"thumb";}'
post_slider_check_key: '0'
image: /files/2017/10/web_server_1507996534.jpg
categories:
    - Informatique
tags:
    - Blog
lang: en
---

Sharing a profile between several Linux hosts is not an easy task for the moment. You will be tempted to share exactly the same profile folder, but this will cause some problems with local settings. The easiest solution is to create a `.roaming` folder in which you will put all the files you want to share, and share it between all hosts. Then you will create symbolic links to this `.roaming` folder.

Here is a script to create all the links for you. You can re-run it if you have added a new file or folder in your `.roaming` folder.

```
roaming.sh
```

roaming.sh

```
#! /bin/sh
 
ROA_IN=${1:-~/.roaming}
ROA_OUT=${2:-~}
ROA_BK="$ROA_OUT/.roaming-bk"
 
echo "Link roaming space $ROA_IN to $ROA_OUT. Are you sure? <y,n>"
read REPLYST
if [ ! "x$REPLYST" = "xy" ]
then
    exit 1
fi
 
#Treat all files, inclugind hidden file, but excluding the current script.
for FILE in $(ls -A $ROA_IN | grep -v -e "^$0$" )
do
  #echo $ROA_IN/$FILE
 
  #Skip existing correct links
  if [ -h $ROA_OUT/$FILE ]
  then
     if [ "x$( readlink '$ROA_OUT/$FILE')" = "x$( readlink -f '$ROA_IN/$FILE')" ]
     then
       continue
     fi
  fi
 
  # Move existing files to backup
  if [ -e $ROA_OUT/$FILE ]
  then
    # Create backup folder
    if [ ! -d $ROA_BK ]
    then
      if [ -e $ROA_BK ]
      then
        echo "[ERROR] $ROA_BK exists but is not a folder. Please fix this."
	exit 2
      fi
      mkdir -p $ROA_BK
    fi
    # If destination exists, ask if the user want to remove it
    if [ -e $ROA_BK/$FILE ]
    then
       echo "[?] Backup already exists in $ROA_BK/$FILE; replace it? [y,n]" 
       read REPLYBK
       if [ "x$REPLYBK" = "xy" ]
       then
         echo "Removing $ROA_BK/$FILE"
         rm -Rf "$ROA_BK/$FILE"
       else
         echo "[ERROR] Cannot backup existing file $ROA_BK/$FILE. Please fix this."
	 exit 3
       fi
    fi
    # Move file
    echo "Backuping $ROA_OUT/$FILE to $ROA_BK/$FILE"
    mv "$ROA_OUT/$FILE" "$ROA_BK/$FILE"
  fi
 
  # Link roaming file
  echo "Link $ROA_IN/$FILE to $ROA_OUT/$FILE"
  ln -s "$ROA_IN/$FILE" "$ROA_OUT/$FILE"
 
done
```

# Share with virtfs

In order to avoid problems with user rights in your virtfs folder (and avoid ‘Permission denied’ in folder withoud read attributes for everybody), you must start qemu with no confinment. To do this, edit `/etc/libvirt/qemu.conf` and uncomment/add these lines

```
security_default_confined = 0
security_require_confined = 0
user = "root"
```