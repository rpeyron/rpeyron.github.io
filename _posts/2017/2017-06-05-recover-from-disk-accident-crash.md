---
post_id: 1405
title: 'Recover from disk accident crash'
date: '2017-06-05T18:40:00+02:00'

author: 'Rémi Peyronnet'
layout: post
guid: '/2017/06/recover-from-disk-accident-crash/'
slug: recover-from-disk-accident-crash
permalink: /2017/06/recover-from-disk-accident-crash/
tc-thumb-fld: 'a:2:{s:9:"_thumb_id";s:4:"1612";s:11:"_thumb_type";s:5:"thumb";}'
post_slider_check_key: '0'
image: /files/2017/10/disk_crash_1507838418.jpg
categories:
    - Informatique
tags:
    - Blog
lang: en
---

I had this very bad habit of testing speed of my disks with dd, very simply :

```
root@server:/mnt# dd if=/dev/md0 of=/dev/null bs=1M count=100
100+0 enregistrements lus
100+0 enregistrements écrits
104857600 octets (105 MB) copiés, 4,56589 s, 23,0 MB/s
```

But with some lack of sleep, I accidentaly replaced the wrong argument and wrote to my disk, by putting my disk in ‘of’ instead of ‘if’ argument. My disks are in RAID5 to have redundancy and allow one failure. If it was a physical disk, that would be OK, just have to resync the array. But this would have been too easy, and the mistake was done with the array disk, unrecoverable. And with the first giga of the disk, it aims critical data…The repair was quite difficult, it took me one day to minimally recover and the service to be back again (step 1), but siw months to fully recover (step 2). As it could be useful, below are main parts.

# Step 1 : recover the disk

With the first giga of data overwritten, the ext4 filesystem was broken, and fsck was unable to recover with the first superblock absent. The solution is to use a backup superblock. To find where backup superblocks are located, the easiest solution is to run mke2fs in test mode. DO NOT FORGET the -n flag… If not your disk would be another time overwritten, and backup superblocks would be destroyed…

```
mke2fs -n /dev/lvm/main
```

When you have the superblock positions you can now repair the filesystem :

```
fsck.ext3 -b 1934917632 -B 4096 /dev/lvm/main
```

It will rebuild the master superblock, and find a bunch of errors because of the first giga garbage… If you are not a supernatural drive hacker, you will have no choice other than to accept all the changes proposed by fsck, while hoping it have not taken the wrong solution… In my case it have worked pretty well.

You will need to rerun fsck several times

```
fsck.ext4 -y -f -C0 /dev/lvm/main
```

You may also find some recurring errors that fsck do not succeed to fix. The only way I found to fix is to use debugfs, and remove the wrong entries.

```
root@server:~# debugfs -w /dev/lvm/main 
debugfs 1.42.12 (29-Aug-2014)
debugfs:  blocks 61901
61901: File not found by ext2_lookup 
debugfs:  blocks 
34764 34769 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 2393 [...] 2393 

debugfs:  clri <61901>
debugfs:  blocks <61901>
 
debugfs:  quit
```

Do not forget to rerun several times fsck, until no errors are found or fixed.

