open(MAP,"$ARGV[0]");
%hash = ();

while($map=<MAP>)
{
  chomp($map);
  @map = split(/\t/,$map);
  @sons = split(/;/,$map[1]);
  $i = 0;
  while($i<@sons)
  {
   $hash{$map[0]}{$sons[$i]} = 1;
   $i++;
  }
}
 
$first_key = "GO:0008150";

@keys = keys %{$hash{$first_key}};
if()
 
