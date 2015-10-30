
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

sub gene2html
{my $genenumber = $_[0];my $genesymbol = $gene_number_2_gene_name{$genenumber}; my $htmlstring = "<a href=\"http://www.ncbi.nlm.nih.gov/gene/" .$genenumber ."\">".$genesymbol."</a> ";return($htmlstring);}


sub dump_number
{my $number = $_[0];start_cell();print OUT "$number";end_cell();}

sub dump_genelist
{
 if(scalar(@_) <10){
start_cell();my $i=0;while($i<@_){dump_gene($_[$i]);$i++;}end_cell();}
 else{
my $genelist = join(@_," ");
my $scalar= scalar(@_);start_cell();print OUT "<p title=\"$genelist\"> $scalar </p>\n";end_cell();}
}

sub dump_gene
{my $genekey = $_[0];my $string = gene2html($genekey);print OUT "$string";}


1;
