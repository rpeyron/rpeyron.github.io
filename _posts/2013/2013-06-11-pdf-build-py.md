---
post_id: 1402
title: 'PDF Build'
date: '2013-06-11T16:52:00+02:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/2013/06/pdf-build-py/'
slug: pdf-build-py
permalink: /2013/06/pdf-build-py/
tc-thumb-fld: 'a:2:{s:9:"_thumb_id";s:4:"1648";s:11:"_thumb_type";s:5:"thumb";}'
post_slider_check_key: '0'
image: /files/2017/10/pdf_1507994789.png
categories:
    - Informatique
tags:
    - Blog
lang: en
---

It is a simple script to create a pdf from a tree of images.  
An outline will be produced, according to the tree, with :

- for a folder : the name of the folder
- for a file : the first found of : ImageDescription Exif tag, JPEG comment, filename (without extension)

In a folder, the files are alphabetically sorted and folders are processed first.  
For items provided on the command line, no sort is applied, you must sort yourself according your wish.

```python
#! /usr/bin/python
# -*- encoding: utf-8 -*-
 
"""
 
(c) 2013 - Rémi Peyronnet
 
pdf-build.py -o output.pdf  files or folder to include
 
Other usefull tools :
 - extract images from pdf : 
        pdfimages  <pdf> <prefix>    (with -j for jpeg)
 - pdftk  to uncompress / compress
 
 Examples :
 pdf-build.py --convert="-resample 150 -quality 80%" Classeur MPSI/* -o ClasseurMPSI.pdf -t "Classeur MPSI" -a "Rémi Peyronnet" -p
 
"""
 
import os
import os.path
import sys
import argparse
import subprocess
 
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import A4
from reportlab.lib.utils import haveImages
from reportlab.lib.units import cm, inch
from reportlab import rl_config
 
from PIL import Image
from PIL.ExifTags import TAGS
 
# No A85 encoding, to save 1/5 space
rl_config.useA85 = 0
 
pageSize = A4
cur_page = 0
cur_dir = 0
 
def getCurBkKey():
    global cur_page
    return "p%d" % cur_page
 
def preparePage(canvas):
    global cur_page
 
    cur_page = cur_page + 1
    canvas.bookmarkPage(getCurBkKey())
 
def processFile(canvas, file, args, level=0):
    global pageSize
 
    if args.verbose: print "Processing file <%s> / %d" % (file, level)
 
    if args.convert:
        (file_base, file_ext) = os.path.splitext(file)
        tmpfile = file_base + ".tmp" + file_ext
        command = ['convert',file] + args.convert.split(" ")+ [tmpfile]
        try:
            out = subprocess.check_output(command,stderr=subprocess.STDOUT)
        except subprocess.CalledProcessError as e:
            print "Error in picasa (%r) : %s" % (command, e.output)
            raise
        if os.path.exists(tmpfile):
            file = tmpfile
        else:
            print "Error converting <%s> : %s" % out
 
    try:
        img = Image.open(file)
    except:
        if args.verbose: print "Error <%s> : unable to open the file" % file
        return
 
    if "_getexif" in dir(img):
        exif = img._getexif()
    else:
        exif = {}
        if args.verbose: print "Warning <%s> : no exif found" % file
 
    (img_width, img_height) = img.size
 
    # Get Title : exif ImageDescription -> jpeg comment -> filename
    title = ""
    if len(title) == 0:
        if 270 in exif:
            title = exif[270].decode('utf-8')
    if len(title) == 0:
        if ("app" in dir(img)) and ("COM" in img.app):
            title = img.app["COM"].decode(args.jpeg_comment_encoding)
    if len(title) == 0:
        (path_, basename) = os.path.split(file)
        (name, ext_) = os.path.splitext(basename)
        title = name
 
    # Get Page Size
    if args.pagesize_from_exif:
        # Get X/Y Resolution and unit
        if 282 in exif:
            exif_x_resolution = exif[282]
        else:
            exif_x_resolution = (72, 1)
            if args.verbose: print "Warning <%s>: no X resolution, using default." % file
        if 283 in exif:
            exif_y_resolution = exif[283]
        else:
            exif_y_resolution = (72, 1)
            if args.verbose: print "Warning <%s>: no Y resolution, using default." % file
        exif_unit = inch
        if (296 in exif) and (exif[296] == 3):
            exif_unit = cm
        page_xres = (img.size[0] / (exif_x_resolution[0] / exif_x_resolution[1])) * exif_unit
        page_yres = (img.size[1] / (exif_y_resolution[0] / exif_y_resolution[1])) * exif_unit
    else:
        if (img_width > img_height):
            page_xres = pageSize[1]
            page_yres = pageSize[0]
        else:
            page_xres = pageSize[0]
            page_yres = pageSize[1]
 
    canvas.addOutlineEntry(title,getCurBkKey(), level, 0)
    canvas.setPageSize((page_xres, page_yres))
    canvas.drawImage(file, 0, 0, page_xres, page_yres, preserveAspectRatio=True)
    canvas.showPage()
    preparePage(canvas)
 
    if args.convert:
        if os.path.exists(tmpfile):
            os.unlink(tmpfile)
 
def processPath(canvas, path, args, level=0):
    global cur_dir
 
    if os.path.isdir(path):
        cur_dir = cur_dir + 1
        dir_bk = "d%d" % cur_dir
        (rootpath_, name) = os.path.split(path)
        canvas.bookmarkPage(dir_bk)
        canvas.addOutlineEntry(name, dir_bk, level, False if level < args.open_levels else True)
        files = []
        lst = os.listdir(path)
        lst.sort()
        #Traverse dir and process folders before files
        for file in lst:
            if os.path.isdir(os.path.join(path,file)):
                processPath(canvas, os.path.join(path,file), args, level+1)
            else:
                files.append(file)
        # Process files
        for file in files:
            processFile(canvas, os.path.join(path,file), args, level+1)
    else:
        processFile(canvas, path, args, level)
 
def process(args):
    c = canvas.Canvas(args.output)
    c.setPageCompression(1)
    c.setAuthor(args.set_author)
    c.setCreator(args.set_creator)
    c.setSubject(args.set_subject)
    c.setTitle(args.set_title)
    for (index, file) in enumerate(args.files):
        preparePage(c)
        processPath(c,file,args,0)
    c.showOutline()
    c.save()
 
if not haveImages:
    print "You don't have support for images ; please install PIL"
    sys.exit(1)
 
parser = argparse.ArgumentParser("Construct flat album folders to import photos in Picasa")
parser.add_argument("-o", "--output", default="output.pdf", help="Filename of output file")
parser.add_argument("-v", "--verbose", action="store_true", help="Verbose mode")
parser.add_argument("-p","--pagesize-from-exif", action="store_true", help="Set the PDF pagesize according the size of the image")
parser.add_argument("-a","--set-author", default="", help="Set the the Author metatag")
parser.add_argument("--set-creator", default="pdf-build", help="Set the Creator metatag")
parser.add_argument("--set-subject", default="", help="Set the Subject metatag")
parser.add_argument("--jpeg-comment-encoding", default="latin1", help="Set encoding of JPEG comments")
parser.add_argument("-t","--set-title", default="", help="Set the Title metatag")
parser.add_argument("-c","--convert", default="", help="Convert image with ImageMagick's convert before inclusion (provide conversion string)")
parser.add_argument("-l","--open-levels", type=int, default=0, help="Number of levels to open in outline")
parser.add_argument("files", help="Images files to include", nargs="*")
args = parser.parse_args()
 
process(args)
```