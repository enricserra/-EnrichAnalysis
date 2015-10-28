sub  create_json_nested_graph
{
  my $GO_category = $_[0];
  close(OUT);
  open(OUT,">$_[1]");
  load_map($GO_category);
  add_child_recursively($GOFIRST{$GO_category});
}


sub load_map{
open(MAP, "$gomap_path{$_[0]}");
while(my $map = <MAP>)
{
  chomp($map);
  my @map = split(/\t/,$map);
  my @mapchilds = split(/;/,$map[1]);
  my $i = 0;
  my $string="";

  while($i < @mapchilds)
  {
    if($GOfound{$mapchilds[$i]})
    {
      $string = $string."$mapchilds[$i];";
    }
    $i++;
  }
  $string =~s/;$//;
  if($GOfound{$map[0]} and $string)
  {
    $children{$map[0]} = $string;
  }
}
}

sub add_child_recursively
{
 my $term= $_[0];
 if($children{$term}){
 $color = generate_colors_from_pvals($GOfound{$term});
 print OUT "{\"name\":\"meaning\",\"title\":\" $term P.VAL = $GOfound{$term}\",\"color\" : \"$color\",\"children\" :[\n\t";

  my @children = split(/;/,$children{$term});

   my $i=0;
   while($i<@children)
   { if($i>0 and $i<@children){print OUT ",";}
   add_child_recursively($children[$i]);$i++;}
   print OUT "]\n";
 }
 
 else{print OUT "{\"name\":\"$meaning{$term}\",\"title\":\" $term P.VAL = $GOfound{$term}\",\"color\":\"$color\"";}
 print OUT "\}\n";
}


sub generate_colors_from_pvals
{  my $pval=$_[0]*15;my $rounded_green = int($pval + 0.5);my $rounded_red=15-$rounded_green;my $hex_red=sprintf("%x",$rounded_red);my $hex_green=sprintf("%x",$rounded_green);my $string="#"."$hex_red"."$hex_red"."$hex_green"."$hex_green"."00";return($string);}
1;
