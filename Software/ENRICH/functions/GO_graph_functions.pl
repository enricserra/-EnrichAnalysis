

sub generate_colors_from_pvals
{  my $pval=$_[0]*15;my $rounded_green = int($pval + 0.5);my $rounded_red=15-$rounded_green;my $hex_red=sprintf("%x",$rounded_red);my $hex_green=sprintf("%x",$rounded_green);my $string="$hex_red"."$hex_red"."$hex_green"."$hex_green"."00";return($string);}
1;
