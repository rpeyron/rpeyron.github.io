---
post_id: 5589
title: 'How to save a mdadm array with a kernel patch'
date: '2021-12-23T19:03:29+01:00'
last_modified_at: '2021-12-28T20:36:36+01:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=5589'
slug: how-to-save-a-mdadm-array-with-a-kernel-patch
permalink: /2021/12/how-to-save-a-mdadm-array-with-a-kernel-patch/
image: /files/photo-1584475784921-d9dbfd9d17ca-scaled.jpg
categories:
    - Informatique
tags:
    - Debian
    - build
    - kernel
    - mdadm
    - raid
    - raid5
lang: en
---

To keep my online storage safe, I use a mdadm raid5 array on my Linux box for more than a decade. This has proven to be very useful as all hard drives, regardless the quality, will fail one day. In my case, almost a third of my drives have failed, after4-8 years of good 24/7 services. Thanks to mdadm, I have never lost data and mdadm has proven to be very reliable these last 10 years.

Being short of space, I had recently the need to expand the array with another disk. Regular users of mdadm know how easy it is, you first add your new drive as spare, and then expand the array to the total number of drives:

```
mdadm /dev/md0 --add /dev/sdf1
mdadm --grow /dev/md0 --raid-devices 4
```

That will start a reshape to reorganize the data and parities bit to the 4 drives instead of the previous 3 drives, by reading the data on the old 3-drives array and writing back to the new 4-drives array. This operation can take a long time to perform on large arrays, and especially if like me you have some old drive that does not perform as good as the latest bought. Still I noticed in the middle of the reshape operation that it was taking way too much time, with a speed that has dropped to nearly a few ko/s. Reading my dmesg logs, I noticed several timeouts in the mdadm process, that seems to be caused by one of the drive. The corresponding drive being rather old, and SMART reporting pre-failure errors, this seems to be indeed a good reason. As at the current speed of the reshape it will last almost an eternity to complete, I finally decided to fail the corresponding drive. My array being clean, a failed drive is not a problem and the reshape should go to the end with maximum speed. At least that is what I though… but don’t do that… just don’t…

**DO NOT FAIL A DRIVE WHEN THE ARRAY IS BEING RESHAPED**
{: .center .frame-red}

But as the reshape process cannot be cancelled / reverted once started, I had not other choice. My mistake was not to check the sanity of my current disks before adding a new one. I have tested the new one I wanted to add, but this is not enough, you should also test the current disks before starting a reshape process, especially if you see that mdadm has recorded some badblocks on the disks. You may check that with:</span>

```
mdadm --examine <your disks>
```

If I had seen that one of the current drive was failing, the sensible thing to do is to replace with the new drive with a special mdadm command that will basically copy the old drive to the new drive and replace it at the end. By doing that way, your array is never in the degraded state and you take no risks in case of another failure.

```
mdadm /dev/md0 --replace /dev/sdd1 --with /dev/sdc1
```

So I failed my drive, and the reshape continues as everything was fine, until I noticed the speed was again dropping to nothing. The reshape process was stuck in the middle of it, and make no progress anymore. The speed being an average calculation it reported still a non zero speed but it was not a real speed : the process was stuck, the current sector not moving and the mdadm process taking 100% of processor. I tried several reboots, many drive optimizations and parameters changes I found here and there on the Internet, but nothing was working and the speed always dropping to zero at the same place. The array is still assembling itself OK and data still readable. As you may have guessed, it is now a good time to make backups if not made before, and maybe the best option if you have the opportunity is to buy a new array and move all the data to the new clean array.

