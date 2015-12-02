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
  require "./functions/HTML_functions.pl";

  %gene_number_2_gene_name = load_gene_number_2_gene_name("$genes_path" . "/NCBI2GENE_NAME.txt");


####################################
##                                 #
##        LOAD USERS VCF           #
##                                 #
####################################  

  Clean_and_sort_vcf_file($input);

        @cases_pos = get_cols_from_samples($cases);@rel_cases_pos  = ();while($i<@cases_pos){push(@rel_cases_pos,($cases_pos[$i]-9));$i++;}
  


  my $chromosome = 1;
  while($chromosome < 24)
  {
    match_pos_and_gene($chromosome, $coords);
    $chromosome++;
  }

####################################
##                                 #
##             GENES               #
##                                 #
####################################    
  %intersection = %{$double_hits{0}};

  my $t = 1;
  while($t<@cases)
  {
   %intersection = hash_intersection(\%intersection,\%{$double_hits{$t}});
   $t++;
  }
  dump_to_html(\%intersection,"GENES");
  

####################################
##                                 #
##              KEGG               #
##                                 #
####################################    

 %ont_hash = load_gene2ont("KEGG");
 $i = 0;
 while($i<@cases){
  @key = keys %{$double_hits{$i}};
  %hash = ();
  my $t=0;
  while($t<@key)
  {
   @arr = @{$ont_hash{$key[$t]}};
   $z = 0;
   while($z<@arr)
   {
    $hash{$arr[$z]} = 1;
    $z++;
   }
   $t++;
  }
  $double_hits{$i} = \%hash;
  $i++;
 }

 %intersection = %{$double_hits{0}};


 my $t = 1;
 while($t<@cases)
 {
  %intersection = hash_intersection(\%intersection,\%{$double_hits{$t}});
  $t++;
 }
  dump_to_html(\%intersection,"KEGG");




####################################
##                                 #
##           REACTOME              #
##                                 #
####################################    
%ont_hash = load_gene2ont("REACTOME");
$i = 0;
while($i<@cases){
 @key = keys %{$double_hits{$i}};
 %hash = ();
 $t=0;
 while($t<@key)
 {
  @arr = @{$ont_hash{$key[$t]}};
  $z = 0;
  while($z<@arr)
  {
   $hash{$arr[$z]} = 1;
   $z++;
  }
  $t++;
 }
 $double_hits{$i} = \%hash;
 $i++;
}

%intersection = %{$double_hits{0}};


my $t = 1;
while($t<@cases)
{
 %intersection = hash_intersection(\%intersection,\%{$double_hits{$t}});
 $t++;
}
  dump_to_html(\%intersection,"REACTOME");


####################################
##                                 #
##              GO                 #
##                                 #
####################################    

	########
	# GOBP #
	########

	%ont_hash= load_gene2ont("GOBP");
	$i = 0;
	while($i<@cases)
        {
	 @key = (keys %{$double_hits{$i}});
	 %hash = ();
	 $t=0;
	 while($t<@key)
	 {
	  @arr = @{$ont_hash{$key[$t]}};
	  $z = 0;
	  while($z<@arr)
	  {
	   $hash{$arr[$z]} = 1;
	   $z++;
	  }
	  $t++;
	 }
	 $double_hits{$i} = \%hash;
	 $i++;
	}

	%intersection = %{$double_hits{0}};



	my $t = 1;
	while($t<@cases)
	{
	 %intersection = hash_intersection(\%intersection,\%{$double_hits{$t}});
	 $t++;
	}
	  dump_to_html(\%intersection,"GOBP");



	########
	# GOMF #
	########

	%ont_hash = load_gene2ont("GOMF");
	$i = 0;
	while($i<@cases){
	 @key = keys %{$double_hits{$i}};
	 %hash = ();
	 $t=0;
	 while($t<@key)
	 {
	  @arr = @{$ont_hash{$key[$t]}};
	  $z = 0;
	  while($z<@arr)
	  {
	   $hash{$arr[$z]} = 1;
	   $z++;
	  }
	  $t++;
	 }
	 $double_hits{$i} = \%hash;
	 $i++;
	}

	%intersection = %{$double_hits{0}};


	my $t = 1;
	while($t<@cases)
	{
	 %intersection = hash_intersection(\%intersection,\%{$double_hits{$t}});
	 $t++;
	}

 	  dump_to_html(\%intersection,"GOMF");




	########
	# GOCC #
	########

	%ont_hash = load_gene2ont("GOCC");
	$i = 0;
	while($i<@cases){
	 @key = keys %{$double_hits{$i}};
	 %hash = ();
	 $t=0;
	 while($t<@key)
	 {
	  @arr = @{$ont_hash{$key[$t]}};
	  $z = 0;
	  while($z<@arr)
	  {
	   $hash{$arr[$z]} = 1;
	   $z++;
	  }
	  $t++;
	 }
	 $double_hits{$i} = \%hash;
	 $i++;
	}

	%intersection = %{$double_hits{0}};


	my $t = 1;
	while($t<@cases)
	{
	 %intersection = hash_intersection(\%intersection,\%{$double_hits{$t}});
	 $t++;
	}
	  dump_to_html(\%intersection,"GOCC");

        #################
        #               #
        #     OTHER     #
        #               #
        #################
        
  sub hash_union #given 2 hash references returns union of elements (BOOLEAN)
	{my %hash1 = %{$_[0]}; my %hash2 = %{$_[1]}; my %hash3 = %hash2; @k1 = keys %hash1; my $i=0; while($i<@k1) {  $hash3{$k1[$i]}=1;  $i++; } return(%hash3);}

  sub hash_intersection #given 2 hash references returns intersection of elements (BOOLEAN)
	{ my %hash1 = %{$_[0]}; my %hash2 = %{$_[1]}; my %hash3 = (); my @keys = keys %hash1; my $i=0; while($i<@keys) {  if($hash2{$keys[$i]}){$hash3{$keys[$i]}=1;}  $i++; } return(%hash3);}

  sub load_gene2ont #Given a string identifier (GOBP,GOMF,GOCC,KEGG,RECTOME) Returns a structure of the type {Gene1 : [ONT1.1,ONT1.2 ... ONT1.n],Gene2 : [ONT2.1,ONT2.2 ... ONT2.n]...Genem[ONTm.1,ONTm.1 ...ONTmn]} 
	{ my $path = $gene2ont_path{$_[0]};  open(FILE,"$path");  my %toreturn=();  while(my $file =<FILE>)  {   chomp($file);my @file=split(/\t/,$file);my $i = 1;my @arr = @file[1..(scalar(@file)-1)];   while($i<@file){$toreturn{$file[0]}= \@arr;$i++;}  }  return(%toreturn);
}

  sub dump_to_html
  {
    start_html($headers{$_[1]},$output_dir . "/$_[1]\.ejs");
    my %hash = %{$_[0]};
    foreach my $key ( keys %hash){start_html_row();end_html_row();}
    close_html();
  }


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
    # all the cases.
    #
    # BYE!!
    # \n";
die "\n";
}

sub get_cols_from_samples
        {my @samples= split(/,/,$_[0]);my @nums = ();my $i=0;while($i<@samples){$nums[$i] = $header_hash{$samples[$i]};$i++;}return(@nums);}



