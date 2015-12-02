$local_path = "./";
$localDirectory  =$local_path;


$functions_path = $local_path . "/functions";

$vars_path = $local_path . "/vars";

$genes_path = $local_path . "/GENES";

$ontology_path = $local_path . "/ontologies";

$go_map_paths = $local_path . "/GOGRAPH";

$clinvar_path = $ontology_path . "/Clinvar.tsv";

$clinvar_5_path = $ontology_path . "/Clinvar5.tsv";

$coordinatesPath{"Exon"} = $local_path . "/COORDINATES/Exon";
$coordinatesPath{"Gene"} = $local_path . "/COORDINATES/Gene";
my $chromosomeNumber = 1;

while($chromosomeNumber < 23 )
{

  $coordinatesPath{$chromosomeNumber} = $coordinatesPath{$coords} . "/$chromosomeNumber\.txt";
  $chromosomeNumber ++ ;

}


$ontology_path{"Exon"} = $local_path . "/ontologies/Exon";
$ontology_path{"Gene"} = $local_path . "/ontologies/Gene";
$ontology_path = $ontology_path{$coords};


$gene2ont_path = $local_path . "/ontologies/GENE2ONT";

	$gene2ont_path{"GOBP"} = $gene2ont_path . "/Gene2GOBP";
	$gene2ont_path{"GOMF"} = $gene2ont_path . "/Gene2GOMF";
	$gene2ont_path{"GOCC"} = $gene2ont_path . "/Gene2GOCC";
	$gene2ont_path{"KEGG"} = $gene2ont_path . "/Gene2KEGG";
	$gene2ont_path{"REACTOME"} = $gene2ont_path . "/Gene2REACTOME";

sub getPath2Gene2Ont
{

  my $analysis = $_[0];
  return($gene2ont_path . "/Gene2".$analysis);

}

#Change this for nested loops 

sub getPath2Headers
{
  
  my $analysis = $_[0];
  my $inheritance = $_[1];
  if($inheritance)
  {
  
    return($localDirectory . "/HEADERS/$inheritance/$analysis\.txt");

  }
  return($localDirectory . "/HEADERS/$analysis\.txt");

}


sub getPath2Results
{
  
  my $analysis = $_[0];
  my $inheritance = $_[1];
  my $baseDirectory = $_[2];
  return($output_dir . "/$inheritance/$analysis\.ejs");

}




1;

