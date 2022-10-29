sed 's/$//g' "$1" >| "$1".tmp
mv "$1" "$1".dos
mv "$1".tmp "$1"
