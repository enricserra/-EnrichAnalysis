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
  require "$functions_path" . "/GOGraph_functions.pl";
  require "$functions_path" . "/Top_level_functions.pl";

  require "$vars_path" . "/variables.pl";



####################################
##                                 #
##        LOAD USERS VCF           #
##                                 #
####################################  

  Clean_and_sort_vcf_file($input);

        @cases_pos = get_cols_from_samples($cases);@rel_cases_pos  = ();while($i<@cases_pos){push(@rel_cases_pos,($cases_pos[$i]-9));$i++;}
        @controls_pos = get_cols_from_samples($controls);@rel_controls_pos  = ();$i=0;while($i<@controls_pos){push(@rel_controls_pos,($controls_pos[$i]-9));$i++;}

####################################
##                                 #
##            CLINVAR              #
##                                 #
####################################  

Clinvar_5();

Clinvar();


####################################
##                                 #
##             GENES               #
##                                 #
####################################    

dump_all_genes();

####################################
##                                 #
##              KEGG               #
##                                 #
####################################    

KEGG();


####################################
##                                 #
##           REACTOME              #
##                                 #
####################################    

REACTOME();

####################################
##                                 #
##              GO                 #
##                                 #
####################################    

	########
	# GOBP #
	########

	GOBP();

	########
	# GOMF #
	########

	GOMF();


	########
	# GOCC #
	########

	GOCC();



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


