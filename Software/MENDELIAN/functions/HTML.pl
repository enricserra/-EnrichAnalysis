sub startHtml
{  
  my $headerPath = $_[0];
  my $outputPath = $_[1];
  open(HEADER, $headerPath);
  open(OUT, ">$outputPath");

  while(my $header = <HEADER>)
  {

    print OUT "$header";

  }
  
  close(HEADER);

}

sub closeHtml
{

  close(OUT);

}

sub startHtmlRow
{
  if($_[0])
  {

    print OUT "<tr class=\"$_[0]\">\n";

  }

  else
  {

    print OUT "<tr>\n";

  }

}

sub endHtmlRow
{

  print OUT "</tr>\n";

}

sub startHtmlCell
{

  print OUT "<td>";

}

sub endHtmlCell
{

  print OUT "</td>";

}


sub startHtmlSubCell
{

  print OUT "<div>";

}

sub endHtmlSubCell
{

  print OUT "</div>";

}

sub geneNumber2Html
{

  my $geneNumber = $_[0];
  my $geneSymbol = $geneNumber2GeneName{$geneNumber};
  my $htmlString = "<a href=\"http://www.ncbi.nlm.nih.gov/gene/" .$geneNumber ."\">".$geneNumber2GeneName{$geneNumber} ."</a> ";
  return($htmlString);

}

sub dumpGeneNumber
{

  my $geneNumber = $_[0];
  chomp($geneNumber);
  my $string = geneNumber2Html($geneNumber);
  print OUT "$string";

}



1;
