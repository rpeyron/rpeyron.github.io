#!/usr/local/bin/perl

use File::Basename;

%header = ();
%orgcomm = ();
$orgname = basename($ARGV[0],'');
print "Staroffice afm font file analyze utility.\n";
print "Written by Thomas Bartschies in 1997\n\n";
if ($orgname eq '' || $orgname !~ /\.afm/ ) {
      die "Usage: afm.pl <.afm Filename>\n\n";
}
print "reading afm header...";
while ($_ = <>) {
      chop($_);
      if($_ =~ /^StartCharMetrics.*/i) { last; }
      /^(\w+) (.*)$/ && ($command=$1,$parameter=$2);
      if ($command eq 'Underline' || $command eq 'Encoding') {
         $_ = $parameter;
         /^(\w+) (.*)$/ && ($command.=$1,$parameter=$2);
      }
      if (!exists $header{lc($command)}) {
         $header{lc($command)} = $parameter;
         $orgcomm{lc($command)} = $command;
      }
}
print "done\n";
print "analyzing afm header...";
if (exists $header{startfontmetrics}) { 
   delete $header{startfontmetrics};
}
open(OUT, ">$orgname.new");
print OUT "StartFontMetrics 2.0\n";
if (exists $header{comment}) {
   print OUT "Comment $header{comment}\n";
   delete $header{comment};
}
if (exists $header{fontname}) {
#   $header{fontname} =~ s/(\w+).*/$1/;
   print OUT "FontName $header{fontname}\n";
   delete $header{fontname};
} else {
   die "afm :Fontname not found. unrecoverable error!\n";
}
if (exists $header{fullname}) {
#   $header{fullname} =~ s/(\w+).*/$1/;
   print OUT "FullName $header{fullname}\n";
   delete $header{fullname};
} else {
   die "afm :Fullname not found. unrecoverable error!\n";
}
if (exists $header{familyname}) {
#   $header{familyname} =~ s/(\w+).*/$1/;
   print OUT "FamilyName $header{familyname}\n";
   delete $header{familyname};
} else {
   print OUT "FamilyName freefont\n";
}
if (exists $header{weight}) {
   $header{weight} = ucfirst($header{weight});
   print OUT "Weight $header{weight}\n";
   delete $header{weight};
}
if (exists $header{notice}) {
   print OUT "Notice $header{notice}\n";
   delete $header{notice};
} else {
   print OUT "Notice no notice found\n"; 
}
if (exists $header{italic} || exists $header{italicangle}) {
   if (exists $header{italicangle}) {
      $header{italicangle} =~ s/^(\d+).*/$1/;
      print OUT "ItalicAngle $header{italicangle}\n";
      delete $header{italicangle};
   } else {
      print OUT "ItalicAngle 0\n";
      delete $header{italic};
   }
} else {
   print OUT "ItalicAngle 0\n";
}
if (exists $header{isfixedpitch} || exists $header{is}) {
   if (exists $header{isfixedpitch}) {
      print OUT "IsFixedPitch $header{isfixedpitch}\n";
      delete $header{isfixedpitch};
   } else {
      print OUT "IsFixedPitch false\n";
      delete $header{is};
   }
} else {
   print OUT "IsFixedPitch false\n";
}
if (exists $header{underlineposition}) {
   print OUT "UnderlinePosition $header{underlineposition}\n";
   delete $header{underlineposition};
}
if (exists $header{underlinethickness}) {
   print OUT "UnderlineThickness $header{underlinethickness}\n";
   delete $header{underlinethickness};
}
print OUT "Version 001.000\n";
if (exists $header{version}) {
   delete $header{version};
}
if (exists $header{encodingscheme}) {
   if($header{encodingscheme} ne 'AdobeStandardEncoding' &&
      $header{encodingscheme} ne 'AppleStandard') {
      print OUT "EncodingScheme AdobeStandardEncoding\n";
   } else {
      print OUT "EncodingScheme $header{encodingscheme}\n";
   }
   delete $header{encodingscheme};
} else {
   print OUT "EncodingScheme AdobeStandardEncoding\n";
}
if (exists $header{fontbbox}) {
   print OUT "FontBBox $header{fontbbox}\n";
   delete $header{fontbbox};
}
if (exists $header{capheight}) {
   print OUT "CapHeight $header{capheight}\n";
   delete $header{capheight};
}
if (exists $header{xheight}) {
   print OUT "XHeight $header{xheight}\n";
   delete $header{xheight};
}
if (exists $header{descender}) {
   print OUT "Descender $header{descender}\n";
   delete $header{descender};
}
if (exists $header{ascender}) {
   print OUT "Ascender $header{ascender}\n";
   delete $header{ascender};
}
foreach $val (keys %header) {
   print OUT "$orgcomm{$val} " . delete($header{$val}) . "\n";
}
print "done\n";
print "reading font data...";
@metrics = %orgcomm = ();
$counter = 0;
while ($_ = <>) {
   chop($_);
   if ($_ =~ /^EndCharMetrics.*/i) { last; }
   $val = $_;
   $val =~ s/.*\;\s*N\s*(\w*)\s*\;.*/$1/;
   if ($val ne '') {
       push(@metrics, $_);
       $counter++;
   }
}
print "done\n";
print "writing font data...";
if ($counter > 0) {
   print OUT "StartCharMetrics $counter\n";
   print OUT "$val\n" while defined($val = shift(@metrics));
   print OUT "EndCharMetrics\n";
}
print "done\n";
print "analyzing kernel pairs...";
$kerndata = $kernpairs = 0;
@metrics = ();
while ($_ = <>) {
   chop($_);
   if ($_ =~ /^EndFontMetrics.*/i) {
       last;
   } elsif ($_ =~ /^StartKernData.*/i) {
       print OUT "StartKernData\n";
       $kerndata = 1;
   } elsif ($_ =~ /^StartKernPairs.*/i) {
       while ($_ = <>) {
           chop($_);
           if ($_ =~ /^Start.*/i || $_ =~ /^End.*/i) { last; }
           if ( length($_) > 5 ) {
              push(@metrics, $_);
              $kernpairs++;
           }
       }
   }
}
print "done\n";
print "writing kernel pairs...";
print OUT "StartKernPairs $kernpairs\n";
print OUT "$val\n" while defined($val = shift(@metrics));
print OUT "EndKernPairs\n";
print "done\n";
if ($kerndata == 1) {
   print OUT "EndKernData\n";
}
print OUT "EndFontMetrics\n";
close(OUT);
print "finished. File \"$orgname.new\" created.\n";
