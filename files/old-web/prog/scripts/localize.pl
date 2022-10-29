#! /usr/bin/perl

# This script aims at replacing full address of sites
#  by relatives addresses

# (c) 2001 - Rémi Peyronnet, remi@via.ecp.fr http://www.via.ecp.fr/~remi

# Useful scripts
#  find doc -exec ./localize.pl '{}' \;
#  ls | while read FILE; do mv $FILE $(echo $FILE | sed -e 's/[?=&]/_/g'); done
#  find doc -name \*.bak --exec rm '{}' \;

$toRemove = "/cgi-bin/dwww?type=runman&location=";
$srcRep = 4;
$removeChr = "[?&=]";
$dstExt = ".bak";
$file=@ARGV[0];

die "Skip : Repertoire." if -d $file;

@tab=split(/\//,$file);
$nbrep = @tab;
for ($srcRep..$nbrep) { $root .= "../"; }

print $nbrep;
print $root;
print $file;


rename $file, $file.$dstExt or die "Probleme lors du renommage";
open (SRC, $file.$dstExt) or die "Ouverture source impossible.";
open (DST, ">".$file) or die "Ouverture cible impossible.";

while (<SRC>)
{
 $resu = "";
 $tst=$_;
 while ( $tst =~ m/^(.*<a [^>]*href=")([^">]*)("[^>]*>.*)$/gi )
 {
   #print $1."|".$2."|".$3;
   $resu .= $1;
   $rep = $2;
   $tst=$3;
   $rep =~ s/$removeChr/_/gi;
   $repl = $root."cgi-bin";
   $rep =~ s/"\/cgi-bin/"$repl/g;
   $resu .= $rep;
 }
 $resu .= $tst;
 $li = $resu;
 print DST $li;
}

close (DST);
close (SRC);

