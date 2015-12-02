sub intersect_point_and_interval
                        {my @point=($_[0]);my @interval=($_[1],$_[2],$_[3]);if($point[0] > $interval[0]){if($point[0] <= $interval[1]){return("INCLUDED",$interval[2]);}else{return("POINT_GT_INT","");}}else{return("POINT_LT_INT","");}}

sub match_pos_and_gene
{
  my $i=0;
  my $chr = $_[0];
  my $coord_type = $_[1];
  my @this_chr_array = @{$array_of_chr[$_[0]]};
  my $path_to_coord_file = $coordinates_path{$coord_type}."/".$chr."\.txt";
  open(INTERVALS,$path_to_coord_file);
  @this_vcf = next_pos($i);
  $i++;
  $this_interval = <INTERVALS>;
  @this_interval = split(/\t/,$this_interval);
  while($i<@this_chr_array and $this_interval)
  {
    @intersect_result = intersect_point_and_interval($this_vcf[1],$this_interval[1],$this_interval[2],$this_interval[3]);
    if($intersect_result[0] eq "INCLUDED")
    {
      add_to_genes($this_chr_array[$i],$this_interval[3]);
      $i++;
      @this_vcf = next_pos($i);
      $vars_matched++;
    }
    elsif($intersect_result[0] eq "POINT_GT_INT")
    {
      $this_interval = <INTERVALS>;
      @this_interval = split(/\t/,$this_interval);
    }
    elsif($intersect_result[0] eq "POINT_LT_INT")
    {
      $i++;
      @this_vcf = next_pos($i);
      $vars_not_matched++;
      @this_vcf = split(/\t/,$this_chr_array[$i]);
    }
    else
    {
      die "Impossible situation, check\n\t INTERVALS :\n@this_interval\n\t VCF FILE : @this_vcf\n";
    }
  }
}

sub add_to_genes
{
  my $vcf =$_[0];chomp($vcf);my @genelist = split(/,/,$_[1]);chomp(@genelist);
  my @vcf=split(/\t/,$vcf);
  my $i=0;
  while($i<@genelist)
  {
 
    my $this_gene = $genelist[$i];
    my $t = 0;
    while($t < @cases)
    {
      if(check_heterozygous_gt($vcf[8],$vcf[$cases[$t]]))
      {
        if(($hits{$genelist[$i]}{$t}) == 2)
        {
          $double_hits{$t}{$genelist[$i]}=1;
        }
        else
        {
          $hits{$genelist[$i]}{$t}++;
        }
      }     
      $t++;
    }
    $i++;
  }
}


sub next_pos
{
  return(split(/\t/,$this_chr_array[$_[0]]));
}


1;
