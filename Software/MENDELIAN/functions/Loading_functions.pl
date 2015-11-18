sub load_clinvar 
{open(CLIN,"$_[0]");my %clinvar=();while($clin=<CLIN>){chomp($clin);if($clin !~/^#/){my @clin=split(/\t/,$clin);my $clinvar_uniq_id  = $clin[0]."\#".$clin[1]."\#".$clin[3]."\#".$clin[4];$clinvar{$clinvar_uniq_id} = $clin;}}close(CLIN);return(%clinvar);}

sub load_clinvar_5
{my %clinvar5=();open(CLIN,"$_[0]");while($clin=<CLIN>){chomp($clin);@clin=split(/\t/,$clin);$clinvar5{$clin[0]} = $clin[1];}close(CLIN);return(%clinvar5);}

sub load_gene_size
{$total=0;open(GENE,"$_[0]");%gene_size=();my $genes="";my @genes=();while($genes = <GENE>){chomp($genes);@genes=split(/\t/,$genes);$gene_size{$genes[0]} = $genes[1];$total=$total+$genes[1];}close(GENE);return(%gene_size);}

sub load_gene_number_2_gene_name
{my $file_path = $_[0];my  %hash =(); open(F,"$file_path"); my @f=(); my $f=""; while($f=<F>){@f=split(/\t/,$f);$hash{$f[0]}=$f[1];}close(F);return(%hash);}

sub load_ontology
{my %general_hash = (); my $line;my @line; open(HANDLER,"$_[0]"); while($line = <HANDLER>){chomp($line);@line=split(/\t/,$line);$general_hash{$line[0]} = $line;}return(%general_hash);}





1;
