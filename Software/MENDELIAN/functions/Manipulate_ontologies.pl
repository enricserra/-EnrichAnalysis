sub analysis_over_ontology
{
 my $ontology_name = $_[1];my %ont_hash  = %{$_[0]};
 my $key ="";my $pval; my $case_count;my %ontology_found = (); my $control_count;my $genes_case_mutated;

 open_results_file($output_dir,$ontology_name);
 open_file_and_dump_it_to_OUT($headers{$ontology_name});

 foreach $key (keys  %ont_hash)
 {

   %specific_ontology = ontology2hash($ont_hash{$key});
   @genelist = @{$specific_ontology{"Genelist"}};
   @genes_matched_total = (keys %genes_matched);
   @genes_found = intersect_lists(\@genelist,\@genes_matched_total);
   if(@genes_found){
     
     ($pval,$case_count,$control_count,$genes_case_mutated) = get_pval_from_list_of_genes($specific_ontology{"size"},$ontology_name,@genelist);
     $ontology_found{$key} = $pval;
     $corrected = min($pval * $instances_in{$ontology_name},1);
     print RESULTS "$pval\t$corrected\t$key\t$specific_ontology{Ngenes}\t$specific_ontology{Description}\t@genes_found\n";
     $gene_ref = \@genes_found;
     dump_ontology($ontology_name, $pval, $corrected, $key, $case_count, $control_count, $genes_case_mutated, $gene_ref);

   }

 }

 close(OUT);
 return(%ontology_found);

}



sub ontology2hash
{
  my %hash;
  my $line = $_[0];
  my @line = split(/\t/,$line);
  $hash{"ID"} = $line[0];
  my @genelist = split(/,/,$line[1]);
  $hash{"Genelist"} = \@genelist;
  $hash{"Ngenes"} = $line[2];
  $hash{"size"} = $line[3];
  $hash{"Description"} = $line[4];
  return(%hash);
}





1;