On all the pages I read, one was intriguing me : <https://bbs.archlinux.org/viewtopic.php?id=198361> it is a forum message of 2015 that report exactly the same problem as me, and has solved his problem with a kernel patch given by the linux-raid mailing list. The patch is fairly simple, just one line to comment, and as it seems that this line is stopping the reshape, it makes sense to my issue. So I wanted to give it a try. For users that are accustomed to building kernels it is easy, but the last time I built a kernel was something like 20 years ago, maybe because now, like the [debian documentation](https://www.debian.org/releases/bullseye/amd64/ch08s05.en.html) says, “Why would someone want to compile a new kernel?”. And indeed it is not so easy to find the whole process documented. The [best source of information](https://kernel-team.pages.debian.net/kernel-handbook/ch-common-tasks.html#s-kernel-org-package) I found is from the debian kernel team (and also some pieces in the [debian-handbook](https://debian-handbook.info/browse/fr-FR/stable/sect.kernel-compilation.html), and while writing this article, a [good one in french](https://debian-facile.org/doc:systeme:kernel:compiler)), and the process is quite easy, when you know what to do:

```
# Add dependencies to compile
sudo apt-get install build-essential fakeroot
sudo apt-get build-dep linux

# Add deb-src apt source
sudo sh -c '(echo deb-src http://deb.debian.org/debian/ bullseye main non-free contrib >> /etc/apt/sources.list)'
sudo apt-get update

# Add dependencies packages to build kernel
sudo apt-get build-dep linux

# Download the kernel you want from https://www.kernel.org/
# (In my case I downloaded the lasted of the branch of my bullseye debian which is the latest longterm 5.10)

# Decompress 
tar xaf linux-5.10.88.tar.xz
cd linux-5.10.88

# Copy your current configuration which is located in /boot
cp /boot/config-5.10.0-10-amd64 .config

# Disable debug generation
scripts/config --disable DEBUG_INFO

# Disable signing
scripts/config --disable MODULE_SIG
# This does not seem to be enough, so I had to comment all sign lines in .config
#   the process will then ask you to regenerate some keys
# # CONFIG_SYSTEM_TRUSTED_KEYS=...
# # CONFIG_MODULE_SIG_KEY=...
nano .config

# Then build the debian package (with all processors, the current architecture and a local version)
make clean
make deb-pkg -j"$(nproc)" LOCALVERSION=-"$(dpkg --print-architecture)" KDEB_PKGVERSION="$(make kernelversion)-1"

# And finally install it!
sudo dpkg -i ../linux-image-5.10.88_5.10.88-1_amd64.deb
```

There are also 2 other packages with headers and libc. If you used the same kernel base as your current system it is more safe not keep the current ones.

The compilation process took almost 1 hour on my 9 years old computer with only one processor, so it may only take 10-15 mins on a new computer with all its cores. If I remember good, it is almost the time it took 20 years ago with a much smaller code base and without all modules : the kernel code has grown approximately at the speed of the processor performance 😉

The method above use debian package, which is easier to use, as it will install everything in the good place, configure and update grub to use the latest kernel, and you will be able to remove it properly with only one command. If you prefer to use the standard kernel way, it is `make && make modules_install`

So now, reboot with this new kernel, and restart the reshape process. Please note that because of the stuck mdadm reshaping process, you won’t be able to halt properly the system. So after everything that could be shutdown has been shutdown, I have to force restart with the power button…

The reshape process should restart and finish with maximum speed. I have now to revert my array to the original number of disks to recover a clean non-degraded array:

```
# "Grow" to the previous number of devices
# - backup file is mandatory as the array is degraded
# - mdadm will ask you to shrink the array before ; just copy/paste the command it suggests
sudo mdadm --grow /dev/md0 --raid-devices 3 --backup-file /root/mdadm-backup
```

You should then reboot on the previous kernel (if you do not have access to grub prompt, use `grub-customizer` to change default entry) and remove your kernel with `sudo dpkg -r linux-image-5.10.88` . As the kernel you built don’t have all the debian patches and security maintenance, I guess it is not a good idea to keep that one running.

All that to get back to the beginning, so it is useful to take some time to check before doing mistakes, but if you are reading my page you certainly didn’t and made the same mistake as me 😉

During the process, I discovered the[ mdadm raid pages](https://raid.wiki.kernel.org/index.php/Linux_Raid) that contain very [useful tips and commands](https://raid.wiki.kernel.org/index.php/Recovering_a_damaged_RAID), and also [hardcore methods for non-recoverable arrays](https://raid.wiki.kernel.org/index.php/Irreversible_mdadm_failure_recovery).