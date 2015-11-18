

sub Clean_and_sort_vcf_file
{
  open_vcf_or_gz_to_FILE($_[0]);
  $vcf_line = 0; 
  while(my $file=<FILE>)
  {
    $vcf_line++;
    if($file =~ /^#/) 
    {
      use_vcf_header($file);
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
      %colname2number = create_colname2number($_[0]);
      %number2colname = create_number2colname($_[0]);
      @cases = create_array_from_header_hash($cases);

  }
}

sub create_colname2number
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

sub create_number2colname
{
  my $header = $_[0];
  chomp($header);
  my @header=split(/\t/,$header);
  my $i=0;
  my %header_hash=();
  while($i<@header)
  {
    $header_hash{$i}=$header{$i};
    $i++;
  }
  return(%header_hash);
}



sub create_array_from_header_hash
                        {my $samples = $_[0];my @samples = split(/,/,$samples);my @samples_cols = ();my $i=0;while($i<@samples){if($colname2number{$samples[$i]}){push(@samples_cols,$colname2number{$samples[$i]});}$i++;}return(@samples_cols);}

#VCF BODY
sub use_vcf_body
{
  my $vcf = $_[0];
  $vcf = remove_chr_and_change_Y_M_MT_X($vcf);
  redirect_vcf_line($vcf);
}  

sub redirect_vcf_line
{
  @vcf =split(/\t/,$_[0]);
  if(check_valid_chr_and_gt($vcf[0])){insert_onto_array_of_chr($vcf[0],$_[0]);}
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
          my $i = 0;
          while($i<@_)
          {
            if(check_heterozygous_gt($vcf[8],$vcf[$cases[$i]])){return(1);}
            $i++;
          }
          return(0);
        }

	sub check_heterozygous_gt
        {
          my $gt_position = find_position_in_format("GT",$_[0]);
          
          my @sample_column = split(/:/,$_[1]);
          if($sample_column[$gt_position]=~/\//){$separator = "/";}
          elsif($sample_column[$gt_position]=~/\|/){$separator = "|";}
          else{warn("No genotype provided line $vcf_line\n");return(0);}
          my @gt = split(/$separator/,$sample_column[$gt_position]);
          return(($gt[0] ne $gt[1]));
        }
        sub remove_chr_and_change_Y_M_MT_X
                        {my $line =$_[0];$line =~ s/^chr//;$line =~ s/^X/23/;$line =~ s/^Y/24/;$line=~s/^MT/25/;$line=~s/^M/25/;return($line);}

sub find_position_in_format
{
 my @format = split(/:/,$_[1]);
 my $i = 0;
 while($i<@format)
 {
   if($format[$i] eq "$_[0]"){return($i);}
   
   $i++;
 }
 warn("NO GENOTYPE PROVIDED line $vcf_line\n");
 
}
        sub insert_onto_array_of_chr
                        {my $chr = $_[0];push(@{$array_of_chr[$chr]},$_[1]);}

        sub open_vcf_or_gz_to_FILE
                        {@filename =  split(/\./,$_[0]);if(($filename[scalar(@filename)-1]  eq "gz") and ($filename[scalar(@filename)-2] eq "vcf")){open(FILE,"gunzip -c $_[0] |") or die "Could not open $_[0]\n";}elsif($filename[scalar(@filename)-1] eq "vcf"){ open(FILE,"$_[0]") or die "Could not open $_[0]\n";}else{die "Can not open $_[0] must be vcf or vcf.gz\n";}}





1;
