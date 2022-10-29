---
post_id: 1401
title: 'Normalize artists names with Musicbrainz'
date: '2012-05-28T18:45:00+02:00'

author: 'Rémi Peyronnet'
layout: post
guid: '/2012/05/normaliser-les-artistes-mp3-avec-musicbrainz/'
slug: normaliser-les-artistes-mp3-avec-musicbrainz
permalink: /2012/05/normaliser-les-artistes-mp3-avec-musicbrainz/
tc-thumb-fld: 'a:2:{s:9:"_thumb_id";s:4:"1678";s:11:"_thumb_type";s:5:"thumb";}'
post_slider_check_key: '0'
image: /files/2017/10/playlist_1507997321.jpg
categories:
    - Informatique
tags:
    - Blog
lang: en
toc: false
---

Nothing is worse than a MP3 library with different artist spellings : a same artist will be present two or three times in the list. Thanks to Musicbrainz it is possible to normalize the spelling. This script search on musicbrainz all your files and tries to get the correct spelling of the artist. It outputs a batch file that you can check before running.

Note this is mainly for singles. For albums, consider using the excellent software Picard.

# Source Code

mp3-checkartist.py

```
#! /usr/bin/python
# (c) 2008 - Remi Peyronnet <remi.peyronnet@via.ecp.fr>
# coding = latin-1
 
SOURCE_PATH = "."
DEST_PATH = "_renamed"
EXT_FILTER = ['.mp3','.wma','.ogg','.mpeg','.avi','.mpg']
CACHE_PATH = "/space/Musique/.mbcache"
IGNORE_PATH = CACHE_PATH + "/ignore.txt"
 
import os
import os.path
import shutil
import hashlib
from ID3 import *
import string
import time
import re
import sys
import pickle
 
from musicbrainz2.webservice import Query, ArtistFilter, WebServiceError
 
regex = re.compile('(?P<date>....-..-..) - (?P<type>Clip|CLIP|Live) - (?P<genre>Goldorama|Clubbing)?( - )?(?P<artist>[^-]*)-(?P<title>.*).mp3');
 
fignore = open(IGNORE_PATH,'r')
ignorefile = fignore.read()
ignore = ignorefile.split("n")
fignore.close()
 
import sys
import codecs
sys.stdout=codecs.getwriter('utf-8')(sys.stdout)
 
def processFile(pathfile, path, file):
    global regex
    global ignore
    global CACHE_PATH
    id3info = None
    try:
        id3info = ID3(pathfile)
    except:
        #print "Skip " + pathfile
        pass
    if id3info:
      if id3info.artist:
        try:
          artist_id3 = id3info.artist.decode('utf-8')
        except:
          artist_id3 = id3info.artist.decode('latin-1')      
        if artist_id3 in ignore:
          print "# Ignoring " + artist_id3
        else:
          artistResults = None
          #print "Checking " + id3info.artist + " (" + file + ")"
          artistmd5 = hashlib.md5(id3info.artist).hexdigest()
          cachefile = CACHE_PATH + "/artist" + artistmd5
          if os.path.exists(cachefile):
            cachefd = open(cachefile,'rb')
            artistResults = pickle.load(cachefd)
            cachefd.close()
          else:
            # Be sure not to ask too frequently
            time.sleep(1)
            try:
                artistResults = Query().getArtists(ArtistFilter(name=artist_id3, limit=5))
            except WebServiceError, e:
                print 'WS Error', e
            if artistResults:
                file = open(cachefile,'wb')
                pickle.dump(artistResults,file)
                file.close()
          if artistResults:
            found=0
            for result in artistResults:
                if result.artist.name == artist_id3:
                    found=1
            artist_mb = artistResults[0].artist.name
            artist_mbscore = artistResults[0].score
            if found==0:
                print "# Musicbrainz knows " + artist_mb + " instead of " + artist_id3 + " (", artist_mbscore,"%)"
                print "id3v2 -a "" + artist_mb + "" "" + pathfile.decode('utf-8') + """
                for result in artistResults:
                    artist = result.artist
                    #print "   " , result.score , "% : " + artist.name
                    #print "Id        :", artist.id
                    #print "Name      :", artist.name
                    #print "Sort Name :", artist.sortName
                   # print
 
def processPath(path):
    str = ""
    files = os.listdir(path)
    files.sort()
    for file in files:
        (base, ext) = os.path.splitext(file)
        pathfile = os.path.join(path,file);
        if (os.path.isdir(pathfile)):
            str += processPath(pathfile)
        if (os.path.isfile(pathfile)):
            processFile(pathfile, path, file)
    return ""
 
# Auto Launch
if __name__ == "__main__":
    processPath(SOURCE_PATH);

```