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
{
  my $gt = $_[0];
  if($gt=~/\//){@gt=split(/\//,$gt);}
  elsif($gt=~/\|/){@gt=split(/\|/,$gt);}
  return(@gt);
  
}

#I : GT_string,and maybe array of columns to return [gt_string,colnum,colnum...]
#O : Returns integer of counts from the columns passes as array
sub gt2counts
{
#vars
 my @gt = @_;my $counts=0; 

 my $i = 0;
 while($i<@gt)
 {
   $counts =  transform_gt_to_count($gt[$i]) + $counts;
   $i++;
 }
 return($counts);
}

sub transform_gt_to_count
{
#vars
 my @gt=split_gt_using_separator($_[0]);my $counts = 0;

 my $i=0;
 while($i<@gt)
 {
  if($gt[$i] != "0" and $gt[$i] ne "\.")
  {
   $counts++;
  }
  $i++;
 }
 return($counts);
}

sub gene2gt
{
#vars
  my @gene_matched_instance = split(/;/,$genes_matched{$_[0]});
  my @gt_array=();
  my @vcf_info=();

  my $i=0;
  while($i < @gene_matched_instance){
   @vcf_info = split(/\t/,$gene_matched_instance[$i]);
   push(@gt_array,$vcf_info[2]); 
   $i++;}
  return(@gt_array);  
}

1;
