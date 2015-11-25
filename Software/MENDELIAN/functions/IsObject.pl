sub isValidChr
{
  my $chromosome = $_[0];
  my $i = 1;
  while($i<26)
  {

    if($chromosome == $i)
    {

      return(1);

    }

    $i++;

  }

  return(0);

}
1;
