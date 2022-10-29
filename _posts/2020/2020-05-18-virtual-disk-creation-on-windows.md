---
post_id: 4333
title: 'Virtual Disk creation on Windows'
date: '2020-05-18T17:48:09+02:00'
last_modified_at: '2020-05-18T17:48:09+02:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=4333'
slug: virtual-disk-creation-on-windows
permalink: /2020/05/virtual-disk-creation-on-windows/
image: /files/2020/05/VHDX-creation-2.png
categories:
    - Informatique
tags:
    - Disk2VHD
    - QEmu
    - VMWare
    - Virtual
    - vhdx
lang: en
lang-ref: pll_5ec2baca1a458
lang-translations:
    fr: creation-de-disques-virtuels-sous-windows
    en: virtual-disk-creation-on-windows
---

All versions of Windows have great support for virtual disks that is not well-known. And if you have access to a Windows Pro computer, you can encrypt them and make good encrypted containers that are useable on every modern Windows without the need for third-party tools.

# The virtual disk part

Create a Virtual Disk is fairly easy with the Computer Management utility. This is a great standard tool that has been somewhat hidden in modern Windows. You will find it within “Administration tools” in “System Windows” submenu. In this application, you will find the Disk Management tool (you may also search directly for “Disk Management”, “Partition management”) :

![](/files/2020/05/Gestion-des-disques.png){: .img-center}

1\. Use menu “Action” / “Create VHD” to create a virtual disk

![](/files/2020/05/VHDX-creation-300x165.png){: .img-center}

2\. Select VHDX, dynamically expand option, and the maximum size you want. Change the size of the disk is possible but not really easy with Windows 10 Home so you may want to select a large disk. (With Windows 10 Professional you will be able to expand virtual disks with Hyper-V management tools)

![](/files/2020/05/VHDX-creation-2-243x300.png){: .img-center}

3\. You will then need to initialize the disk with a partition system, either with ‘old’ MBR or newer GPT. I personally prefer to be up to date but as we will see later, GPT will take a little more initial disk space.

![](/files/2020/05/VHDX-creation-3-300x230.png){: .img-center}

4\. And then you can create a partition by right-clicking on the unused space. You can select the whole disk, or a smaller size if you do not want that your expandable disk grow to fast. Unlike disk resizing, partition resizing is fairly easy with the same tool. So you can start low and make grow the disk later. You may choose exFAT or NTFS. As with GPT, I prefer up-to-date technology and choose NTFS.

![](/files/2020/05/VHDX-creation-4-300x88.png){: .img-center} ![](/files/2020/05/VHDX-creation-5-300x236.png){: .img-center}

You have now a working virtual disk, and will see the new disk in explorer.

To disconnect it, you may either :

- in explorer right-click on the disk, and click “Eject” (if you have created multiple partitions on the same virtual disk, you must eject each to disconnect the virtual disk)
- in the disk management tool, right-click on the virtual drive, and click “Detach virtual disk”

To re-connect it later, just double-click on the VHDX file in explorer!

# The BitLocker part

To add the encryption with BitLocker, right-click on your mounted partition of the virtual drive in explorer, and click “Activate BitLocker” and follow steps: Enter a strong password, save the recovery information safely, encrypt only used space and keep other parameters default.

![](/files/2020/05/Bitlocker-1-300x115.jpg){: .img-center}

![](/files/2020/05/Bitlocker-2-300x128.jpg){: .img-center}

Disconnect/eject the drive, and you have now a standalone BitLocker container that will work on every Windows 10 PCs Pro of Home editions. Interestingly enough, you will benefit all functionalities of BitLocker on all editions, like the ability to change passwords and copy it. Only limitation is that they will all share the recovery information. If you are a Windows 10 Home only user, ask a friend or colleague who has access to one to follow those steps and give you the VHDX file. You will be able to change the password (but your friend or colleague had access to the recovery key).

# A little comparison of containers sizes

I was a little confused about the sizes of the files that were created empty, so here are some elements. Note it is only about empty containers, I guess the differences will go away with the use with real contents.

I first created a bunch of virtual disk drives with different settings :

A not initialized virtual disk takes no space :

![](/files/2020/05/VhdxSizes-NotInitialiazed-300x28.png){: .img-center}

GPT will take more space than MBR, and NTFS more than FAT. If you want the minimal size, select MBR partitioning system and exFAT partition format :

![](/files/2020/05/VhdxSizes-Partitionned-300x70.png){: .img-center}

BitLocker will require more space :![](/files/2020/05/VhdxSizes-BitLocker-300x44.png){: .img-center}

What is interesting is that the files can be compressed very well, reducing to only 377kB for NTFS/GPT, or 13 Mo for a Bitlocker/exFAT/MBR virtual disk.

![](/files/2020/05/VhdxSizes-Zipped-300x155.png){: .img-center}

So you can prepare some empty disks and store them with no space!

I still was confused with the size of empty VHDX created from USB disks with the disk2VHD utility:

![](/files/2020/05/VhdxSizes-Disc2VHD-300x32.png){: .img-center}

Unfortunately, you cannot run Disk2VHD on virtual drives… That would have been fun! As it maybe due to some preallocation space, I wanted to convert it with no preallocation and see if that changes something.

# Playing with QEmu-img

A handy free tool to deal with virtual disk images is [qemu-img](https://www.qemu.org/docs/master/interop/qemu-img.html) from QEmu. It is available for Windows and Linux and will allow you to do all shrink, resize, and conversions between `qcow2` (QEmu native format), `vmdk` (VMWare native format), `vhi` (Virtual Box native format) and `vhdx` (Hyper-V native format).

I first tried a direct conversion from VHDX to VHDX with:

```
qemu-img.exe convert -f vhdx -O vhdx -o subformat=dynamic Empty100Go.vhdx Empty100Go-converted.vhdx
```

Total failure, it made the file grew from 196 Mo to almost full expanded size! (86 Go vs 100 Go total size)

Oddly, when converting to qcow2 and then back to vhdx, it works better:

```
qemu-img.exe convert -f vhdx -O qcow2 -o preallocation=off Empty100Go.vhdx Empty100Go-converted.qcow2
qemu-img.exe convert -f qcow2 -O vhdx -o subformat=dynamic Empty100Go-converted.qcow2 Empty100Go-converted.vhdx
```

The resulting file is 168 Mo, so less than the original 196 Mo. Note that the temporary qcow2 file size is 2.75 Go, which is a little surprising with preallocation=off…

So in the end, minimal sizes of empty containers were obtained :

- with zipped files
- with MBR &amp; exFAT filesystem (over GPT &amp; NTFS)
- with the use of Disk2VHD on empty USB stick (over creating with disk management utility)

Again, these size comparisons do only apply to empty containers. It is very likely that space gaps will reduce heavily while using it with real content.

Note that if you have Windows 10 Pro, you may install Hyper-V optional feature and have extra tools to work with VHDX file in the Hyper-V console management, with the menu “Action” “Modify disk” you will be able to shrink, expand and convert VHDX virtual disks.

![](/files/2020/05/Hyper-V-Modify-Disk-300x225.png){: .img-center}