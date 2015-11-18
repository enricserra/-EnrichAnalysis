sub hypergeometric
{my ($a,$c,$b,$d) = @_;my $af =lfact($a);my $bf =lfact($b);my $cf =lfact($c);my $df =lfact($d);my $nf =lfact($a+$b+$c+$d);my $abf =lfact($a+$b);my $cdf =lfact($c+$d);my $acf =lfact($a+$c);my $bdf =lfact($b+$d);my $p = exp( ($abf + $cdf + $acf + $bdf) - ($af + $bf + $cf + $df + $nf) );if($p<0){print "@_\n";}return $p;}

sub lfact 
{my $x=$_[0];if (!defined $computedlgammas{$x+1}) {$computedlgammas{$x+1} = lgamma($x+1);}return $computedlgammas{$x+1};}

sub lgamma 
{
my $xx = $_[0];
my ($j, $ser, $stp, $tmp, $x, $y);
my @cof = (0.0, 76.18009172947146, -86.50532032941677,24.01409824083091, -1.231739572450155, 0.1208650973866179e-2,-0.5395239384953e-5);$stp = 2.5066282746310005;$x = $xx; $y = $x;$tmp = $x + 5.5;$tmp = ($x+0.5)*log($tmp)-$tmp;$ser = 1.000000000190015;foreach $j ( 1 .. 6 ){
$y+=1.0;
$ser+=$cof[$j]/$y;
}
return $tmp + log($stp*$ser/$x);}

sub binomial
{
my $n = $_[0];
my $k = $_[1];
my $p = $_[2];
my $ln = lfact($n);
my $lk  = lfact($k);
my $ln_min_k = lfact($n -$k);
my $log_term2 = ($ln-$lk-$ln_min_k);
my $log_term1 = ($k*log($p)) + (($n-$k)*log(1-$p));
$toreturn=exp($log_term2+$log_term1);
return($toreturn);}

sub fisher_test_controls 
{
my $accumulated_p_val=0;
my @table_2_x_2=@_;
$table_2_x_2[1]=$table_2_x_2[1]+1;
$table_2_x_2[0]=$table_2_x_2[0]-1;
$table_2_x_2[2]++;
$table_2_x_2[3]--;
while($table_2_x_2[0]>=0 and $table_2_x_2[3]>=0){
  
  $accumulated_p_val=$accumulated_p_val+hypergeometric(@table_2_x_2);
  $table_2_x_2[1]=$table_2_x_2[1]+1;$table_2_x_2[0]=$table_2_x_2[0]-1;$table_2_x_2[2]++;$table_2_x_2[3]--;}if($accumulated_p_val >1){$accumulated_p_val = 1;}return(1- $accumulated_p_val);}

sub fisher_enrichment

{
my $k = $_[0]-1;
my $n = $_[3];
my $p = $_[1]/$_[2];
my $bin;
my $pval_rev=0;
while($k>=0){
$bin=binomial($n,$k,$p);$pval_rev = $pval_rev +$bin;$k--;}if($pval_rev>1){$pval_rev=1;}return(1-$pval_rev);}




#Pval Wrappers
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
    if($case_counts{$genes[$i]}>0){$genes_case_mutated++;}
    $case_counts = $case_counts + $case_counts{$genes[$i]};
    $i++;
  }
  $case_size = $size * scalar(@cases)*2;
  $drawn = $total_counts;
  my $pval = fisher_enrichment($case_counts,$case_size,$universe_size,$total_counts);chomp($pval);

  return($pval,$case_counts,"",$genes_case_mutated);

}

sub get_pval_case_control 
{
  my $size = $_[0];my @genes = @_[2..(scalar(@_)-1)];my $control_counts =0;my $case_counts= 0;
  my $this_particular_case_counts = 0;
  my $genes_case_mutated= 0;
  my $i=0;
  while($i<@genes)
  {
    if($case_counts{$genes[$i]} > 0)
    {
      $genes_case_mutated++;
    }
   $case_counts = $case_counts + $case_counts{$genes[$i]};
   $control_counts = $control_counts + $control_counts{$genes[$i]};
   $i++;
 }

 $case_size = $size * scalar(@rel_cases_pos)*2;
 $controls_size = $size * scalar(@rel_controls_pos)*2;
 my $pval = fisher_test_controls($case_counts,$case_size,$control_counts,$controls_size);
  if($pval <0 ){print "$pval \t CASE : $case_counts \t CASESIZE: $case_size\t CONTROL: $control_counts \t CONTSIZE : $controls_size\n";}
 chomp($pval);
 return($pval,$case_counts,$control_counts,$genes_case_mutated);
}

sub get_pval_from_list_of_genes
{if($controls){return(get_pval_case_control(@_));}
  else{return(get_pval_enrichment(@_));}
}





1;
