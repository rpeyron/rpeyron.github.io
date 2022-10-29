#!/bin/sh

#
# This script will expand tabs (with expand)
#

FILES="*.cpp *.h"
TABSIZE="4"

find $FILES | while read FILE 
do
 echo Expanding $FILE ...
 mv $FILE $FILE.bak
 expand -t $TABSIZE $FILE.bak > $FILE 
 rm $FILE.bak
done
