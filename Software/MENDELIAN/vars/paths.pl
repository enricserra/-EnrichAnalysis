$local_path = "/var/www/html/dat.cnag.cat/dat.cnag.cat_preproduction/Software/MENDELIAN";

$functions_path = $local_path . "/functions";

$vars_path = $local_path . "/vars";

$genes_path = $local_path . "/GENES";

$ontology_path = $local_path . "/ontologies";

$go_map_paths = $local_path . "/GOGRAPH";

$clinvar_path = $ontology_path . "/Clinvar.tsv";

$clinvar_5_path = $ontology_path . "/Clinvar5.tsv";

$coordinates_path{"Exon"} = $local_path . "/COORDINATES/Exon";
$coordinates_path{"Gene"} = $local_path . "/COORDINATES/Gene";
$coordinates_path  = $coordinates_path{$coords};

$size_path{"Exon"} = $local_path . "/COORDINATES/Exon/Gene_size.txt";
$size_path{"Gene"} = $local_path . "/COORDINATES/Exon/Gene_size.txt";
$size_path  = $size_path{$coords};

$ontology_path{"Exon"} = $local_path . "/ontologies/Exon";
$ontology_path{"Gene"} = $local_path . "/ontologies/Gene";
$ontology_path = $ontology_path{$coords};

$headers_path = $local_path . "/HEADERS";

$fisher_path{"case_control"} = $local_path . "/functions/Pvalue_contingency_table.R";
$fisher_path{"enrichment"} = $local_path . "/functions/Pvalue_enrichment.R";

$gene2ont_path = $local_path . "/ontologies/GENE2ONT";

	$gene2ont_path{"GOBP"} = $gene2ont_path . "/Gene2GOBP";
	$gene2ont_path{"GOMF"} = $gene2ont_path . "/Gene2GOMF";
	$gene2ont_path{"GOCC"} = $gene2ont_path . "/Gene2GOCC";
	$gene2ont_path{"KEGG"} = $gene2ont_path . "/Gene2KEGG";
	$gene2ont_path{"REACTOME"} = $gene2ont_path . "/Gene2REACTOME";



  $genehead_path = $headers_path . "/GENES.txt";
  $headers{"KEGG"} = $headers_path . "/KEGG.txt";
  $headers{"REACTOME"} = $headers_path . "/REACTOME.txt";
  $headers{"CLINVAR"}  = $headers_path . "/CLINVAR.txt";
  $headers{"CLINVAR5"}  = $headers_path . "/CLINVAR5.txt";
  $headers{"GOBP"} = $headers_path . "/GOBP.txt";
  $headers{"GOMF"} = $headers_path . "/GOMF.txt";
  $headers{"GOCC"} = $headers_path . "/GOCC.txt";



1;

