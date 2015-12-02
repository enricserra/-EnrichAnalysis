#This is really messi, clean plz



sub clinvar_line_parser
{
  my $line = $_[0];
  my @line=split(/\t/,$line);
  my %parsed_line = parse_non_tag_fields(@line);
  my %parsed_tags = ();
  my @info = split(/;/,$line[7]);
  my $i=0;
  while($i<@info)
  {
    my @tag = split(/=/,$info[$i]);
    $parsed_tags{$tag[0]} = clinvar_tag_parser($tag[1]);
    $i++;
  }
  dump_clinvar(\%parsed_line,\%parsed_tags);
}

sub parse_non_tag_fields
{
  my %hash = ();
  $hash{CHROM} = $_[0];
  $hash{CHROM}=~s/23/X/;
  $hash{CHROM}=~s/24/Y/;
  $hash{CHROM}=~s/25/MT/;
  $hash{POS} = $_[1];
  $hash{ID} = $_[2];
  $hash{REF} = $_[3];
  $hash{ALT} = $_[4];
  $hash{GT} = $_[8];
  return(%hash);
}

sub dump_clinvar
{
  my %clinvar_non_tags = %{$_[0]};my %clinvar_tags = %{$_[1]};
  my @caf = @{$clinvar_tags{"CAF"}};
  $clinvar_tags{"CAF"} = join(",", @caf);

  my @clnsig = @{$clinvar_tags{CLNSIG}};
  start_html_row($clnsig[0]);

    dump_single_value($clinvar_non_tags{"CHROM"});
    dump_single_value($clinvar_non_tags{"POS"});
    dump_ID($clinvar_non_tags{"ID"});
    dump_GENEINFO($clinvar_tags{"GENEINFO"});
    dump_single_value($clinvar_tags{"CAF"});
    dump_single_value($clinvar_non_tags{"REF"});
    dump_single_value($clinvar_non_tags{"ALT"});
    dump_GT($clinvar_non_tags{"GT"});
    dump_CLNSIG(@clnsig);
    dump_CLNACC($clinvar_tags{"CLNACC"});
    dump_CLNDBN($clinvar_tags{"CLNDBN"});
    dump_CLNDSDB($clinvar_tags{"CLNDSDB"},$clinvar_tags{"CLNDSDBID"});
    dump_CLNSRC($clinvar_tags{"CLNSRC"},$clinvar_tags{"CLNSRCID"});

  end_html_row();
}

sub dump_CLNDBN
{
  my @arr = @{$_[0]};
  print OUT "<td>";
  my $i=0;
  while($i<@arr)
  {
    print OUT "<a ><p> $arr[$i] </a></p>";
    $i++;
  }  
  print OUT "</td>\n";
}

sub dump_CLNSRC
{
  my @clnsrc  = @{$_[0]};
  my @clnsrcid = @{$_[1]};
  my $i = 0;
  print OUT "<td>";
  while($i<@clnsrc)
  {
    $clnsrc[$i] =~s/" "/_/g;
    print OUT "<p><a href=\"$clnsrc_hash{$clnsrc[$i]}";
    $clnsrc[$i] =~s/_/" "/g;

    print OUT "$clnsrcid[$i]\"> $clnsrc[$i] </a></p>";
    $i++;
  }
  print OUT "</td>\n";
}



sub dump_CLNDSDB
{
  my @clndsdb  = @{$_[0]};
  my @clndsdbid = @{$_[1]};
  my $i = 0;
  print OUT "<td>";
  while($i<@clndsdb)
  {
    print OUT "<p><a href=\"$references_hash{$clndsdb[$i]}$clndsdbid[$i]\"> $clndsdb[$i] </a></p>";
    $i++;
  }
  print OUT "</td>\n";
}

sub dump_CLNACC
{
  my @arr = @{$_[0]};
  my $i=0;
  print OUT "<td>";
  while($i<@arr){
    print OUT "<p><a title=\"$arr[$i]\" href=\"http://www.ncbi.nlm.nih.gov/clinvar/$arr[$i]\"> CLINVAR </a> </p>\n";
    $i++;
 }
  print OUT "</td>\n";
}

sub dump_CLNSIG
{
 
 print OUT "<td> $clnsig_hash{$_[0]} </td>\n";
}

sub dump_GT
{
  my $gt = $_[0];chomp($gt);
  if ($controls)
  {
    my @gts = split(/\s/,$gt);
    my @cases = select_list_position_by_index(\@gts,\@rel_cases_pos);
    my @controls = select_list_position_by_index(\@gts,\@rel_controls_pos);
    print OUT  "<td>  @cases </td>\n";
    print OUT  "<td>  @controls </td>\n";

  
  }
  else
  {
    print OUT "<td>  $gt </td>\n";
  }

}


sub dump_GENEINFO
{
  my $i=0;print OUT "<td>";
  my @arr =@{$_[0]};
  while($i<@arr)
  {
    print OUT "<a href=\"http://www.ncbi.nlm.nih.gov/gene/$arr[($i+1)]\"> $arr[$i] <br></a>";
    $i=$i+2;
  }
  print OUT "</td>\n";
}


sub dump_single_value
{
  print OUT "<td> $_[0] </td>\n";
}

sub dump_ID
{
  $id = $_[0];@re= split(/rs/,$id);
  print OUT "<td ><a href=\"http://www.ncbi.nlm.nih.gov/SNP/snp_ref.cgi?rs=$re[1]\"> $id </a></td>\n";
}

sub clinvar_tag_parser
{
  my $clinvar_tag = $_[0];
  my @clinvar_tag = split(/\|/, $clinvar_tag);
  my $i = 0;my @toreturn = ();my @clinvar_unnested_1 = ();my @clinvar_unnested_2;
  while( $i < @clinvar_tag )
  {
    my @clinvar_unnested_1 = split(/,/, $clinvar_tag[$i]);
    my $j = 0;
    while($j < @clinvar_unnested_1)
    {
      $clinvar_unnested_1[$j] =~ s /\\x2c/,/g;$clinvar_unnested_1[$j] =~ s/_/ /g;

      @clinvar_unnested_2 = split(/:/, $clinvar_unnested_1[$j]);
      $j++;
      
      push(@toreturn, @clinvar_unnested_2);
    }
  $i++;
  }
  return(\@toreturn);
}

sub dump_clinvar_5
{

  my $vcf = $_[0];my @vcf =split(/\t/,$vcf);
  my @genelist = @_[1..scalar(@_)-1];
  start_html_row();
  dump_single_value($vcf[0]);
  dump_single_value($vcf[1]);
  dump_single_value($vcf[3]);
  dump_single_value($vcf[4]);
  my $gts = parse_gt(@vcf[8..scalar(@vcf)]);
  dump_genelist(@genelist); 
  dump_GT($gts);

  dump_clinvar_5_meaning(@genelist);
  end_html_row();

}
sub dump_clinvar_5_meaning
{ my $i=0;
 print OUT "<td><p>";my $meaning="";
 while($i<@_)
{ 
 $meaning =$clinvar5{$_[$i]};
 $meaning=~s/,/\<br\>/g;
print OUT "$meaning";
 $i++; 
}
print OUT "</p></td>\n";
}
1;
