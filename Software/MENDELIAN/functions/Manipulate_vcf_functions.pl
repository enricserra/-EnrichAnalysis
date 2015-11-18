sub check_valid_chr
	{my $chr = $_[0];my $i = 1; while($i<26){if($chr == $i){return(1);}$i++;} return(0);}

sub parse_gt
        {my $format = $_[0];my @format = split(/:/,$format);my $i = 1;while($i<@format){if($format[$i] == "GT"){my $gt_pos = $i;$i=scalar(@format);}$i++;}my @samples = @_[1..(scalar(@_)-1)];$i = 0;my $gt_string = "";while($i<@samples){my @this_sample = split(/:/,$samples[$i]);if($gt_string){$gt_string = $gt_string." ".$this_sample[$gt_pos];}else{$gt_string = $this_sample[$gt_pos];}$i++;}return($gt_string);}

sub remove_chr_and_change_Y_M_MT_X
        {my $line =$_[0];$line =~ s/^chr//;$line =~ s/^X/23/;$line =~ s/^Y/24/;$line=~s/^MT/25/;$line=~s/^M/25/;return($line);}

sub create_array_from_header_hash
	{my $samples = $_[0];my @samples = split(/,/,$samples);my @samples_cols = ();my $i=0;while($i<@samples){if(exists($header_hash{$samples[$i]})){push(@samples_cols,$header_hash{$samples[$i]});}$i++;}}

sub create_header_hash
        {my $header = $_[0]; chomp($header);my @header=split(/\t/,$header);my $i=0;my %header_hash=();while($i<@header){$header_hash{$header[$i]}=$i;$i++;}return(%header_hash);}

sub get_cols_from_samples
	{my @samples= split(/,/,$_[0]);my @nums = ();my $i=0;while($i<@samples){$nums[$i] = $header_hash{$samples[$i]};$i++;}return(@nums);}




sub split_gt_using_separator
	{my $gt = $_[0];if($gt=~/\//){@gt=split(/\//,$gt);}elsif($gt=~/\|/){@gt=split(/\|/,$gt);}return(@gt);}

#I : GT_string,and maybe array of columns to return [gt_string,colnum,colnum...]
#O : Returns integer of counts from the columns passes as array
sub gt_list2counts
	{my @gt = @_;my $counts=0;my $i = 0;while($i<@gt){$counts =  gt2count($gt[$i]) + $counts;$i++;}return($counts);}

sub gt2count
	{my @gt=split_gt_using_separator($_[0]);my $counts = 0;my $i=0;while($i<@gt){if($gt[$i] != "0" and $gt[$i] ne "\."){$counts++;}$i++;}return($counts);}

sub gene2gt_list
	{my @gene_matched_instance = split(/;/,$genes_matched{$_[0]});my @gt_list=();my @vcf_info=();my $i=0;while($i < @gene_matched_instance){@vcf_info = split(/\t/,$gene_matched_instance[$i]);push(@gt_list,$vcf_info[2]); $i++;}return(@gt_list);}


sub count_genotypes 
{
  my $gene = $_[0];
  my $control_counts =0;
  my $this_list_case_counts= 0;
  my @gt_array_of_strings = get_gt_list($gene);
  my $i=0;
  while($i<@gt_array_of_strings)
  {
    @this_gts = split(/\s/,$gt_array_of_strings[$i]);
    $this_list_case_counts =  $this_list_case_counts  + gt_list2counts(select_list_position_by_index(\@this_gts,\@rel_cases_pos));
    $control_counts = $control_counts + gt_list2counts(select_list_position_by_index(\@this_gts,\@rel_controls_pos));
    $i++;
  }
 return($this_list_case_counts,$control_counts);

}

sub get_gt_list
{
  my @gt_list_to_return = ();
  my $gene = $_[0];
  my @this_variant = ();
  my @genes = split(/;/,$gene);
  my $i=1;
  while($i < @genes)
  {
    @this_variant = split(/\t/,$genes[$i]);
    push(@gt_list_to_return,$this_variant[2]);
    $i++;
  }
  return(@gt_list_to_return);
}

1;
