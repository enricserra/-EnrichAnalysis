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
    "controls=s" => \$controls,#csv sample names as they are in the vcf HEADER
    "output_dir=s" => \$output_dir,#directory where to output
    "debug=s" =>\$debug,
  );

  if(!$input or !$coords or !$output_dir)
  {
    usage();
  }

####################################
##                                 #
##            REQUIRE              #
##                                 #
####################################  

  require "./vars/paths.pl";
  require "$functions_path" . "/Manipulate_vcf_functions.pl";
  require "$functions_path" . "/Manipulate_ontologies.pl";
  require "$functions_path" . "/Parsing_functions.pl";
  require "$functions_path" . "/General_purpose_functions.pl";
  require "$functions_path" . "/HTML_functions.pl";
  require "$functions_path" . "/Ontology_functions.pl";
  require "$functions_path" . "/Clinvar_functions.pl";
  require "$functions_path" . "/Fisher.pl";
  require "$functions_path" . "/Loading_functions.pl";
  require "$vars_path" . "/variables.pl";



####################################
##                                 #
##        LOAD USERS VCF           #
##                                 #
####################################  

  Clean_and_sort_vcf_file($input);


####################################
##                                 #
##            CLINVAR              #
##                                 #
####################################  
if($debug){print "CLINVAR\n.\n..\n...\n";}
  start_html($headers{"CLINVAR5"},"$output_dir/CLINVAR5.ejs");

  my $i=1;
  while($i<@array_of_chr){
    match_pos_and_gene_and_clinvar($i,$coords);
    $i++;
  }
 
  close_html();


  start_html($headers{"CLINVAR"},"$output_dir/CLINVAR.ejs");

  my $i=0;
  while($i<@clinvar_found)
  {
    clinvar_line_parser($clinvar_found[$i]);
    $i++;
  }

  close_html();

if($debug){print "DONE\n";}
####################################
##                                 #
##             GENES               #
##                                 #
####################################    
if($debug){print "GENES\n.\n..\n...\n";}

dump_all_genes();

if($debug){print "DONE\n";}
####################################
##                                 #
##              KEGG               #
##                                 #
####################################    
if($debug){print "KEGG\n.\n..\n...\n";}

  start_html($headers{"KEGG"},"$output_dir/KEGG.ejs"); 

  %KEGG = load_ontology("$ontology_path" . "/KEGG.txt");
  analysis_over_ontology(\%KEGG,"KEGG");

  close_html();

if($debug){print "DONE\n";}
####################################
##                                 #
##           REACTOME              #
##                                 #
####################################    
if($debug){print "REACTOME\n.\n..\n...\n";}


  start_html($headers{"REACTOME"},"$output_dir/REACTOME.ejs");

  %REACTOME = load_ontology("$ontology_path" . "/REACTOME.txt");
  analysis_over_ontology(\%REACTOME,"REACTOME");

  close_html();

if($debug){print "DONE\n";}
####################################
##                                 #
##              GO                 #
##                                 #
####################################    

	########
	# GOBP #
	########
	  if($debug){print "GOBP\n.\n..\n...\n";}

  	  start_html($headers{"GOBP"},"$output_dir/GOBP.ejs");

          %GOBP = load_ontology("$ontology_path" . "/GOBP.txt");
          analysis_over_ontology(\%GOBP,"GOBP");

          close_html();

	  if($debug){print "DONE\n";}

	########
	# GOMF #
	########
          if($debug){print "GOMF\n.\n..\n...\n";}

	  start_html($headers{"GOMF"},"$output_dir/GOMF.ejs");

	  %GOMF = load_ontology("$ontology_path" . "/GOMF.txt");
	  analysis_over_ontology(\%GOMF,"GOMF");

	  close_html();

          if($debug){print "DONE\n";}

	########
	# GOCC #
	########
          if($debug){print "GOCC\n.\n..\n...\n";}

	  start_html($headers{"GOCC"},"$output_dir/GOCC.ejs");

	  %GOCC = load_ontology("$ontology_path" . "/GOCC.txt");
	  analysis_over_ontology(\%GOCC,"GOCC");

	  close_html();

          if($debug){print "DONE\n";}

sub usage
{
 print "
    #
    # Enrichment Analysis
    #
                
       -input        REQ     <path to input file name>
       -coord        REQ     <type of coordinates to use> Exon / Gene
       -output_dir   REQ     <path to output directory> 
       -cases        OPT     <CSV sample names to be used as cases>
       -controls     OPT     <CSV sample names to be used as controls>
    
    #
    # BYE!!
    # \n";
die "\n";
}


