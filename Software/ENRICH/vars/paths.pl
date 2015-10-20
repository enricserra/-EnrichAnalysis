$local_path = "/var/www/html/dat.cnag.cat/dat.cnag.cat_preproduction/Software/ENRICH";

$functions_path = $local_path . "/functions";

$vars_path = $local_path . "/vars";

$genes_path = $local_path . "/GENES";

$ontology_path = $local_path . "/ontologies";

$clinvar_path = $ontology_path . "/Clinvar.tsv";

$clinvar_5_path = $ontology_path . "/Clinvar5.tsv";

$coordinates_path{"Exon"} = $local_path . "/COORDINATES/Exon";
$coordinates_path{"Gene"} = $local_path . "/COORDINATES/Gene";
$coordinates_path  = $coordinates_path{$coords};

$size_path{"Exon"} = $local_path . "/sizes/Exon/Exonic_size.txt";
$size_path{"Gene"} = $local_path . "/sizes/Exon/Genic_size.txt";
$size_path  = $size_path{$coords};

$ontology_path{"Exon"} = $local_path . "/ontologies/Exon";
$ontology_path{"Gene"} = $local_path . "/ontologies/Gene";
$ontology_path = $ontology_path{$coords};

$headers_path = $local_path . "/HEADERS";

$fisher_path{"case_control"} = $local_path . "/functions/Pvalue_contingency_table.R";
$fisher_path{"enrichment"} = $local_path . "/functions/Pvalue_enrichment.R";
if($controls)
{
  $fisher_path  = $fisher_path{"case_control"};
  $genehead_path = $headers_path . "/GeneHeadControls.txt";
  $headers{"KEGG"} = $headers_path . "/KEGGHeadControls.txt";
  $headers{"REACTOME"} = $headers_path . "/REACTOMEHeadControls.txt";
  $headers{"CLINVAR"}  = $headers_path . "/CLINVARHeadControls.txt";
  $headers{"CLINVAR5"}  = $headers_path . "/CLINVAR5HeadControls.txt";
  $headers{"GOBP"} = $headers_path . "/GOBPHeadControls.txt";
  $headers{"GOMF"} = $headers_path . "/GOMFHeadControls.txt";
  $headers{"GOCC"} = $headers_path . "/GOCCHeadControls.txt";
}

else
{
  $fisher_path  = $fisher_path{"enrichment"};
  $genehead = $headers_path . "/GeneHeadEnrichment.txt";
  $headers{"KEGG"} = $headers_path . "/KEGGHeadEnrichment.txt";
  $headers{"REACTOME"} = $headers_path . "/REACTOMEHeadEnrichment.txt";
  $headers{"CLINVAR"}  = $headers_path . "/CLINVARHeadEnrichment.txt";
  $headers{"CLINVAR5"}  = $headers_path . "/CLINVAR5HeadControls.txt";
  $headers{"GOBP"} = $headers_path . "/GOBPHeadEnrichment.txt";
  $headers{"GOMF"} = $headers_path . "/GOCCHeadEnrichment.txt";
  $headers{"GOCC"} = $headers_path . "/GOCCHeadEnrichment.txt";
}


1;

