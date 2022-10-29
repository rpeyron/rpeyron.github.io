---
post_id: 1387
title: 'Filter WAN Traffic with QEMU'
date: '2014-04-27T18:52:00+02:00'
last_modified_at: '2020-05-02T19:39:40+02:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/2014/04/filter-wan-traffic-with-qemu/'
slug: filter-wan-traffic-with-qemu
permalink: /2014/04/filter-wan-traffic-with-qemu/
tc-thumb-fld: 'a:2:{s:9:"_thumb_id";s:4:"1644";s:11:"_thumb_type";s:5:"thumb";}'
post_slider_check_key: '0'
image: /files/2017/10/fence_1507994329.jpg
categories:
    - Informatique
tags:
    - Blog
lang: en
---

You may want to have VM accessing your LAN, but not want them to access outside the LAN. QEmu network filters are able to do this.

First of all, network filters of QEmu does work only with bridges. Direct connections are not supported. If it is your case, please switch to bridge, with for example :

```
# brctl addbr br0
# brctl addif br0 eth0
```

Be careful that it will reset your connection, so if you are connected remotly, you must anticipate that.

You should then update your VMs configuration to use the newly created bridge br0.

# Create network filter

You will next need to create a network filter. Create the file no-out-traffic.xml with the following contents :

```
<filter name='no-out-traffic' chain='ipv4' priority='-700'>
  <uuid>03dc0f80-c95a-11e3-9c1a-0800200c9a66</uuid>
  <rule action='drop' direction='out' priority='400'>
    <ip match='no' dstipaddr='192.168.1.0' dstipmask='24'/>
  </rule>
  <rule action='accept' direction='out' priority='50'>
    <ip dstipaddr='192.168.1.0' dstipmask='24'/>
  </rule>
  <rule action='accept' direction='out' priority='60'>
    <ip dstipaddr='255.255.255.255' dstipmask='24'/>
  </rule>
  <rule action='accept' direction='out' priority='61'>
    <ip dstipaddr='224.0.0.0' dstipmask='8'/>
  </rule>
  <rule action='accept' direction='out' priority='62'>
    <ip dstipaddr='239.0.0.0' dstipmask='8'/>
  </rule>
</filter>
```

You may adapt the values to your LAN (Here is the LAN 192.168.1.0/24, plus addresses for broadcast and SSP)

Import it with

```
virsh nwfilter-define no-out-traffic.xml
```

You may also directly copy it to /etc/libvirt/nwfilter and restart libvirt-bin service.

# Associate with your VMs

There is currently no GUI to edit this property, so you must edit the VM’s XML file. You may edit with virsh or directly in /etc/libvirt/qemu (and restart libvirt-bin)

```
virsh list --all
virsh edit vmYourVM
```

Then spot the &lt;interface&gt; section, and add the filter in the interface definition

```
  <interface .... >
     ...
     <filterref filter='no-out-traffic' />
     ...
  </interface>
```

Reboot your VM, and it should now access your LAN ok, but not the WAN.

Please note that the filter is related to the interface definition, so if you reset the interface component or delete/recreate it, the filter will be lost and you should re-associate it.

# Other tips

- With Windows Server 2003, you should use pcnet interface driver ; other may have problem to get DHCP answers