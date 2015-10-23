sub get_pval_from_list_of_genes
{if($controls){return(get_pval_case_control(@_));}
  else{return(get_pval_enrichment(@_));}
}

sub get_pval_case_control 
{
  my $size = $_[0];my @genes = @_[2..(scalar(@_)-1)];my $control_counts =0;my $case_counts= 0;
my $this_particular_case_counts = 0;
my $genes_case_mutated= 0;
  my $i=0;
  while($i<@genes)
  {
    $this_particular_case_counts = @{$gene_counts{$genes[$i]}}[0];
   if($this_particular_case_counts>0){
$genes_case_mutated++;
}
   $case_counts = $case_counts +$this_particular_case_counts;@{$gene_counts{$genes[$i]}}[0];
   $control_counts = $control_counts+@{$gene_counts{$genes[$i]}}[1];
   $i++;
 }
 $case_size = $size * scalar(@rel_cases_pos)*2;
 $controls_size = $size * scalar(@rel_controls_pos)*2;
 my $pval = fisher_test_controls($case_counts,$case_size,$control_counts,$controls_size);
 chomp($pval);
 return($pval,$case_counts,$control_counts,$genes_case_mutated);
}

sub get_pval_enrichment
{
  my $size = $_[0];  
  my $ontology_name = $_[1];
  my @genes = @_[2..(scalar(@_)-1)];

  my $universe_size = ($universe{$ontology_name}{$coords}*scalar(@cases)*2)+1;
  my $i=0;
  my $case_counts= 0;
  my $this_particular_case_counts = 0;
 while($i<@genes)
  {
 $this_particular_case_counts = @{$gene_counts{$genes[$i]}}[0];
   if($this_particular_case_counts>0){$genes_case_mutated++;}
   $case_counts = $case_counts + $this_particular_case_counts;
   $i++;
 }
 
 $case_size = $size * scalar(@cases)*2;
 $drawn = $vars_matched +$vars_not_matched;
 my $pval = fisher_enrichment($case_counts,$case_size,$universe_size,$drawn);chomp($pval);
 
 return($pval,$case_counts,"",$genes_case_mutated);
}





sub analysis_over_ontology
{my $ontology_name = $_[1];
 my %ont_hash  = %{$_[0]};
 my $key ="";
 my $pval;
 my $case_count;
 my $control_count;
 my $genes_case_mutated;
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
     $corrected = min($pval * $instances_in{$ontology_name},1);
     print RESULTS "$pval\t$corrected\t$key\t$specific_ontology{Ngenes}\t$specific_ontology{Description}\t@genes_found\n";
     $gene_ref = \@genes_found;
     dump_ontology($ontology_name, $pval, $corrected, $key, $case_count, $control_count, $genes_case_mutated, $gene_ref);
   }
 }
 close(OUT);
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


sub get_gt_array_of_strings
{
  my @gt_array_of_strings_to_return = ();
  my $gene_associated_entity = $_[0];
  my @this_variant = ();
  my @gene_associated_entity = split(/;/,$gene_associated_entity);
  my $t=1;
  while($t<@gene_associated_entity)
  {
    @this_variant=split(/\t/,$gene_associated_entity[$t]);
    push(@gt_array_of_strings_to_return,$this_variant[2]);
    $t++;
  }
  return(@gt_array_of_strings_to_return);
}


sub count_genotypes 
{
  my $gene = $_[0];
  my $control_counts =0;
  my $case_counts= 0;
  my @gt_array_of_strings = get_gt_array_of_strings($gene);
  my $i=0;
  while($i<@gt_array_of_strings)
  {
    @this_gts = split(/\s/,$gt_array_of_strings[$i]);
    $case_counts =  $case_counts  + gt2counts(select_list_position_by_index(\@this_gts,\@rel_cases_pos));
    $control_counts = $control_counts + gt2counts(select_list_position_by_index(\@this_gts,\@rel_controls_pos));
    $i++;
  }
 return($case_counts,$control_counts);
  
}



sub min
{if($_[0]<$_[1]){return($_[0]);}return($_[1]);}


1;
