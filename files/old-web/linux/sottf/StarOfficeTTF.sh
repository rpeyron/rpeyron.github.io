#!/bin/sh
#
# Convert TTFs for StarOffice
#

# Do not forget : ln -s /usr/bin/perl /usr/local/bin/perl
# NO TTF in $TEMP !!!

SO_PATH=/usr/Apps
TEMP=/tmp

FONT=$1;
FONTNAME=$(echo "$1" | sed -e 's/\/.*\///g');
FONTBASE=$(echo "$FONTNAME" | sed -e 's/\.ttf//g');

# This process one file

echo Processing "$FONTBASE" ...

cp "$FONT" "$TEMP"/
ttf2pt1 -b "$FONT" "$TEMP"/"$FONTBASE"
afm.pl "$TEMP"/"$FONTBASE".afm
rm "$TEMP"/"$FONTBASE".afm
mv "$FONTBASE".afm.new "$SO_PATH"/xp3/fontmetrics/afm/"$FONTBASE".afm
mv "$TEMP"/"$FONTBASE".pfb "$SO_PATH"/xp3/pssoftfonts/
echo $(ttmkfdir "$TEMP" | head -n 2 | tail -n 1 | sed -e 's/--.*$//' | sed -e 's/\.ttf/,/')--%d-%d-%d-%d-p-0-iso8859-1 >> "$SO_PATH"/xp3/psstd.fonts 
rm "$TEMP"/"$FONTNAME"
