
sub start_html
{my $header_path = $_[0];my $output_path = $_[1];open(F,$header_path);open(OUT,">$output_path");while($f=<F>){print OUT "$f";}close(F);}

sub close_html
{close(OUT);}

sub start_html_row
{if($_[0]){print OUT "<tr class=\"$_[0]\">\n";}
print OUT "<tr>\n";}

sub end_html_row
{print OUT "</tr>\n";}

sub start_cell
{print OUT "<td >";}

sub end_cell
{print OUT "</td>";}

sub dump_all_genes
{
  my $pval ;
  my $case_counts;
  my $control_counts;
  start_html($genehead_path,"./$output_dir/GENES.ejs");
  foreach  $gene_matched_key  (keys %genes_matched)
  {
    @{$gene_counts{$gene_matched_key}} = count_genotypes($genes_matched{$gene_matched_key});
    ($pval,$case_counts,$control_counts) = get_pval_from_list_of_genes($gene_size{$gene_matched_key},"Genes",$gene_matched_key);
    $corrected = min($pval * $gene_number, 1);
    dump_gene_array($pval,$corrected,$gene_matched_key,$case_counts,$control_counts);
  }
  close_html();
}

sub gene2html
{my $genenumber = $_[0];my $genesymbol = $gene_number_2_gene_name{$genenumber}; my $htmlstring = "<a href=\"http://www.ncbi.nlm.nih.gov/gene/" .$genenumber ."\">".$genesymbol."</a> ";return($htmlstring);}

sub dump_gene_array
{my $pval =$_[0];my $corrected = $_[1];my $genenumber = $_[2];my $case_muts = $_[3];my $control_muts = $_[4];start_html_row();dump_number($_[0]);dump_number($_[1]);dump_genelist($genenumber);dump_number($case_muts);if($controls){dump_number($control_muts);}end_html_row();}

sub dump_number
{my $number = $_[0];start_cell();print OUT "$number";end_cell();}

sub dump_genelist
{
 if(scalar(@_) <10){
start_cell();my $i=0;while($i<@_){dump_gene($_[$i]);$i++;}end_cell();}
 else{
my $genelist = join(@_," ");
my $scalar= scalar(@_);start_cell();print OUT "<p title=\"$genelist\"> $scalar in total </p>\n";end_cell();}
}

sub dump_gene
{my $genekey = $_[0];my $string = gene2html($genekey);print OUT "$string";}


1;
