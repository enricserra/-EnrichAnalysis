sub cleanSortVcfFile
{

  openVcfOrGzToFILE($_[0]);

  $vcfLineNumber = 0; 

  while(my $file = <FILE>)
  {
    chomp($file);
    $vcfLineNumber++;

    if( $file =~/^#/) 
    {
      
      useVcfHeader( $file );

    }

    else
    {

      useVcfBody( $file );

    }

  }

}


sub openVcfOrGzToFILE
{

  my @fileName =  split(/\./,$_[0]);

  if( ( $fileName[scalar(@fileName)-1]  eq "gz") and ( $fileName[scalar(@fileName)-2] eq "vcf") )
  {

    open(FILE,"gunzip -c $_[0] |") or die "Could not open $_[0]\n";

  }

  elsif( $fileName[scalar(@fileName)-1] eq "vcf" )
  {

    open(FILE,"$_[0]") or die "Could not open $_[0]\n";

  }

  else
  {

    die "Can not open $_[0] must be vcf or vcf.gz\n";

  }

}





1;
