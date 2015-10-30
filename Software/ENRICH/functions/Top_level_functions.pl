sub Clinvar
{
  if($debug){print "CLINVAR\n.\n..\n...\n";}

  start_html($headers{"CLINVAR"},"$output_dir/CLINVAR.ejs");
  
  my $i=0;
  
  while($i<@clinvar_found)
  {
    
    clinvar_line_parser($clinvar_found[$i]);
    $i++;
  
  }

  close_html();
  if($debug){print "DONE\n";}

}

sub Clinvar_5
{
  start_html($headers{"CLINVAR5"},"$output_dir/CLINVAR5.ejs");

  my $i=1;
  while($i<@array_of_chr){
    match_pos_and_gene_and_clinvar($i, $coords);
    $i++;
  }

  close_html();

}
sub dump_all_genes
{

#TODO this is not working
  if($debug){print "GENES\n.\n..\n...\n";}

  my $pval;my $case_counts;my $control_counts;

  start_html($genehead_path,"./$output_dir/GENES.ejs");

    foreach  $gene_matched_key  (keys %genes_matched)
    {
       @case_control_count = count_genotypes($genes_matched{$gene_matched_key});

      $case_counts{$gene_matched_key} = $case_control_count[0];
      $control_counts{$gene_matched_key} = $case_control_count[1]; 

      $total_counts = $total_counts + $case_counts{$gene_matched_key};
    }
    foreach  $gene_matched_key  (keys %genes_matched)
    {
      ($pval,$case_counts,$control_counts) = get_pval_from_list_of_genes($gene_size{$gene_matched_key},"Genes",$gene_matched_key);
      $corrected = min($pval * $gene_number, 1);

      start_html_row();
    
        dump_number($pval);
        dump_number($corrected);
        dump_genelist($gene_matched_key);
        dump_number($case_counts);
        if($controls)
        {
          dump_number($control_counts);
        }
    
      end_html_row();


    } 

  close_html();

  if($debug){print "DONE\n";}

}

sub KEGG
{
  if($debug){print "KEGG\n.\n..\n...\n";}

  start_html($headers{"KEGG"},"$output_dir/KEGG.ejs");

  %KEGG = load_ontology("$ontology_path" . "/KEGG.txt");
  analysis_over_ontology(\%KEGG,"KEGG");

  close_html();

  if($debug){print "DONE\n";}


}

sub REACTOME
{

  if($debug){print "REACTOME\n.\n..\n...\n";}

  start_html($headers{"REACTOME"},"$output_dir/REACTOME.ejs");

  %REACTOME = load_ontology("$ontology_path" . "/REACTOME.txt");
  analysis_over_ontology(\%REACTOME,"REACTOME");

  close_html();

  if($debug){print "DONE\n";}

}


sub GO
{
  $go_type = $_[0];
  if($debug){print "GO$go_type\n.\n..\n...\n";}

  start_html($headers{"GO$go_type"},"$output_dir/GO$go_type\.ejs");

    %GOBP = load_ontology("$ontology_path" . "/GO$go_type\.txt");
    %GOfound = analysis_over_ontology(\%GOBP,"GO$go_type");



  close_html();
  
  create_json_nested_graph("$go_type",$output_dir."/GO$go_type\.json");


  if($debug){print "DONE\n";}

}

sub min
{if($_[0]<$_[1]){return($_[0]);}return($_[1]);}



1;
