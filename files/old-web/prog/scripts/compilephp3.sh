#!/bin/sh
#
# Compile PHP3 -> HTML
#

find . | grep "\.php3$" | sed 's/\.php3//' | while read FILE
do 
  echo Processing $FILE...
  REP=$(echo "$FILE" | sed 's/\(.*\/\).*/\1/');
  FF=$(echo "$FILE" | sed 's/\(.*\/\)//');
  pushd $REP > /dev/null
 (  echo "<? \$REQUEST_URI=\"$FILE.php3\"; \$SCRIPT_FILENAME=\"$FF.php3\"; \$compile= true;?>" "$(cat $FF.php3)"  | php3 -q | sed 's/\.php3\"/.html\"/g') > $FF.html
  popd > /dev/null
done


# Delete all php3 config files, converted
rm -f *.html

# Redir 
cp -f index.html.redirphp3 index.html



echo Done.