After all these steps, you should now have a working ext filesystem. Because of the first giga overwritten, it is most likely that the / folder would have been deleted, and you may find an empty filesystem. But do not panic, your files are in lost+found ! The filenames will be likely lost (all files are renamed #xxxxx), but it should be easy to rename back from their contents, and move back to root folder (As it is often folders, it is easier)

Ouf! You have now back a working folder. You may take a snapshot of this folder, and you can use it normally.

But you may have lost or altered some files (one giga was overvritten, and it may affect several thousands files…). Here come the second part.

# Step 2 : recover files

As I am a bit paranoid with my files, I had several security systems :

1. A simple file list backup (weekly) : to be able to detect file loss
2. A md5 hash backup of all my files (weekly) : to be able to detect file corruption (viruses,…)
3. A crashplan offsite backup (immediate backup or daily) : offsite backup, if anything wrong…

The second one was very useful to see the damages : it obviously need to be rebuilt completely, which is quite long. Thus the first file list can provide a rough result more quickly. By diffing the md5 hashes, you will have a file list which may be corrupted, and thus should be restored from crashplan.

Crashplan has a powerful GUI, but you must select each file to recover manually, which could be very tedious. If you have sufficient space and bandwidth, you can obvisouly restore all files, but that was not my case. Moreover restore speed can be quite slow, I didn’t workout why. Crashplan has an incredible API which would have been great to restore files, but sadly it is reserved to enterprise version. So I tried to automate this task by the GUI. I tested several automation frameworks on Linux and Windows, and the one which was the least problematic was PyWinAuto on Windows. Performance is not good, but proved to be quite reliable.

Here is the script (prerequisite : PyWinAuto)

```
"""CrashPlan Restore Automation (win32)"""
from __future__ import unicode_literals
from __future__ import print_function
 
import imp
from pywinauto.controls import common_controls
imp.reload(common_controls)
 
from pywinauto import application
from time import sleep
from pprint import pprint
import sys
 
app = application.Application()
app.connect(title_re=".*CrashPlan", class_name="SWT_Window0")
 
win = app.top_window()
 
# Activate Restore Tab
win.type_keys("^r")
win.wait_for_idle()
sleep(1)
 
#win.print_control_identifiers()
 
def getChild(node, name):
    if node is None:
        return None
    for item in node.children():
        text = item.Text()
        if text == "":
            item.EnsureVisible()
        if name == item.Text():
            return item
    return None
 
def getChildTimeout(node, name, timeout):
    sleepdef = 0.1
    n = 0
    text = ""
#    while ( getChild(node, name) is None) and n < timeout:
    while( ( text == "") and n < timeout ):
        try:
            text = node.children()[0].Text()
        except:
            pass
        n = n + sleepdef
        if (n % (1 / sleepdef)) == 0:
            print(".",end="")
            sys.stdout.flush()
        sleep(sleepdef)
    return getChild(node, name)
 
 
def getItemOne(node, name):
    if node is None:
        return None
    node.EnsureVisible()
    node.Expand()
    #while getChild(node,'chargement en cours...') is not None:
    #    sleep(1)
    item = getChildTimeout(node, name, 60)
    if item is None:
        print("ERROR : Not found " + name, end="")
        sys.stdout.flush()
    else:        
        print("/", end="")
        sys.stdout.flush()
    return item
 
def getItemTree(node, path):
    names = path.split('/')
    item = node
    for name in names:
        if len(name) > 0:
            item = getItemOne(item, name)
    return item
 
def checkItem(item):
    if item is not None:
        item.select()
        win.type_keys('{SPACE}')
        return True
    return False
 
def checkItemTree(node, path):
    return checkItem(getItemTree(node, path))
 
tree = win.child_window(class_name='SysTreeView32')
root = tree.Root()
root.select()
 
#checkItemTree(root, "/space/Backups/Server/encfs-find.pgp")
#sys.exit(0)
 
fname = "batch"
prefix = "/mnt/space_encfs/"
 
errors = []
 
print("Selecting file " + fname + " with prefix " + prefix)
for line in open(fname):
    line = line.rstrip("nr").rstrip()
    print("Check item " + line + " ... ", end="")
    sys.stdout.flush()
    if checkItemTree(root,prefix + line):
        print(" OK!")
    else:
        print(" ERROR !")
        errors.append(line)
 
print("Done.")
print("List of errors :")
for line in errors:
    print(line)
```

And then a script to restore files (check md5 and restore file attributes)

```
# 
SRCPATH=/space/Temp/crashplan/restored
BCKPATH=/space/Temp/crashplan/backup
SRCMD5=/space/Temp/crashplan/md5-restored
CHKMD5=/mnt/extra/md5-2016-12-09
#CHKMD5=/mnt/extra/md5-2016-07-03
RMMD5=/mnt/extra/md5
 
find "$SRCPATH" -type f | while read FILE
do
   DSTFILE=`echo $FILE | sed -e "s?$SRCPATH??"`
   BCKFILE="$BCKPATH$DSTFILE"
#   echo "$FILE -> $DSTFILE  ($BCKFILE)"
#   ls -l "$FILE" &&    ls -l "$DSTFILE"
	if [ ! -f "$DSTFILE" ]
	then
		echo "$DSTFILE does not exists ; Moving restored $FILE to $DSTFILE"
		[ -d "`dirname "$DSTFILE"`" ] || mkdir -p "`dirname "$DSTFILE"`"
		mv "$FILE" "$DSTFILE"		
	else 
	    FILEMD5=`cat "$SRCMD5$FILE" | cut -d " " -f 1`
	    FCKMD5=`cat "$CHKMD5$DSTFILE" | cut -d " " -f 1`
#		if [ "$FILEMD5" != "$FCKMD5" ] && [ -n "$FCKMD5" ]
		if [ "$FILEMD5" != "$FCKMD5" ]
		then
			echo "MD5 difference on $DSTFILE : $FCKMD5"
		else
			echo "Backuping $DSTFILE to $BCKFILE"
			chmod --reference="$DSTFILE" "$FILE"
			chown --reference="$DSTFILE" "$FILE"
			mkdir -p "`dirname "$BCKFILE"`"
			mv "$DSTFILE" "$BCKFILE"
			echo "Moving restored $FILE to $DSTFILE"
			mv "$FILE" "$DSTFILE"
			mv "$RMMD5$DSTFILE" "$RMMD5$DSTFILE.bk"
		fi
	fi
done
```

By the way a simple script to merge folders :

```
#!/bin/bash
 
DEST="${@:${#@}}"
ABS_DEST="$(cd "$(dirname "$DEST")"; pwd)/$(basename "$DEST")"
 
for SRC in ${@:1:$((${#@} -1))}; do   (
    cd "$SRC";
    find . -type d -exec mkdir -p "${ABS_DEST}"/{} ;
    find . -type f -exec mv {} "${ABS_DEST}"/{} ;
    find . -type d -empty -delete
) done
```

And yeah, you have now restored your files !! (it took me six months…)

# Conclusions

- Best is always prevention : you need to set a few things to be prepared
- The three levels are useful : 
    - Detect the file you lost (file list)
    - Detect a file corruption (md5 hash)
    - Backup contents (offsite)
- Crashplan do not backup files reliably : I had approximately 5% of files which were corrupted