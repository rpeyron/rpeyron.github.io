#! /usr/bin/sh
#
# Resplit diff output :
#  $1 : Diff output
#  $2 : File part before
#  $3 : File part after

cat $1 | grep -e '^>' | cut -b 3- > $2
cat $1 | grep -e '^<' | cut -b 3- > $3
