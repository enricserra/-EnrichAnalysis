sub sampleCol2Tag
{
  
  my $sampleColumn = $_[0];
  my $formatColumn = $_[1];
  my $tagName = $_[2];
  my $tagPosition = tagPositionInFormat($tagName,$formatColumn);  
  my @sampleColumn = split(/:/,$sampleColumn);
  return($sampleColumn[$tagPosition]);

}





sub hasHeterozygousGt#Accepts an array of sample columns, returns 1 if at least one of them is Heterozygous 0 if they are all Homozygous
{

  my $gtPosition = tagPositionInFormat("GT",$_[0]);
  my $i = 1;

  while($i<@_)
  {

    my @sampleColumn = split(/:/,$_[$i]);

    if($sampleColumn[$gtPosition]=~/\//){$separator = "/";}

    elsif($sampleColumn[$gtPosition]=~/\|/){$separator = "|";}

    else{warn("No genotype provided line $vcfLineNumber\n");}

    my @gt = split(/$separator/,$sampleColumn[$gtPosition]);

    if($gt[0] ne $gt[1]){return(1);}

    $i++

  }

  return(0);

}

sub hasNonRefHomozygousGt#Accepts an array of sample columns, returns 1 if at least one of them is Heterozygous 0 if they are all Homozygous
{

  my $gtPosition = tagPositionInFormat("GT",$_[0]);
  my $i = 1;

  while($i<@_)
  {

    my @sampleColumn = split(/:/,$_[$i]);

    if($sampleColumn[$gtPosition]=~/\//){$separator = "/";}

    elsif($sampleColumn[$gtPosition]=~/\|/){$separator = "|";}

    else{warn("No genotype provided line $vcfLineNumber\n");}

    my @gt = split(/$separator/,$sampleColumn[$gtPosition]);

    if(($gt[0] eq $gt[1]) and ($gt[0] != 0)){return(1);}

    $i++

  }

  return(0);

}



sub alleleIsNotFound#Accepts an array of sample columns, returns 1 if at least one of them is Heterozygous 0 if they are all Homozygous
{

  my $gtPosition = tagPositionInFormat("GT",$_[0]);
  my $i = 2;
  my @caseSampleColumn = split(/:/,$_[1]);
  
  if($caseSampleColumn[$gtPosition]=~/\//){$separator = "/";}
    
  elsif($caseSampleColumn[$gtPosition]=~/\|/){$separator = "|";}
    
  else{warn("No genotype provided line $vcfLineNumber\n");}

  my @caseGt = split(/$separator/,$caseSampleColumn[$gtPosition]);

  while($i<@_)
  {

    my @controlSampleColumn = split(/:/,$_[$i]);

    if($controlSampleColumn[$gtPosition]=~/\//){$separator = "/";}

    elsif($controlSampleColumn[$gtPosition]=~/\|/){$separator = "|";}

    else{warn("No genotype provided line $vcfLineNumber\n");}

    my @controlGt = split(/$separator/,$controlSampleColumn[$gtPosition]);

    if((isInArray($caseGt,@controlGt)) and isInArray($caseGt[1], @controlGt) ){return(0);}

    $i++

  }

  return(1);

}

sub genotypeIsNotFound#Accepts an array of sample columns, returns 1 if at least one of them is Heterozygous 0 if they are all Homozygous
{

  my $gtPosition = tagPositionInFormat("GT",$_[0]);
  my $i = 2;
  my @caseSampleColumn = split(/:/,$_[1]);
  if($caseSampleColumn[$gtPosition]=~/\//){$separator = "/";}

  elsif($caseSampleColumn[$gtPosition]=~/\|/){$separator = "|";}

  else{warn("No genotype provided line $vcfLineNumber\n");}

  my @caseGt = split(/$separator/,$caseSampleColumn[$gtPosition]);

  while($i<@_)
  {

    my @controlSampleColumn = split(/:/,$_[$i]);
  
    if($controlSampleColumn[$gtPosition]=~/\//){$separator = "/";}
    
    elsif($controlSampleColumn[$gtPosition]=~/\|/){$separator = "|";}
    
    else{warn("No genotype provided line $vcfLineNumber\n");}

    my @controlGt = split(/$separator/,$controlSampleColumn[$gtPosition]);

    if( ($caseGt[0] eq $controlGt[0]) and ($caseGt[1] eq $controlGt[1]) ){return(0);}

    $i++

  }

  return(1);

}




sub isInArray
{

  my $stringToFind = $_[0];
  my @listToLookIn = @_[1..scalar(@_)];
  my $i = 0;

  while($i < @listToLookIn)
  {

    if($listToLookIn[$i] eq $stringToFind)
    {

      return(1);

    }

    $i++;
  
  }
 
  return(0);

}



sub hasNonReferenceGt#Accepts an array of sample columns, returns 1 if at least one of them is Heterozygous 0 if they are all Homozygous
{

  my $gtPosition = tagPositionInFormat("GT",$_[0]);
  my $i = 1;

  while($i < @_)
  {

    my @sampleColumn = split(/:/,$_[$i]);

    if( $sampleColumn[$gtPosition]=~/\// )
    {

      $separator = "/";

    }

    elsif( $sampleColumn[$gtPosition]=~/\|/ )
    {

      $separator = "|";

    }

    else
    {

      warn( "No genotype provided line $vcfLineNumber \n" );

    }

    my @gt = split(/$separator/,$sampleColumn[$gtPosition]);
    if( !(isInArray($gt[0],@referenceGtValues)) or !(isInArray($gt[1],@referenceGtValues)) )
    {
      
      return(1);

    }

    $i++
  }
  return(0);
}

sub tagPositionInFormat
{

 my @format = split(/:/,$_[1]);
 my $i = 0;

 while($i<@format)
 {

   if($format[$i] eq "$_[0]")
   {

     return($i);

   }

   $i++;

 }

 warn("NO $_[0] FOUND @format <-- FORMAT $vcfLine  <-- VCF LINE NUMBER : $vcfLineNumber\n");

}

1;
