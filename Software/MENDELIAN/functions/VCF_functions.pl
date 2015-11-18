sub Clean_and_sort_vcf_file
{
  open_vcf_or_gz_to_FILE($_[0]); 
  while(my $file=<FILE>)
  {
    if($file =~ /^#/) 
    {
      use_vcf_header($file);
    }
    elsif($file=~/^#/)
    {
      chomp($file);
      %header_hash = create_header_hash($file);
      @cases=create_array_from_header_hash($cases);
    }
    else
    {
      use_vcf_body($file);
    }
  }
}


#HEADER

sub use_vcf_header
{
  if($_[0]=~/^##/){}
  else
  {
      chomp($_[0]);
      %header_hash = create_header_hash($_[0]);
      @cases = create_array_from_header_hash($cases);

  }
}

sub create_header_hash
{
  my $header = $_[0];
  chomp($header);
  my @header=split(/\t/,$header);
  my $i=0;
  my %header_hash=();
  while($i<@header)
  {
    $header_hash{$header[$i]}=$i;
    $i++;
  }
  return(%header_hash);
}


sub create_array_from_header_hash
                        {my $samples = $_[0];my @samples = split(/,/,$samples);my @samples_cols = ();my $i=0;while($i<@samples){if($header_hash{$samples[$i]}){push(@samples_cols,$header_hash{$samples[$i]});}$i++;}return(@samples_cols);}

#VCF BODY
sub use_vcf_body
{
  my $vcf = $_[0];
  $vcf = remove_chr_and_change_Y_M_MT_X($vcf);
  redirect_vcf_line($file);
}  

sub redirect_vcf_line
{
  @vcf =split(/\t/,$_[0]);
  if(check_valid_chr_and_gt(@vcf)){insert_onto_array_of_chr($vcf[0],$vcf);}
}

sub check_valid_chr_and_gt
{
  if((check_valid_chr($_[0]) + check_at_least_one_heterozygous_gt(@cases)) > 1){return(1);}
  return(0);
}

        sub check_valid_chr
                        {my $chr = $_[0];my $i = 1; while($i<26){if($chr == $i){return(1);}$i++;} return(0);}
        sub check_at_least_one_heterozygous_gt
        { 
          my $i = 1;
          while($i<@_)
          {
            if(check_heterozygous_gt($vcf[$cases[$i]])){return(1);}
            $i++;
          }
          return(0);
        }
	sub check_heterozygous_gt
        {
          my @gt = split(/\//,$_[0]);
          return(($gt[0] ne $gt[1]));
        }
