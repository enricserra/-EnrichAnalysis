sub useVcfBody
{

  my $vcfLine = $_[0];
  $vcfLine = removeChrStringChangeNonNumericChr($vcfLine);
  @vcfLine = split(/\t/, $vcfLine );
  my $thisLineChromosome = $vcfLine[0];
  my $thisLineFormat = $vcfLine[8];
  if( isValidChr( $thisLineChromosome ) and hasNonReferenceGt($thisLineFormat, @vcfLine[@casesPositions]) )
  { 
    
    insertToVariantsPerChromosome($thisLineChromosome, $vcfLine); 

  }

}


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

sub removeChrStringChangeNonNumericChr
{

  my $line = $_[0];
  $line =~s/^chr//;
  $line =~ s/^X/23/;
  $line =~ s/^Y/24/;
  $line=~s/^MT/25/;
  $line=~s/^M/25/;
  return($line);

}


1;
