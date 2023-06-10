---
post_id: 4473
title: 'exiftool config file to rename files with Title on Windows'
date: '2020-09-05T17:57:09+02:00'
last_modified_at: '2021-06-12T19:30:16+02:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=4473'
slug: exiftool-config-file-to-rename-files-with-title-on-windows
permalink: /2020/09/exiftool-config-file-to-rename-files-with-title-on-windows/
image: /files/2020/09/1_OKv5rKcj2JRI5jhQoQhdJQ.png
categories:
    - Informatique
tags:
    - Photo
    - exif
    - exiftool
    - Script
    - Tag
lang: en
---

[ExifTool](https://exiftool.org/) is a great command line tool to manipulate image tags. It is also capable of renaming files with any tag, but is not able to write files if the new filename is not compliant to the filesystem. As I want to use the title of my photo in the filename, it is sadly common with Windows filesystems.

But luckily, exiftool provides a way to add custom tags programmatically with perl, with config files. Below is a config file that will add a tag TitleWindows that will convert the Title tag in a string compatible with Windows filesystem, with all forbidden chars deleted, and a limit in the filename (with nice truncate at a word when possible).

```perl
%Image::ExifTool::UserDefined = (
    'Image::ExifTool::Composite' => {
		# Valid Title for Windows Filename  (c) 2020 - Remi Peyronnet
        TitleWindows => {
            Require => 'Title',
			ValueConv => q{ 
				# Maximum length
				my $maxlen=70;
				# Forbidden chars in Windows filename
				my $forbidden = ('\/:*?"<>|'); 
				# Replace forbidden chars
				$val =~ s/[\\x00-\\x1f{$forbidden}]//g; 
				# No filename with trailing space
				$val =~ s/ *$//g; 
				# Truncate if too long
				if ( length($val) > $maxlen ) {
					$val = substr($val, 0, $maxlen - 3);
					#Truncate on last space
					$i = rindex($val, ' ');
					if ($i > 2) {
						$val = substr($val, 0, $i);
					}
					$val = $val . '...';
				}
				# Return value
				$val;
			},
        },
    },
);
```

To use it, copy it in your folder (or another location provided you change the path), and use the command below :

```
exiftool -config exiftool-rename.txt  -s -G <yourimage>
```

You will see that this script have added an extra tag :

```
[Composite] TitleWindows : Chenonceau - Chateau...
```

This TitleWindows new tag can now be used in any file name pattern and will be valid on Windows filesystems. It will strip nasty “:”, “/”, “?”, and any other forbidden characters. It will also truncate the title if it is too long (see $maxlen parameter) and if possible aligned on a word.

Here is a sample to rename with it :

```
exiftool -config exiftool-rename.txt -m -overwrite_original_in_place -d '%Y-%m-%d %H-%M-%S'  '-FileName<${DateTimeOriginal} - ${TitleWindows} - %f.%e' -r -ext jpg *
```

- `-config exiftool-rename.txt` to use the above script
- `-m` to tell exiftool to ignore minor errors: a missing tag will be silently replaced with an empty string
- `-overwrite_original_in_place` to overwrite the file without backup
- `-d ‘%Y-%m-%d %H-%M-%S’` specifies the date format
- `‘-FileName<${DateTimeOriginal} – ${TitleWindows} – %f.%e’` will rename the file with the provided pattern. You may use `TestName` to make some dryruns to test. Note special tags `%f` for the filename without extension, and `%e` for the extension
- `-r` will proceed recursively
- `-ext jpg` will only process files with jpg extension
- `*` is the list of your files

If you want to be able to run this multiple times to improve it, I suggest you backup the current filenames of your files in the DocumentName tag with the command :

```
exiftool -r -overwrite_original_in_place -DocumentName<FileName *
```

and then use ${DocumentName} in your pattern instead of %f.%e . If you have forgotten to do so and use Darktable, you may recover the original filename in the tag DerivedFrom.

Also, to copy the comment from a JPEG tag to Exif while keeping correct encoding :

```
exiftool -r -overwrite_original_in_place -Copyright="(c) 2020" -Title<Comment -Description<Comment -Charset cp1252 *
```

Please note the -Charset option to allow correct encoding (be sure to use yours). Please note that the default Windows charset terminal is not UTF-8, so you may also use this option to see correctly the contents of your tags (`-Charset 850` by default fo France) . You may also try `chcp 65001` to convert your terminal to UTF-8.

Also note that some software may use Title and other Description (Google Photos for instance). That is why I always duplicate my comments in JPEG comment, Title and Description. Not optimal, but the most compatible…

Last tip with exiftool, use `-s -G` parameters to get the actual tag name to use in the command line and not their display names.

Sources :

- ExifTool: <https://exiftool.org/>
- Example config: <https://www.exiftool.org/config.html>
- Multiline in perl: <https://exiftool.org/forum/index.php?topic=8208.0>