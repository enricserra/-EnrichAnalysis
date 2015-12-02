sub select_list_position_by_index
{my $list_ref = $_[0];my $index_ref = $_[1];my @list = @$list_ref;my @index = @$index_ref;return(@list[@index]);}

sub apply_function
{my $function = $_[0];my @arguments =@_[1..(scalar(@_)-1)];return($function->(@arguments));}

sub paste_str
{ my $str = $_[0]; my $sep = $_[1]; my $add = $_[2]; if($str) {return($str.$sep.$add);} else{return($add);}}


sub intersect_lists
{my $list1_ref = $_[0];my $list2_ref =$_[1];my @list1 = @$list1_ref;my @list2 = @$list2_ref;my %list1 = map{$_=>1} @list1;my %list2 = map{$_=>1} @list2;my @intersection = grep( $list1{$_}, @list2 );return(@intersection);}

sub intersect_point_and_interval
                        {my @point=($_[0]);my @interval=($_[1],$_[2],$_[3]);if($point[0] > $interval[0]){if($point[0] <= $interval[1]){return("INCLUDED",$interval[2]);}else{return("POINT_GT_INT","");}}else{return("POINT_LT_INT","");}}

sub open_file_and_dump_it_to_OUT
{open(HEAD,$_[0]);while($head = <HEAD>){print OUT "$head";}close(HEAD);}

sub open_results_file
{my $dir = $_[0];my $filename = $_[1];my $file_path = $dir."/$filename\.ejs";open(OUT,">$file_path");}




1;
