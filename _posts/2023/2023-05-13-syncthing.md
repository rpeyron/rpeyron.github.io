---
title: Syncthing & encfs working together
lang: en
tags:
- encfs
- Linux
- Android
- mergerfs
- fuse
- Syncthing
categories:
- Informatique
toc: 'yes'
date: '2023-05-13 18:19:58'
image: files/2023/syncthing_encfs.jpg
featured: 115
---

I am a big fan of syncthing to synchronize my local files across multiple devices, and I also use encfs to get encrypted version of folders. 

# encfs and reverse mode
There is also a nice feature in encfs, called reverse, that allow to get a virtual encoded filesystem based on any non encoded filesystem. It is useful to create backups in "less secured" areas such as cloud spaces, hard drives / SD Cards in offsite locations, etc. Please note that a [security audit](https://defuse.ca/audits/encfs.htm) has since found some security flaws in encfs, but I guess this is still better than non encoded files, and I have not taken the time to move to something with higher security (like [Cryfs](https://www.cryfs.org/comparison)).  Another advantage of encfs is also to be widespread in distribution, and also available with little effort on Windows and Android. 

`encfs` stores encoded version of your files and allow to give access to a virtual filesystem with decoded contents. `encfs --reverse` does exactly he opposite, and will offer you a virtual filesystem with encoded contents of non encoded files stored on your computer. So you don't have to copy/synchronize your files in a secured container before snchronizing / backuping it. It is also possible to automate this in fstab, to get automatically mounted reverse encfs, but as encfs does not support natively fstab syntax you will need an intermediate shell script:

In `/etc/fstab`:
```
/root/bin/mount-encfs-std-reverse#/mnt/bk-hubic /mnt/bk-hubic_encfs fuse ro 0 0
```

In `/root/bin/mount-encfs-std-reverse`
```
#!/bin/sh
echo "<your password> | encfs --public --reverse -S $*
```

There are also options to get files encrypted during the synchronization process, but either they are immediately decoded after reception, or they are harder to decode after. 


# Problems with syncthing

There are some problems to use encfs reversed filesystem with syncthing:
1. `syncthing` expects a `.stfolder` folder to check the target we want to synchronize is really there (that is a good security to avoid destroying all your files remotely if your source filesystem is not mounted for any reason). `syncthing` call this a marker and allow changing the name in a markerName option in the XML config file. You need to edit the folder you want to use and add the markerName tag to use the name of an existing folder in your encfs filesystem:
```xml
    <folder id="encfs_folder" label="encfs_folder" path="/mnt/encfs_folder" type="sendonly" ... >
        <filesystemType>basic</filesystemType>
        ...
        <markerName>uP-77qTZcu8WhCZGC8R2P1WI</markerName>
        ...
```
2. `syncthing` will try to load a `.stignore` file to get ignore patterns from it. It is not a problem if the file is not found, but for some reason, encfs does not simply throw a `file not found` error, but a `input/output error` that makes syncthing abort the synchronization. There is some debate abut the way to fix it, but no solution was implemented:
  - syncthing point of view :  https://forum.syncthing.net/t/dir-on-read-only-filesystem-folder-stopped-because-of-missing-stignore/18237  and  https://github.com/syncthing/syncthing/issues/6171#issuecomment-557257895
  - corresponding encfs open issue : https://github.com/vgough/encfs/issues/570
  - if you want to patch syncthing, this should be [the line of code](https://github.com/syncthing/syncthing/blob/634a3d0e3be4a706dfb58253da534e396cac714e/lib/fs/filesystem.go#L204) where to patch to change input/output error to not exists ; but as it won't be accepted and maintained over time, it is not a good solution in my opinion.
3. `encfs` will need the `.encfs6.xml` file to be able to mount a decrypted version of the folder


# Workaround with mergerfs
There is another very handy fuse filesystem called [mergerfs](https://github.com/trapexit/mergerfs) that does exactly what we would expect from its name, as it will merge two filesystems in a single one. We will use it readonly, but this fuse filesystem also works in read/write mode (and works very well). 

We will create a folder with the file expected by syncthing in a `/mnt/encfs_folder_stfiles` folder:
- `.stfolder` (created by example with `touch .stfolder`)
- `.stignore` (created by example with `touch .stignore`)
- `.encfs6.xml` (copied or linked from source folder `ln -sf <sourcefolder>/.encfs6.xml .`)

And we will also create a `/mnt/encfs_folder_merged` folder to get the result of `mergerfs`, and configure the merge in `/etc/fstab`:
```
/mnt/encfs_folder:/mnt/encfs_folder_stfiles  /mnt/encfs_folder_merged  fuse.mergerfs  allow_other,use_ino   0       0
```

You can now reboot or mount everything with `mount --all` and update your syncthing source folder to point on the merged one and everysthing should now be OK!


# Android Application

I used to use [Cryptonite](https://github.com/neurodroid/cryptonite), but it is no longer maintained, and no more available on the application stores. So I found [EDS List](https://f-droid.org/fr/packages/com.sovworks.edslite/), open-source and available on F-Droid, and quite efficient.
That way you can synchronize your important files on your smartphone using [syncthing Android App](https://play.google.com/store/apps/details?id=com.nutomic.syncthingandroid&hl=fr&gl=US) but keep them securely encoded in case of loosing your phone.
