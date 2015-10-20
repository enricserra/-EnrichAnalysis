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
    "cases=s" =>\$cases,
    "controls=s" => \$controls,
    "user_dir=s" => \$user_dir,
  );

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

  start_html($headers{"CLINVAR5"},"$user_dir/CLINVAR5.ejs");

  my $i=1;
  while($i<@array_of_chr){
    match_pos_and_gene_and_clinvar($i,$coords);
    $i++;
  }
 
  close_html();


  start_html($headers{"CLINVAR"},"$user_dir/CLINVAR.ejs");

  my $i=0;
  while($i<@clinvar_found)
  {
    clinvar_line_parser($clinvar_found[$i]);
    $i++;
  }

  close_html();


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

  start_html($headers{"KEGG"},"$user_dir/KEGG.ejs"); 

  %KEGG = load_ontology("$ontology_path" . "/KEGG.txt");
  analysis_over_ontology(\%KEGG,"KEGG");

  close_html();


####################################
##                                 #
##           REACTOME              #
##                                 #
####################################    

  start_html($headers{"REACTOME"},"$user_dir/REACTOME.ejs");

  %REACTOME = load_ontology("$ontology_path" . "/REACTOME.txt");
  analysis_over_ontology(\%REACTOME,"REACTOME");

  close_html();


####################################
##                                 #
##              GO                 #
##                                 #
####################################    

	########
	# GOBP #
	########
	  
  	  start_html($headers{"GOBP"},"$user_dir/GOBP.ejs");

          %GOBP = load_ontology("$ontology_path" . "/GOBP.txt");
          analysis_over_ontology(\%GOBP,"GOBP");

          close_html();

	########
	# GOMF #
	########

	  start_html($headers{"GOMF"},"$user_dir/GOMF.ejs");

	  %GOMF = load_ontology("$ontology_path" . "/GOMF.txt");
	  analysis_over_ontology(\%GOMF,"GOMF");

	  close_html();

	########
	# GOCC #
	########

	  start_html($headers{"GOCC"},"$user_dir/GOCC.ejs");

	  %GOCC = load_ontology("$ontology_path" . "/GOCC.txt");
	  analysis_over_ontology(\%GOCC,"GOCC");

	  close_html();

