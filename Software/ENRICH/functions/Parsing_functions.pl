
sub Clean_and_sort_vcf_file
		{  open_vcf_or_gz_to_FILE($_[0]); open_to_OUT($_[1]); while(my $file=<FILE>){if($file =~ /^##/) {}elsif($file=~/^#/){
chomp($file);
%header_hash = create_header_hash($file);
     if($controls){@controls=create_array_from_header_hash($controls);}
     if($cases){@cases=create_array_from_header_hash($cases);print "@cases\n";}
     else{my @file = split(/\t/,$file);@cases = @file[9..(scalar(@file)-1)];$cases = join(",",@cases);@cases = create_array_from_header_hash($cases);}
}
else{$file = remove_chr_and_change_Y_M_MT_X($file); my @file = split(/\t/,$file);if(check_valid_chr($file[0])){insert_onto_array_of_chr($file[0],$file);}}}
}
	sub create_header_hash
 			{my $header = $_[0]; chomp($header);my @header=split(/\t/,$header);my $i=0;%header_hash=();while($i<@header){$header_hash{$header[$i]}=$i;$i++;}return(%header_hash);}
	sub create_array_from_header_hash
			{my $samples = $_[0];my @samples = split(/,/,$samples);my @samples_cols = ();my $i=0;while($i<@samples){if($header_hash{$samples[$i]}){push(@samples_cols,$header_hash{$samples[$i]});}$i++;}return(@samples_cols);}

	sub open_vcf_or_gz_to_FILE
			{@filename =  split(/\./,$_[0]);if(($filename[scalar(@filename)-1]  eq "gz") and ($filename[scalar(@filename)-2] eq "vcf")){open(FILE,"gunzip -c $_[0] |") or die "Could not open $_[0]\n";}elsif($filename[scalar(@filename)-1] eq "vcf"){ open(FILE,"$_[0]") or die "Could not open $_[0]\n";}else{die "Can not open $_[0] must be vcf or vcf.gz\n";}}

	sub open_to_OUT
			{open(OUT,">$_[0]");}

	sub remove_chr_and_change_Y_M_MT_X
			{my $line =$_[0];$line =~ s/^chr//;$line =~ s/^X/23/;$line =~ s/^Y/24/;$line=~s/^MT/25/;$line=~s/^M/25/;return($line);}

	sub check_valid_chr
			{my $chr = $_[0];my $i = 1; while($i<26){if($chr == $i){return(1);}$i++;} return(0);}

	sub insert_onto_array_of_chr
			{my $chr = $_[0];push(@{$array_of_chr[$chr]},$_[1]);}







sub match_pos_and_gene_and_clinvar
		{my $i=0;my $chr = $_[0];my $coord_type = $_[1];my @this_chr_array = @{$array_of_chr[$_[0]]};my $path_to_coord_file = $coordinates_path{$coord_type}."/".$chr."\.txt";open(INTERVALS,$path_to_coord_file);@this_vcf = next_pos($i);$i++;$this_interval = <INTERVALS>;@this_interval = split(/\t/,$this_interval);while($i<@this_chr_array and $this_interval){@intersect_result = intersect_point_and_interval($this_vcf[1],$this_interval[1],$this_interval[2],$this_interval[3]);if($intersect_result[0] eq "INCLUDED"){do_when_included($this_chr_array[$i],$this_interval[3]);match_with_clinvar(@this_vcf);$i++;  @this_vcf = next_pos($i);$vars_matched++;}elsif($intersect_result[0] eq "POINT_GT_INT"){$this_interval = <INTERVALS>;@this_interval = split(/\t/,$this_interval);}elsif($intersect_result[0] eq "POINT_LT_INT"){match_with_clinvar(@this_vcf);$i++;@this_vcf = next_pos($i);$vars_not_matched++;@this_vcf = split(/\t/,$this_chr_array[$i]);}else{die "Impossible situation, check\n\t INTERVALS :\n@this_interval\n\t VCF FILE : @this_vcf\n";}}}

	sub do_when_included
			{my $vcf =$_[0];my $genes = $_[1];add_to_genes($vcf,$genes);check_clinvar_5($vcf,$genes);}

		sub check_clinvar_5
                {my $vcf=$_[0];my @genelist = split(/,/,$_[1]);chomp(@genelist);my $flag= 0;my $i=0;my @resultgenes = ();while($i<@genelist){if($clinvar5{$genelist[$i]}){push(@resultgenes,$genelist[$i]);$flag=1;}$i++;}if($flag ==1){dump_clinvar_5($vcf,@resultgenes);}}

		
		sub add_to_genes
				{my $vcf =$_[0];chomp($vcf);my @genelist = split(/,/,$_[1]);chomp(@genelist);my @vcf=split(/\t/,$vcf);my $genotypes = parse_gt(@vcf[8..scalar(@vcf)-1]);my $i=0;while($i<@genelist){my $this_gene = $genelist[$i];if( $genes_matched{$this_gene} ){ $genes_matched{$this_gene} = $genes_matched{$this_gene}.";".$vcf[0]."\t".$vcf[1]."\t".$genotypes;}else{ $genes_matched{$this_gene} = $this_gene.";".$vcf[0]."\t".$vcf[1]."\t".$genotypes;}$i++;}}

	sub next_pos
	        {return(split(/\t/,$this_chr_array[$_[0]]));}

 	sub match_with_clinvar
		{my $chr = $_[0];my $pos = $_[1];my $ref= $_[3];my $alt=$_[4];if($alt=~/,/){my @alt=split(/,/,$alt);my $i=0;while($i<@alt){my @new = @_;$new[4] = $alt[$i];match_with_clinvar(@new);$i++;}}else{my $uniq_id = "$chr"."\#"."$pos"."\#"."$ref"."\#"."$alt";if($clinvar_hash{$uniq_id}){my $genotypes = parse_gt(@_[8..(scalar(@_)-1)]);push(@clinvar_found,($clinvar_hash{$uniq_id}."\t".$genotypes));}}}

sub parse_gt
	{my $format = $_[0];my @format = split(/:/,$format);my $i = 1;while($i<@format){if($format[$i] == "GT"){my $gt_pos = $i;$i=scalar(@format);}$i++;}my @samples = @_[1..scalar(@_)];my $i = 0;my $gt_string = "";while($i<@samples){my @this_sample = split(/:/,$samples[$i]);if($gt_string){$gt_string = $gt_string." ".$this_sample[$gt_pos];}else{$gt_string = $this_sample[$gt_pos];}$i++;}return($gt_string);}


1;
