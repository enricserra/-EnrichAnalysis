open(FILE,"$ARGV[0]");
while($file=<FILE>)
{
  chomp($file);
  @file=split(/\t/,$file);
  @genes=split(/,/,$file[3]);
  $i=0;
  while($i<@genes)
  {
    if($size{$genes[$i]}){$size{$genes[$i]} = $size{$genes[$i]} + $file[2] -$file[1];}
    else{$size{$genes[$i]} = $file[2] -$file[1];}
    $t = 0;
    while($t<@genes)
    {
      if($t!=$i){$intersection{$genes[$i]}{$genes[$t]} =  $intersection{$genes[$i]}{$genes[$t]}+ $file[2] -$file[1];}
      $t++;
    }
    $i++;

  }

}

close(FILE);
open(FILE,"$ARGV[1]");

while($file=<FILE>)
{
  chomp($file);
  @file=split(/\t/,$file);
  @genelist = split(/,/,$file[1]);
  $i=0;
  $ontology_size=0;$ontology_intersection = 0;
  while($i<@genelist)
  {
    %intersect_hash = %{$intersection{$genelist[$i]}};
    $ontology_size = $ontology_size + $size{$genelist[$i]};
    $t = 0;
    while($t<@genelist)
    {
      if($t!=$i)
      {
        
        $ontology_intersection = $ontology_intersection + $intersect_hash{$genelist[$t]};
      }
      $t++;
    }
    $i++;
  }
  $ontology_intersection=$ontology_intersection/2;
  $ontology_size = $ontology_size -$ontology_intersection;
  print "$file[0]\t$file[1]\t$file[2]\t$ontology_size\t$file[4]\n";
}


