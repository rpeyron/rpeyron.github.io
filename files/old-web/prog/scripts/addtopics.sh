#! /bin/sh

# Add Topics to the index.hml generated by IRCstats

INDEXHTML=index.html
IRCLOG=.irclog
RESU=~/public_html/statstopic.html

(
grep -v "</body></html>" $INDEXHTML
echo "Quick AddOn : Topic List !"
echo "</center><ul>"
grep "TOPIC #c00lz" $IRCLOG | sed -e 's/^.*TOPIC #c00lz :\(.*\)$/\1/' | uniq | sed -e 's/</\&lt;/g' -e 's/>/\&gt;/g' | awk '{ print "<li>" $0 "</li>" }' 
echo "</ul>"
echo "</body></html>"
) > $RESU
