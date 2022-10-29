---
post_id: 1384
title: 'DynDns Autologin'
date: '2013-05-27T14:57:00+02:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/2013/05/dyndns-autologin/'
slug: dyndns-autologin
permalink: /2013/05/dyndns-autologin/
tc-thumb-fld: 'a:2:{s:9:"_thumb_id";s:4:"1654";s:11:"_thumb_type";s:5:"thumb";}'
post_slider_check_key: '0'
image: /files/2017/10/robot_1507995213.jpg
categories:
    - Informatique
tags:
    - Blog
lang: en
---

[Dyn.com](http://dyn.com "http://dyn.com") has been for years a great DynDns service, offering for free this useful service. But this has changed some years ago, when dyn.com started to push its commercial offer. Now, dyn.com forces free users to log in once in a month, otherwise the account and its services is simply deleted. It seems to me absolutely inacceptable and as their paid service is much more expansive that fixed domains or other dyndns services, I decided to change. But to facilitate transition, I want to keep my dyn.com account alive. I found a great script on [http://technologicalresolution.blogspot.fr/2013/05/dyndns-auto-logon.html](http://technologicalresolution.blogspot.fr/2013/05/dyndns-auto-logon.html "http://technologicalresolution.blogspot.fr/2013/05/dyndns-auto-logon.html"). It was originally designed for Google App Engine, below is a standalone version.

# How ?

Just follow the steps below to set up :

1. Download the `DynDnsAutoLogin.java` file below.
2. Install the java Jsoup library (apt-get libjsoup-java on debian/ubuntu systems, or download it on [http://jsoup.org/](http://jsoup.org/ "http://jsoup.org/"))
3. Compile the code : `javac -cp /usr/share/java/jsoup.jar DynDnsAutoLogin.java` (if you downloaded jsoup, you may replace the classpath with the appropriate path to jsoup.jar)
4. Create a `DynDnsAutoLogin.properties` file, with your username and password ; this file will be search in the working directory while running DynDnsAutoLogin :

DynDnsAutoLogin.properties

```
username=your_username
password=your_password
```

You now can launch it yourself :

```
java -cp /usr/share/java/jsoup.jar:. DynDnsAutoLogin
```

or add it to your crontab (example here if in your ~/bin path, to run it once a week at midnight) :

```cron
0 0 * * 1 cd ~/bin && java -cp /usr/share/java/jsoup.jar:. DynDnsAutoLogin
```

# Source code

DynDnsAutoLogin.java

```java
import java.lang.*;
import java.net.*;
import java.io.*;
import java.util.Properties;
import org.jsoup.Jsoup;
import org.jsoup.nodes.*;
import org.jsoup.select.*;
 
/*
Use :
1/ apt-get install libjsoup-java
2/ javac -cp /usr/share/java/jsoup.jar DynDnsAutoLogin.java
3/ create DynDnsAutoLogin.properties with username and password :
username=your_username
password=your_password
 
4/ java -cp /usr/share/java/jsoup.jar:. DynDnsAutoLogin
 
or add to crontab :
 
1 1 * * 1 cd ~/bin && java -cp /usr/share/java/jsoup.jar:. DynDnsAutoLogin
 
*/
 
public class DynDnsAutoLogin  {
 
 
public static void main(<a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+string" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+string">String</a>[] args) {
try {
 
<a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+properties" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+properties">Properties</a> prop = new <a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+properties" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+properties">Properties</a>();
prop.load(new <a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+fileinputstream" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+fileinputstream">FileInputStream</a>("DynDnsAutoLogin.properties"));
<a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+string" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+string">String</a> username = prop.getProperty("username");
<a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+string" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+string">String</a> password = prop.getProperty("password");
 
// ---- From http://technologicalresolution.blogspot.fr/2013/05/dyndns-auto-logon.html
 
<a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+url" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+url">URL</a> url = new <a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+url" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+url">URL</a>("https://account.dyn.com/entrance/");
<a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+httpurlconnection" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+httpurlconnection">HttpURLConnection</a> con = (<a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+httpurlconnection" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+httpurlconnection">HttpURLConnection</a>) url.openConnection();
con.setRequestMethod("GET");
//Spoof as if from a web browser
con.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.64 Safari/537.31");
con.setDoOutput(true);
con.connect();
// give it 15 seconds to respond
con.setReadTimeout(15 * 1000);
 
//Get cookie id
<a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+string" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+string">String</a> headerName = null;
<a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+string" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+string">String</a> cookie = null;
for(int i = 1; (headerName = con.getHeaderFieldKey(i)) != null; i++) 
{
 if (headerName.equalsIgnoreCase("Set-Cookie")) 
 {                  
  cookie = con.getHeaderField(i);
  break;
 }
}
 
//Read the website into a string so we can parse with Jsoup
<a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+bufferedreader" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+bufferedreader">BufferedReader</a> reader = new <a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+bufferedreader" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+bufferedreader">BufferedReader</a>(new <a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+inputstreamreader" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+inputstreamreader">InputStreamReader</a>(con.getInputStream()));
<a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+string" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+string">String</a> temp = "";
<a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+string" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+string">String</a> line = null;
while((line = reader.readLine()) != null)
{
 temp += line + "rn";
}
reader.close();
 
<a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+document" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+document">Document</a> doc = Jsoup.parse(temp);
Elements els = doc.getElementsByTag("input");
<a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+string" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+string">String</a> multiform = null;
for(<a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+element" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+element">Element</a> e : els)
{
 <a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+string" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+string">String</a> name = e.attr("name");
 <a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+string" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+string">String</a> value = e.attr("value");
 //Get the hidden field required for login
 if(name.equalsIgnoreCase("multiform"))
 {
  multiform = value;
  break;
 }
}
 
//Open the connection again with the correct headers
con = (<a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+httpurlconnection" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+httpurlconnection">HttpURLConnection</a>) url.openConnection();
con.setRequestProperty("Cookie", cookie);
con.setRequestProperty("Host", "account.dyn.com");
con.setRequestProperty("Origin", "https://account.dyn.com");
con.setRequestProperty("Referer", "https://account.dyn.com/entrance/");
con.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.64 Safari/537.31");
con.setRequestMethod("POST");
con.setDoOutput(true);
 
//String username = "your_username_here";
//String password = "your_password_here";
 
//Set the login fields
<a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+outputstreamwriter" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+outputstreamwriter">OutputStreamWriter</a> out = new <a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+outputstreamwriter" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+outputstreamwriter">OutputStreamWriter</a>(con.getOutputStream());
<a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+string" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+string">String</a> data = 
 <a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+urlencoder" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+urlencoder">URLEncoder</a>.encode("username", "UTF-8")
 + "="
 + <a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+urlencoder" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+urlencoder">URLEncoder</a>.encode(username, "UTF-8");
 data += "&"
 + <a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+urlencoder" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+urlencoder">URLEncoder</a>.encode("password", "UTF-8")
 + "="
 + <a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+urlencoder" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+urlencoder">URLEncoder</a>.encode(password, "UTF-8");
 data += "&"
 + <a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+urlencoder" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+urlencoder">URLEncoder</a>.encode("submit", "UTF-8")
 + "="
 + <a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+urlencoder" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+urlencoder">URLEncoder</a>.encode("Log in", "UTF-8");
 data += "&"
 + <a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+urlencoder" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+urlencoder">URLEncoder</a>.encode("multiform", "UTF-8")
 + "="
 + <a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+urlencoder" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+urlencoder">URLEncoder</a>.encode(multiform, "UTF-8");
out.write(data);
out.flush();
out.close();
 
//Read the response message
reader = new <a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+bufferedreader" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+bufferedreader">BufferedReader</a>(new <a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+inputstreamreader" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+inputstreamreader">InputStreamReader</a>(con.getInputStream()));
boolean success = false;
while((line = reader.readLine()) != null)
{
 //If the title says we are logged in everything worked
 if(line.contains("<title>My Dyn Account</title>"))
 {
  success = true;
  break;
 }
}
 
if(success)
{
 <a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+system" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+system">System</a>.out.println("Succesfully logged in!");
}
else
{
 <a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+system" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+system">System</a>.out.println("Login failed!");
}
 
reader.close();
 
// ---- From http://technologicalresolution.blogspot.fr/2013/05/dyndns-auto-logon.html
} catch (<a href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+exception" data-mce-href="http://www.google.com/search?hl=en&q=allinurl%3Adocs.oracle.com+javase+docs+api+exception">Exception</a> e)
{
	e.printStackTrace();
}
}
}
```