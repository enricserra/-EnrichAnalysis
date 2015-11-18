#######################################
#				      #
#Enric Serra Sanz		      #
#				      #
#Enrichment  Analysis for VCF files   #
#				      #
#				      #
#1/10/2015			      #
#				      #
#				      #
#######################################

###################################
#                                 #
#            OPTIONS              #
# 				  #
###################################              
  use Getopt::Long;

  GetOptions(
    "input=s" => \$input,#Input vcf or vcf.gz file
    "coords=s" => \$coords,#Exon or Gene
    "cases=s" =>\$cases,#csv sample names as they are in the vcf HEADER
    "output_dir=s" => \$output_dir,#directory where to output
    "debug=s" =>\$debug,
  );

  if(!$input or !$coords or !$output_dir or !$cases)
  {
    usage();
  }

####################################
##                                 #
##            REQUIRE              #
##                                 #
####################################  
  require "./functions/Loading_functions.pl";
  require "./vars/paths.pl";

  require "$vars_path" . "/variables.pl";
  require "./functions/obtain_double_hits.pl";
  require "./functions/obtain_chr_array.pl";



####################################
##                                 #
##        LOAD USERS VCF           #
##                                 #
####################################  

  Clean_and_sort_vcf_file($input);

        @cases_pos = get_cols_from_samples($cases);@rel_cases_pos  = ();while($i<@cases_pos){push(@rel_cases_pos,($cases_pos[$i]-9));$i++;}
  


  my $i = 1;
  while($i< 24)
  {
    match_pos_and_gene($i,$coords);
    $i++;
  }
  



@double_hits_array = ();
@samples_for_double_hit = (keys %double_hits);
%first = 
$i = 1;
while($i<@samples)
{
 
 $i++;
}

for $key (keys %double_hits)
{
 print "$key\t$double_hits{$key}\n";
  %second = %{$double_hits{$key}};
  foreach $superkey (keys %second)
  {  
    @{$sample_array{$key}} = push_and_sort($superkey,@{$sample_array{$key}});
  }
}

$i =1;
if(scalar(@cases) > 1)
{
 @intersect =@{$sample_array{0}};
 while($i<@cases)
  {

    @intersect = intersect_sorted_lists_of_numbers(\@intersect,\@{$sample_array{$i}});
    $i++;
  }
}

else
{
  @intersect = @{$sample_array{0}};
}



print "@intersect\n";
$t = 0;
while($t<@cases)
{
 $expanded_gobp[$t] = expand_list_of_genes("GOBP",\@{$sample_array{$t}});
 %hash = %{$expanded_gobp[$t]};
 foreach $key (keys %hash)
 {
  print "$key\t$hash{$key}\n";
 }
 $t++;

}





sub expand_list_of_genes
{
  my $to_expand = $_[0];
  my %toreturn =();
  my @list_of_genes = @{$_[1]};
  my %hash = load_gene2ont($to_expand);
  foreach $key (keys %hash)
  {
    my @thisarray = @{$hash{$key}};
    $z = 0;
    while($z < @thisarray){$toreturn{$thisarray[$z]}=1;$z++;}
    
  
  }
  return(\%toreturn);
}


sub load_gene2ont
{
  my $path = $gene2ont_path{$_[0]};
  open(FILE,"$path");
  my %toreturn=();
  while($file =<FILE>)
  {
   chomp($file);@file=split(/\t/,$file);
   $i = 1;
   while($i<@file){$toreturn{$file[0]}=\@file[1..(scalar(@file)-1)];$i++;}
  }
  return(%toreturn);
  
}

sub hash_union
{
 my %hash1 = %{$_[0]};
 my %hash2 = %{$_[1]};
 my %hash3 = %hash2;
 @k1 = keys %hash1;
 my $i=0;
 while($i<@k1)
 {
  $hash3{$k1[$i]}=1;}
  $i++;
 }
 return(%hash3);
}

sub hash_intersection
{
 my %hash1 = %{$_[0]};
 my %hash2 = %{$_[1]};
 my %hash3 = ();
 @k1 = keys %hash1;
 my $i=0;
 while($i<@k1)  
 {
  if($hash2{$k1[$i]}){$hash3{$k1[$i]}=1;}
  $i++;
 }
 return(%hash3);
}


sub intersect_sorted_lists_of_numbers
{
 my @list1 = @{$_[0]};
 my @list2 = @{$_[1]};
 @toreturn = ();
 $s1_cont = 0;  
 $s2_cont = 0;
 
 $a = $list1[$s1_cont];
 $b =$list2[$s2_cont];
 while($a and $b){
  if($a == $b){push(@toreturn,$a);$s1_cont++;$s2_cont++; $a = $list1[$s1_cont];$b =$list2[$s2_cont];}
  elsif($a<$b)
  {
    $s1_cont++;$a = $list1[$s1_cont];
  }
  else{    $s2_cont++;$b = $list2[$s2_cont];}
 }
 return(@toreturn);
}
sub push_and_sort
{
  my $number = $_[0];
  my @array = @_[1..scalar(@_)-1];
  my $prev = 0;my $next =1;
  if($number < $array[0]){splice @array, 0, 0, $number;return(@array);}
  else{
    while($next < @array)
    {
      if(($number > $array[$prev]) and ($number<$array[$next]))
      {
        splice @array, $next, 0, $number; 
        return(@array);
      }
      $prev++;$next++;
    }
    push(@array,$number);
   return(@array);
  
  } 
}


####################################
##                                 #
##             GENES               #
##                                 #
####################################    


####################################
##                                 #
##              KEGG               #
##                                 #
####################################    



####################################
##                                 #
##           REACTOME              #
##                                 #
####################################    

####################################
##                                 #
##              GO                 #
##                                 #
####################################    

	########
	# GOBP #
	########


	########
	# GOMF #
	########



	########
	# GOCC #
	########




sub usage
{
 print "
    #
    # Mendelian Analysis
    #
                
       -input        REQ     <path to input file name>
       -coord        REQ     <type of coordinates to use> Exon / Gene
       -output_dir   REQ     <path to output directory> 
       -cases        OPT     <CSV sample names to be used as cases> 
			       non cases samples will be ignored
    
    #
    # This is intended to find genes that have a likely Mendelian inheritance
    # pattern, selecting double hit genes and then intersecting that list
    # through all cases, to find genes and ontologies with double hit on 
    # all the cases samples.
    #
    # BYE!!
    # \n";
die "\n";
}

sub get_cols_from_samples
        {my @samples= split(/,/,$_[0]);my @nums = ();my $i=0;while($i<@samples){$nums[$i] = $header_hash{$samples[$i]};$i++;}return(@nums);}



