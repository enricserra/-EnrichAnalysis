#TODO Change this for a hash
sub dump_ontology
{if($_[0] eq "KEGG"){if($controls){dump_KEGG_controls(@_);}else{dump_KEGG_enrichment(@_);}}
  elsif($_[0] eq "GOBP"){if($controls){dump_GOBP_controls(@_);}else{dump_GOBP_enrichment(@_);}}
  elsif($_[0] eq "GOMF"){if($controls){dump_GOMF_controls(@_);}else{dump_GOMF_enrichment(@_);}}
  elsif($_[0] eq "GOCC"){if($controls){dump_GOCC_controls(@_);}else{dump_GOCC_enrichment(@_);}}
  elsif($_[0] eq "REACTOME"){if($controls){dump_REACTOME_controls(@_);}else{dump_REACTOME_enrichment(@_);}}

}

sub dump_KEGG_enrichment
{
my $pval=$_[1];
my $corrected = $_[2];
my $kegg_key = $_[3];
my $counts  = $_[4];
my $genes_found_ref = $_[7];
my @genelist = @{$genes_found_ref};
my $gene_number  = $_[6];
    $kegg_line = $KEGG{$kegg_key};
    @kegg_line = split(/\t/,$kegg_line);

    start_html_row();
    dump_number($pval);
    dump_number($corrected);
    dump_kegg_id($kegg_key);
    dump_number($counts);
    dump_genelist(@genelist);
    dump_number($kegg_line[2]);
    $kegg_line = $KEGG{$kegg_key};
    @kegg_line = split(/\t/,$kegg_line);
  dump_description($kegg_line[4]);
  end_html_row();
}

sub dump_REACTOME_enrichment
{
my $pval=$_[1];
my $corrected = $_[2];
my $reactome_key = $_[3];
my $counts  = $_[4];

  my $genes_found_ref = $_[7];my @genelist = @{$genes_found_ref};
  my $gene_number  = $_[6];
  $reactome_line = $REACTOME{$reactome_key};
  @reactome_line = split(/\t/,$reactome_line);

  start_html_row();
  dump_number($pval);
  dump_number($corrected);
  dump_reactome_id($reactome_key);
  dump_number($counts);
  dump_number($gene_number);
  dump_genelist(@genelist);
  dump_number($reactome_line[2]);
  dump_description($reactome_line[4]);
  end_html_row();
}
sub dump_GOBP_enrichment
{
my $pval=$_[1];
my $corrected = $_[2];
my $gobp_key = $_[3];
my $counts  = $_[4];

  my $genes_found_ref = $_[7];my @genelist = @{$genes_found_ref};
  my $gene_number  = $_[6];#case genes mutated
  $gobp_line = $GOBP{$gobp_key};
  @gobp_line = split(/\t/,$gobp_line);
  $go_meaning{$gobp_key} =$gobp_line[4];
  start_html_row();
  dump_number($pval);
  dump_number($corrected);
  dump_go_id($gobp_key);
  dump_number($counts);
  dump_genelist(@genelist);
  dump_number($gobp_line[2]);
  dump_description($go_meaning{$gobp_key});


  end_html_row();
}
sub dump_GOMF_enrichment
{
my $pval=$_[1];
my $corrected = $_[2];
my $gomf_key = $_[3];
my $counts  = $_[4];

  my $genes_found_ref = $_[7];my @genelist = @{$genes_found_ref};
  my $gene_number  = $_[6];
  $gomf_line = $GOMF{$gomf_key};
  @gomf_line = split(/\t/,$gomf_line);
  $go_meaning{$gomf_key} =$gomf_line[4];

  start_html_row();
  dump_number($pval);
  dump_number($corrected);
  dump_go_id($gomf_key);
  dump_number($counts);
  dump_genelist(@genelist);
  dump_number($go_mf_line[2]);  
  dump_description($go_meaning{$gomf_key});


  end_html_row();
}
sub dump_GOCC_enrichment
{
my $pval=$_[1];
my $corrected = $_[2];
my $gocc_key = $_[3];
my $counts  = $_[4];

  my $genes_found_ref = $_[7];my @genelist = @{$genes_found_ref};
  my $gene_number  = $_[6];
  start_html_row();
  dump_number($pval);
  dump_number($corrected);
  dump_go_id($gocc_key);
  dump_number($counts);
  dump_number($gene_number);
  dump_genelist(@genelist);
  $gocc_line = $GOCC{$gocc_key};
  @gocc_line = split(/\t/,$gocc_line);
  $go_meaning{$gocc_key} = $gocc_line[4];
  dump_description($go_meaning{$gocc_key});


  end_html_row();
}





