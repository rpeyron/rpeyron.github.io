---
post_id: 5168
title: 'Domoticz &#8211; Panasonic remote buttons and Custom URLs'
date: '2020-12-22T18:00:33+01:00'
last_modified_at: '2020-12-24T21:09:17+01:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=5168'
slug: domoticz-panasonic-remote-buttons-and-custom-urls
permalink: /2020/12/domoticz-panasonic-remote-buttons-and-custom-urls/
image: /files/2020/12/domoticz_pana_remote_custombuttons.png
categories:
    - Domotique
    - Informatique
tags:
    - Domoticz
    - GitHub
    - Plugin
    - custom
    - panasonic
    - pr
    - url
lang: en
---

There is no need to introduce the great home automation software Domoticz and I wrote already some blog posts about it. Today I pushed a pull request to the Domoticz GitHub to add two features I was missing :

### Panasonic remote buttons

It adds customizable buttons to the default remote for Panasonic TVs:

![](/files/2020/12/domoticz_pana_remote_custombuttons.png)

The buttons are customizable in the Panasonic hardware settings:

![](/files/2020/12/domoticz_pana_remote_settings.png)

To be able to use codes that are not known by the plugin there is an option to allow sending unknown commands. There is basic sanitization but as it may cause a security issue there is also a setting to allow or not this behavior.

### URL in Custom menu

It adds the possibility to include URLs in the custom template menu:

![](/files/2020/12/domoticz_externalurl_menu.png)

To do so, just create a file per URL in the www/templates folder with:

- ‘url’ extension
- the title of the link as filename
- the URL as file contents

![](/files/2020/12/domoticz_externalurl_folder.png)

The easiest way to benefit from these two functions is to way for integration in the next version. But if you are impatient, you can build it on your own following the [Domoticz documentation about building from source](https://www.domoticz.com/wiki/Build_Domoticz_from_source)

The PR is here: <https://github.com/domoticz/domoticz/pull/4531>  
My forked repo with the PR already available: [https://github.com/rpeyron/domoticz/ (branch rp-dev-bk20201223)](https://github.com/rpeyron/domoticz/tree/rp-dev-bk20201223)

### Basic UPnP protocol and PHP scripts

And if like me, you are struggling for making clean PRs, the article that saved me: [(stackoverflow) cleanup git master branch and move some commit to new branch](https://stackoverflow.com/questions/5916329/cleanup-git-master-branch-and-move-some-commit-to-new-branch)

I lost a lot of time fighting with Panasonic UPnP protocol and finding new applications product id. I first tried to spy with Wireshark the messages from the Panasonic TV Remote 2 android application, but I only saw TLS messages with an outside server. While writing this post I realize that even on LAN the application may use my Panasonic TV Anywhere account and I should try again with disabling the account. Then I tried to send UPnP with cURL and RESTed chrome extension but it seems that all these tools add unwanted headers and Panasonic’s implementation of UPnP protocol seems to be very badly sensitive about that. I finally found that [PHP script](http://cocoontech.com/forums/topic/21266-panasonic-viera-plasma-ip-control/page-4) that I customized to explore the UPnP API, and after a bit of reverse engineering I finally found the X\_GetAppList command. Below is a PHP script to get the product\_id of the applications available on your Panasonic SmartTV :

```php
<?php
$operation = "X_GetAppList";

$input = "\n";
$input .= "\n";
$input .= "\n";
$input .= "<u: xmlns:u="\"urn:panasonic-com:service:p00NetworkControl:1\"">\n";
$input .= "\n";
$input .= "</u:>$operation>\n";
$input .= "\n";
$input .= "\n\n";

$header = array(
"Content-type: text/xml;charset=\"utf-8\"",
"Accept: text/xml",
"Cache-Control: no-cache",
"Pragma: no-cache",
"SOAPACTION: \"urn:panasonic-com:service:p00NetworkControl:1#$operation\"",
"Content-Length: ".strlen($input),
);
$curl = curl_init();
curl_setopt($curl, CURLOPT_URL, 'http://192.168.0.43:55000/nrc/control_0');
curl_setopt($curl, CURLOPT_POST, 1);
curl_setopt($curl, CURLOPT_HTTPHEADER, $header); 
curl_setopt($curl, CURLOPT_POSTFIELDS, $input);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
  if(($result = curl_exec($curl)) === false) {
    $err = 'Curl error: ' . curl_error($curl);
    curl_close($curl);
    print $err;
  } else {
    curl_close($curl);
    print 'Operation completed without any errors';
	print $result;
  }
?>
```

If you want more information about how I “reverse-engineered” this code (and some other UPnP scripts), I wrote [another post on it](/2020/12/reverse-engineering-tv-remote-panasonic-quelques-techniques-simples/) (in french, but there is a “Google translate” button on the right 🙂 )