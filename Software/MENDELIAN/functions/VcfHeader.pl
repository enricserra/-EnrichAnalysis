sub useVcfHeader
{

  if($_[0]=~/^##/){}

  else
  {

      my $vcfColumnNames = $_[0];$vcfColumnNames=~s/^#//;
      %vcfColname2Number = createColnames2NumberHash( $vcfColumnNames );
      %vcfNumber2Colname = createNumber2ColnamesHash( $vcfColumnNames );
      @cases = split(/,/, $cases);
      @casesPositions = positionsOfColumns( \%vcfColname2Number, @cases );
      @controls = split(/,/, $controls);
      @controlsPositions =  positionsOfColumns( \%vcfColname2Number, @controls );

  }

}

sub createColnames2NumberHash
{

  my $header = $_[0];
  my @header = split(/\t/,$header);
  my $i=0;
  my %hashToReturn=();

  while($i<@header)
  {

    $hashToReturn{$header[$i]}=$i;
    $i++;

  }

  return(%hashToReturn);

}

sub createNumber2ColnamesHash 
{

  my $header = $_[0];
  chomp($header);
  my @header = split(/\t/,$header);
  my $i = 0;
  my %hashToReturn = ();

  while( $i < @header )
  {

    $hashToReturn{$i} = $header{$i};
    $i++;

  }

  return( %hashToReturn );

}

sub positionsOfColumns
{

  my %vcfColname2Number = %{$_[0]};
  my @columnNames= @_[1..scalar(@_)-1];
  my @arrayOfPositionsToReturn = ();
  my $i=0;

  while($i < @columnNames)
  {

    if($vcfColname2Number{$columnNames[$i]})
    {

      push(@arrayOfPositionsToReturn, $vcfColname2Number{$columnNames[$i]});
  
    }
    
    $i++;

  }

  return(@arrayOfPositionsToReturn);

}
 
1;
