sub hypergeometric
{my ($a,$c,$b,$d) = @_;my $af =lfact($a);my $bf =lfact($b);my $cf =lfact($c);my $df =lfact($d);my $nf =lfact($a+$b+$c+$d);my $abf =lfact($a+$b);my $cdf =lfact($c+$d);my $acf =lfact($a+$c);my $bdf =lfact($b+$d);my $p = exp( ($abf + $cdf + $acf + $bdf) - ($af + $bf + $cf + $df + $nf) );return $p;}

sub lfact 
{my $x=$_[0];if (!defined $computedlgammas{$x+1}) {$computedlgammas{$x+1} = lgamma($x+1);}return $computedlgammas{$x+1};}

sub lgamma 
{my $xx = $_[0];my ($j, $ser, $stp, $tmp, $x, $y);my @cof = (0.0, 76.18009172947146, -86.50532032941677,24.01409824083091, -1.231739572450155, 0.1208650973866179e-2,-0.5395239384953e-5);$stp = 2.5066282746310005;$x = $xx; $y = $x;$tmp = $x + 5.5;$tmp = ($x+0.5)*log($tmp)-$tmp;$ser = 1.000000000190015;foreach $j ( 1 .. 6 ){$y+=1.0;$ser+=$cof[$j]/$y;}return $tmp + log($stp*$ser/$x);}

sub binomial
{my $n = $_[0];my $k = $_[1];my $p = $_[2];my $ln = lfact($n);my $lk  = lfact($k);my $ln_min_k = lfact($n -$k);my $log_term2 = ($ln-$lk-$ln_min_k);
my $log_term1 = ($k*log($p)) + (($n-$k)*log(1-$p));
$toreturn=exp($log_term2+$log_term1);
return($toreturn);}

sub fisher_test_controls 
{my $accumulated_p_val=0;my @table_2_x_2=@_;$table_2_x_2 [0]=$table_2_x_2[0]-1;$table_2_x_2[1] =$table_2_x_2[1]+1;while($table_2_x_2[0]>=0 and $table_2_x_2[3]>=0){$accumulated_p_val=$accumulated_p_val+hypergeometric(@table_2_x_2);$table_2_x_2[1]=$table_2_x_2[1]+1;$table_2_x_2[0]=$table_2_x_2[0]-1;$table_2_x_2[2]++;$table_2_x_2[3]--;}return(1- $accumulated_p_val);}

sub fisher_enrichment
{
my $n = $_[3];
my $k = $_[0]-1;
my $p = $_[1]/$_[2];
my $bin;
my $pval_rev=0;
while($k>=0){
$bin=binomial($n,$k,$p);$pval_rev = $pval_rev +$bin;$k--;}if($pval_rev>1){$pval_rev=1;}return(1-$pval_rev);}
1;