sub dump_KEGG_controls
{
  my $pval=$_[1];
  my $corrected = $_[2];
  my $kegg_key = $_[3];
  my $counts  = $_[4];
  my $controls = $_[5];
  my $genes_found_ref = $_[7];my @genelist = @{$genes_found_ref};
  my $gene_number  = $_[6];
  $kegg_line = $KEGG{$kegg_key};
  @kegg_line = split(/\t/,$kegg_line);

  start_html_row();
  dump_number($pval);
  dump_number($corrected);

  dump_kegg_id($kegg_key);

  dump_number($counts);

  dump_number($controls);
  dump_genelist(@genelist);
  dump_number($kegg_line[2]);

  dump_description($kegg_line[4]);
  end_html_row();
}

sub dump_REACTOME_controls
{
  my $pval=$_[1];
  my $corrected = $_[2];
  my $reactome_key = $_[3];
  my $counts  = $_[4];
  my $controls = $_[5];
  my $genes_found_ref = $_[7];my @genelist = @{$genes_found_ref};
  my $gene_number  = $_[6];
  $reactome_line = $REACTOME{$reactome_key};
  @reactome_line = split(/\t/,$reactome_line);

  start_html_row();
  dump_number($pval);
  dump_number($corrected);
  dump_reactome_id($reactome_key);
  dump_number($counts);
  dump_number($controls);
  dump_genelist(@genelist);
  dump_number($reactome_line[2]);

  dump_description($reactome_line[4]);
  end_html_row();
}

sub dump_GOBP_controls
{
  my $pval=$_[1];
  my $corrected = $_[2];
  my $gobp_key = $_[3];
  my $counts  = $_[4];
  my $controls = $_[5];
  my $genes_found_ref = $_[7];my @genelist = @{$genes_found_ref};
  my $gene_number  = $_[6];
  $gobp_line = $GOBP{$gobp_key};
  @gobp_line = split(/\t/,$gobp_line);
  $go_meaning{$gobp_key} =$gobp_line[4];

  start_html_row();
  dump_number($pval);
  dump_number($corrected);
  dump_go_id($gobp_key);
  dump_number($counts);
  dump_number($controls);
  dump_genelist(@genelist);
  dump_number($gobp_line[2]);
  dump_description($go_meaning{$gobp_key});
  end_html_row();
}

sub dump_GOMF_controls
{ my $pval=$_[1];
  my $corrected = $_[2];
  my $gomf_key = $_[3];
  my $counts  = $_[4];
  my $controls = $_[5];
  my $genes_found_ref = $_[7];my @genelist = @{$genes_found_ref};
  my $gene_number  = $_[6];
  $gomf_line = $GOMF{$gomf_key};
  @gomf_line = split(/\t/,$gomf_line);
  $go_meaning{$gomf_key} =$gomf_line[4];

  start_html_row();
  dump_number($pval);
  dump_number($corrected);
  dump_go_id($gomf_key);
  dump_number($counts);
  dump_number($controls);
  dump_genelist(@genelist);
  dump_number($gomf_line[2]);

  dump_description($go_meaning{$gomf_key});

  end_html_row();
}
sub dump_GOCC_controls
{
  my $pval=$_[1];
  my $corrected = $_[2];
  my $gocc_key = $_[3];
  my $counts  = $_[4];
  my $controls = $_[5];
  my $genes_found_ref = $_[7];my @genelist = @{$genes_found_ref};
  my $gene_number  = $_[6];
  $gocc_line = $GOCC{$gocc_key};
  @gocc_line = split(/\t/,$gocc_line);
  $go_meaning{$gocc_key} = $gocc_line[4];

  start_html_row();
  dump_number($pval);
  dump_number($corrected);
  dump_go_id($gocc_key);
  dump_number($counts);
  dump_number($controls);
  dump_genelist(@genelist);
  dump_number($gocc_line[2]);
  dump_description($go_meaning{$gocc_key});
  end_html_row();
}

sub dump_description
{start_cell();print OUT "$_[0]";end_cell();}

sub kegg2href{return("http://www.genome.jp/kegg-bin/show_pathway?hsa" . $_[0]);}

sub go2href
{return("http://www.ebi.ac.uk/QuickGO/GTerm?id=$_[0]\#term=children");}

sub dump_kegg_id
{start_cell();print OUT "<a href=\"".kegg2href($_[0])."\"> $_[0] </a>\n";end_cell();}

sub dump_reactome_id
{start_cell();print OUT " $_[0] \n";end_cell();}

sub dump_go_id
{start_cell();print OUT "<a href=\"".go2href($_[0])."\"> $_[0] </a>\n";end_cell();}




1;
