

#VARS DECLARATION 

        $vars_not_matched = 0;
        $vars_matched = 0;
        %vars_per_gene_control = ();
        %vars_per_gene_case = ();
        %genes_ = ();
        @cases_pos = get_cols_from_samples($cases); @rel_cases_pos  = ();while($i<@cases_pos){push(@rel_cases_pos,($cases_pos[$i]-9));$i++;}
        @controls_pos = get_cols_from_samples($controls);@rel_controls_pos  = ();$i=0;while($i<@controls_pos){push(@rel_controls_pos,($controls_pos[$i]-9));$i++;}
        %gene_number_2_gene_name = load_gene_number_2_gene_name("$genes_path" . "/NCBI2GENE_NAME.txt");
        $total_size = load_gene_size($size_path);
        %clinvar_hash = load_clinvar($clinvar_path);
        %clinvar5 = load_clinvar_5($clinvar_5_path);


#Precomputed values to speed up.

	$instances_in{"Exon"} = 18896;
	$instances_in{"Gene"} = 25717;
	$gene_number = $instances_in{$coords};

	$universe{"Genes"}{"Exon"} = 32785377;
	$universe{"Genes"}{"Gene"} = 1377040872;

	$instances_in{"KEGG"} = 229;
	$instances_in{"REACTOME"} = 1455;
	$instances_in{"GOBP"} = 8088;
	$instances_in{"GOMF"} = 3955;
	$instances_in{"GOCC"} = 1365;

	$gene_number_in{"KEGG"} = 5870;
	$gene_number_in{"REACTOME"} = 6841;
	$gene_number_in{"GOBP"} = 18105;
	$gene_number_in{"GOCC"} = 17048;
	$gene_number_in{"GOMF"} = 15343;
					
        $universe{"KEGG"}{"Exon"} = "9915649";
        $universe{"KEGG"}{"Gene"} = "342862089";
        $universe{"REACTOME"}{"Exon"} = "12177250";
        $universe{"REACTOME"}{"Gene"} = "403972942";
        $universe{"GOBP"}{"Exon"} = "26062875";
        $universe{"GOBP"}{"Gene"} = "900091545";
        $universe{"GOCC"}{"Exon"} = "29077775";
        $universe{"GOCC"}{"Gene"} = "1006535370"; 
        $universe{"GOMF"}{"Exon"} = "27108111";
        $universe{"GOMF"}{"Gene"} = "924111399";


#CLINVAR TRANSLATIONS 

	%references_hash = (
		"MedGen"  => "http://www.ncbi.nlm.nih.gov/medgen/",
		"Orphanet" => "http://www.orpha.net/consor/cgi-bin/OC_Exp.php?Lng=EN&Expert=",
		"OMIM"  => "http://www.omim.org/entry/",
		"GeneReviews" => "http://www.ncbi.nlm.nih.gov/books/",
		"SNOMED_CT" => "http://www.snomedbrowser.com/codes/Details/",
	);

	%clnsig_hash = (
		"0" => "Unknown",
		"1" => "Untested",
		"2" => "Non pathogenic",
		"3" => "Probable non pathogenic",
		"4" => "Probable pathogenic",
		"5" => "Pathogenic",
		"6" => "Drug response",
		"7" => "Histocompatibility",
		"255" => "Other",
	);

	%clnsig_importance = (
		"1" => "2",
		"2" => "3",
		"3" => "0",
		"4" => "1",
		"5" => "6",
		"6" => "7",
		"7" => "255",
		"8" => "4",
		"9" => "5",
	);

	%clnsrc_hash = (
		 "HBVAR" => "http://globin.bx.psu.edu/cgi-bin/hbvar/query_vars3?mode=output&display_format=page&i=",
		 "GTR" => "http://www.ncbi.nlm.nih.gov/gtr/tests/",
		 "UniProtKB_(variants)" => "http://web.expasy.org/variant_pages/",
		 "dbRBC_-_Blood_Group_Antigen_Gene_Mutation_Database" => "http://www.ncbi.nlm.nih.gov/projects/gv/mhc/xslcgi.cgi?cmd=bgmut/allele_details&id=",
		 "GeneReviews" => "http://www.ncbi.nlm.nih.gov/books/",
		 "NCBI_curation" => "http://www.ncbi.nlm.nih.gov/projects/SNP/snp_ref.cgi?rs",
		 "CFTR2" => "http://www.cftr2.org/browse.php",
		 "NCBI_override" => "http://omim.org/entry/",
		 "NCBI" => "http://www.ncbi.nlm.nih.gov/",
		  "Sequence_Ontology" => "http://www.sequenceontology.org/browser/current_svn/term/",
		 "OMIM_Allelic_Variant" => "http://omim.org/entry/",
	);
 
1;
