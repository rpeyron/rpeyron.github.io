
DF=diff_tmp.txt
RDF1=rediff1.txt
RDF2=rediff2.txt
RDF=diff.txt

PATH=.;$PATH

echo "File 1 $1"
echo "File 2 $2"
echo "File Diff $DF"
echo "Fichier resultat : $RDF"

diff $1 $2 > $DF
cat $DF | grep -e '^>' | cut -b 3- > $RDF1
cat $DF | grep -e '^<' | cut -b 3- > $RDF2
diff $1 $2 > $RDF 
