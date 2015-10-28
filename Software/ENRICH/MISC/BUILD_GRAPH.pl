$first_term = "GO:0005575";
open(MEANING,"$ARGV[1]");
open(USED,"$ARGV[2]");
while($used=<USED>){@used=split(/\t/,$used);$used{$used[0]}=1;}
while($meaning=<MEANING>){chomp($meaning);@meaning=split(/\t/,$meaning);if($used{$meaning[0]}){$meaning{$meaning[0]} = $meaning[4];}}

open(FILE,"$ARGV[0]");
while($file=<FILE>)
{
chomp($file);
@file=split(/\t/,$file);
@re=split(/;/,$file[1]);
$t=0;
$string="";
while($t<@re)
{
 if($used{$re[$t]}){$string=$string."$re[$t];";}
 $t++;
}
 $string=~s/;$//;

if($used{$file[0]} and $string){
$children{$file[0]} = $string;}
}

add_child_recursively($first_term);

sub add_child_recursively
{
 my $term= $_[0];
 if($children{$term}){
 my @children = split(/;/,$children{$term});
 print "{\"name\" : \"$meaning{$term}\" , \"title\" : \" $term P.VAL = ##PVAL\",\"color\" : \"##COLOR\",\"children\" : \n\t[";

  my @children = split(/;/,$children{$term});

   my $i=0;
   while($i<@children)
   {add_child_recursively($children[$i]);$i++;}
   print "]";
 }
  else{print "{\"name\" : \"$meaning{$term}\" , \"title\" : \" $term P.VAL =##PVAL\",\"color\" : \"##COLOR\",\n";}

   print "\},";
}



