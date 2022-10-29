#!/bin/sh
#
# Batch
#

$SOPATH=/usr/Apps

cp $SOPATH/xp3/psstd.fonts.orig $SOPATH/xp3/psstd.fonts

find $1 | grep "\.ttf" | while read FILE 
do
 StarOfficeTTF.sh "$FILE"
done
