        sub open_vcf_or_gz_to_FILE
                        {@filename =  split(/\./,$_[0]);if(($filename[scalar(@filename)-1]  eq "gz") and ($filename[scalar(@filename)-2] eq "vcf")){open(FILE,"gunzip -c $_[0] |") or die "Could not open $_[0]\n";}elsif($filename[scalar(@filename)-1] eq "vcf"){print "$_[0]\n"; open(FILE,"$_[0]") or die "Could not open $_[0]\n";}else{die "Can not open $_[0] must be vcf or vcf.gz\n";}}

        sub open_to_OUT
                        {open(OUT,">$_[0]");}

1;
