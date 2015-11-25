sub intersectPointInterval
{

  my @point=($_[0]);
  my @interval=($_[1],$_[2],$_[3]);
  if($point[0] > $interval[0])
  {
 
    if($point[0] <= $interval[1])
    {

      return("INCLUDED",$interval[2]);

    }

    else
    {

      return("POINT_GT_INT","");

    }

  }

  else
  {

    return("POINT_LT_INT","");

  }

}

sub insertToVariantsPerChromosome
{

  my $chr = $_[0];
  push(@{$variantsPerChromosome[$chr]},$_[1]);

}



sub findVariantsInGenes
{
 
  my $chromosomeNumber = $_[0];
  @variantsInChromosome = @{$variantsPerChromosome[$chromosomeNumber]};
  close(INTERVALS);
  open(INTERVALS, $coordinatesPath{$chromosomeNumber});

  my $i=0;
  $variant = nextVariant($i);
  @variant = split(/\t/,$variant);
  $interval = nextInterval();
  @interval = split(/\t/, $interval);

  while(($i < @variantsInChromosome) and ($interval))
  {

    @intersection = intersectPointInterval($variant[1], $interval[1], $interval[2], $interval[3]);
    if($intersection[0] eq "INCLUDED")
    {

      addToGenes($variant,$interval[3]);
      $i++;
      $variant = nextVariant($i);
      @variant = split(/\t/,$variant);
      $vars_matched++;

    }

    elsif($intersection[0] eq "POINT_GT_INT")
    {

      $interval = nextInterval();
      @interval = split(/\t/, $interval);

    }

    elsif($intersection[0] eq "POINT_LT_INT")
    {

      $i++;
      $variant = nextVariant($i);
      @variant = split(/\t/,$variant);
      $vars_not_matched++;

    }

    else
    {

      die "Impossible situation, check\n\t INTERVALS :\n@interval\n\t VCF FILE : @variant\n";

    }
    
  }

}

sub addToGenes
{

  my $variant = $_[0];my @genelist = split(/,/,$_[1]);
  my @variant = split(/\t/,$variant);
  my $format = $variant[8];
  my $i=0;

  while($i < @genelist)
  {
    my $j = 0;
    my $recessiveFlag = 0;
    my $dominantFlag = 0;
    my $doubleHitFlag = 0;

    while($j < @cases)
    {
  
      if(hasHeterozygousGt($format, $variant[$casesPositions[$j]]))
      {

        $geneHits{$j}{$genelist[$i]} = $geneHits{$j}{$genelist[$i]} +1;#They get stored, if they are bigger than 1 => double hit, will also be used as keys to all genes found
        $geneHit{$genelist[$i]} = 1;
        
        if($doubleHitFlag == 0)
        {

          $doubleHitVariants{$genelist[$i]} = $doubleHitVariants{$genelist[$i]} . $variant . "\n"; #Don't need to change, only keys that are true for Dhit will be used as variants
          $doubleHitFlag ++;

        }
 

        if(alleleIsNotFound($format, $variant[$casesPositions[$j]], @variant[@controlsPositions]))
        {
          
          $dominant{$j}{$genelist[$i]} = 1;
          
          if($dominantFlag == 0)
          {

            $dominantVariants{$genelist[$i]} = $dominantVariants{$genelist[$i]} . $variant . "\n";
            $dominantFlag ++;

          }

        }

      }

      else
      {

        if(hasNonReferenceGt($format, $variant[$casesPositions[$j]]) and genotypeIsNotFound($format, $variant[$casesPositions[$j]], @variant[@controlsPositions]))
        {


          $recessive{$j}{$genelist[$i]} = 1;
          
          if($recessiveFlag == 0)
          {
  
            $recessiveVariants{$genelist[$i]} = $recessiveVariants{$genelist[$i]} . $variant . "\n";
            $recessiveFlag++;

          }

        }
       
      }

      $j++;

    }

  $i++;

  }

}
  

sub nextInterval
{

  my $interval = <INTERVALS>;
  return($interval);

}

sub nextVariant
{
  
   
  return($variantsInChromosome[$_[0]]);
  
}


1;
