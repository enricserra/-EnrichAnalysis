#######################################
#				      #
#          Enric Serra Sanz	      #
#				      #
#  Mendelian  Analysis of VCF files   #
#				      #
#				      #
#1/10/2015			      #
#				      #
#				      #
#######################################

###################################
#                                 #
#            OPTIONS              #
# 				  #
###################################              
  use Getopt::Long;

  GetOptions(
    "input=s" => \$input,#Input vcf or vcf.gz file
    "coords=s" => \$coords,#Exon or Gene
    "cases=s" =>\$cases,#csv sample names as they are in the vcf HEADER
    "controls=s" =>\$controls,#csv sample names as they are in the vcf HEADER
    "output_dir=s" => \$output_dir,#directory where to output
    "debug=s" =>\$debug,
  );

  if(!$input or !$coords or !$output_dir or !$cases)
  {
    usage();
  }

####################################
##                                 #
##            REQUIRE              #
##                                 #
####################################  
  require "./functions/Loading_functions.pl";

  require "./vars/paths.pl";

  require "./functions/TopLevelVcf.pl";
  require "$vars_path" . "/variables.pl";
  %geneNumber2GeneName = loadGeneNumber2GeneName("$genes_path" . "/NCBI2GENE_NAME.txt");

  require "./functions/HTML.pl";
  require "./functions/VcfHeader.pl";
  require "./functions/VcfBody.pl";
  require "./functions/VcfGenotypes.pl";
  require "./functions/Variants2GenesAffected.pl";


  %geneNumber2GeneName = loadGeneNumber2GeneName("$genes_path" . "/NCBI2GENE_NAME.txt");
foreach $key (keys %geneNumber2GeneName){print "$key\t$geneNumber2GeneName{$key}\n"}


  cleanSortVcfFile($input);








####################################
##                                 #
##        LOAD USERS VCF           #
##                                 #
####################################  






  my $chromosome = 1;

  while($chromosome < 24)
  {

    findVariantsInGenes( $chromosome );
    $chromosome++;

  }

foreach $key (keys %geneHit)
{

  my $i = 0;
  while($i<@cases)
  {
    if($geneHits{$i}{$key} >1 )
    {
       $doubleHit{$i}{$key} = 1;

}
    $i++;
}
}

print "INTERSECTING DOM...\n"; 
  my $i = 1;
  my %dominantIntersection = %{$dominant{0}};
  while($i< @cases)
  {
    %dominantCase = %{$dominant{$i}};
    %dominantIntersection = hashIntersection(\%dominantIntersection,\%dominantCase);$i++;
  }
print "INTERSECTING DOM...DONE\n\n";

print "INTERSECTING REC...\n";

  my $i = 1;
  my %recessiveIntersection = %{$recessive{0}};
  while($i< @cases)
  {
    %recessiveCase = %{$recessive{$i}};
    %recessiveIntersection = hashIntersection(\%recessiveIntersection,\%recessiveCase);$i++;
  }
print "INTERSECTING REC...DONE\n\n";

print "INTERSECTING DHIT...\n";

  my $i = 1;
  my %doubleHitIntersection = %{$doubleHit{0}};
  while($i< @cases)
  {
    %doubleHitCase = %{$doubleHit{$i}};
    %doubleHitIntersection = hashIntersection(\%doubleHitIntersection,\%doubleHitCase);$i++;
  }
print "INTERSECTING DHIT...DONE\n\n";

print "INTERSECTING DHIT + REC...\n";

  my $i = 1;
  my %recessive = %{$recessive{0}};
  my %doubleHit = %{$doubleHit{0}};
  my %recessiveDoubleHitIntersection = hashUnion(\%recessive, \%doubleHit);
  

  while($i< @cases)
  {
  
    my %recessiveCase = %{$recessive{$i}};
    my %doubleHitCase = %{$doubleHit{$i}};
    my %recessiveDoubleHitCase = hashUnion(\%recessive, \%doubleHit);
    %recessiveDoubleHitIntersection = hashIntersection(\%recessiveDoubleHitIntersection,\%recessiveDoubleHitCase);$i++;

  }
print "INTERSECTING DHIT +REC DONE ...\n\n";





startHtml($headersPath{"GENESBY_CAT"} , $resultPath{"GENESDOM"} );
foreach $key (keys %dominantIntersection)
{  startHtmlRow();  startHtmlCell();dumpGeneNumber($key);  endHtmlCell();startHtmlCell();    my $variants = $dominantVariants{$key};    @variants = split(/\n/,$variants);    $i = 0;    while($i<@variants)    {      chomp($variants[$i]);      @variant_N = split(/\t/,$variants[$i]);      startHtmlSubCell();      print OUT "$variant_N[0]";      endHtmlSubCell();      $i++;    }$i=0;    endHtmlCell();    startHtmlCell();    while($i<@variants)    {
      chomp($variants[$i]);
      @variant_N = split(/\t/,$variants[$i]);
      startHtmlSubCell();
      print OUT "$variant_N[1]";
      endHtmlSubCell();
      $i++;
    }$i=0;
    endHtmlCell(); 
   startHtmlCell();
$i=0;    while($i<@variants)    {      chomp($variants[$i]);      @variant_N = split(/\t/,$variants[$i]);      startHtmlSubCell();      print OUT "$variant_N[3]";      endHtmlSubCell();      $i++;    }    endHtmlCell();    startHtmlCell();$i=0;    while($i<@variants)    {      chomp($variants[$i]);      @variant_N = split(/\t/,$variants[$i]);      startHtmlSubCell();      print OUT "$variant_N[4]";      endHtmlSubCell();
      $i++;    }    endHtmlCell();    startHtmlCell();$i=0;    while($i<@variants)    {      chomp($variants[$i]);      @variant_N = split(/\t/,$variants[$i]);      startHtmlSubCell();      my @casesColumns = @variant_N[@casesPositions];      my @casesGenotypes = ();      my $z = 0;      while($z < @casesColumns)      {         $casesGenotypes[$z] = sampleCol2Tag($casesColumns[$z],$variant_N[8],"GT");         $z++;      }
      print OUT "@casesGenotypes";      endHtmlSubCell();      $i++;    }    endHtmlCell();
    startHtmlCell();

    $i=0;while($i<@variants)    {      chomp($variants[$i]);      @variant_N = split(/\t/,$variants[$i]);      startHtmlSubCell();      my @casesColumns = @variant_N[@controlsPositions];      my @casesGenotypes = ();      my $z = 0;      while($z < @casesColumns)      {         $casesGenotypes[$z] = sampleCol2Tag($casesColumns[$z],$variant_N[8],"GT");         $z++;      }      print OUT "@casesGenotypes";      endHtmlSubCell();      $i++;     }     endHtmlCell(); 
  
  endHtmlRow();
}
closeHtml();

startHtml($headersPath{"GENESBY_CAT"} , $resultPath{"GENESREC"} );
foreach $key (keys %recessiveIntersection)
{  startHtmlRow();  startHtmlCell();dumpGeneNumber($key);  endHtmlCell();startHtmlCell();    my $variants = $recessiveVariants{$key};    @variants = split(/\n/,$variants);    $i = 0;    while($i<@variants)    {      chomp($variants[$i]);      @variant_N = split(/\t/,$variants[$i]);      startHtmlSubCell();      print OUT "$variant_N[0]";      endHtmlSubCell();      $i++;    }$i=0;    endHtmlCell();    startHtmlCell();    while($i<@variants)    {
      chomp($variants[$i]);
      @variant_N = split(/\t/,$variants[$i]);
      startHtmlSubCell();
      print OUT "$variant_N[1]";
      endHtmlSubCell();
      $i++;
    }$i=0;
    endHtmlCell();    
   startHtmlCell();    
$i=0;    while($i<@variants)    {      chomp($variants[$i]);      @variant_N = split(/\t/,$variants[$i]);      startHtmlSubCell();      print OUT "$variant_N[3]";      endHtmlSubCell();      $i++;    }    endHtmlCell();    startHtmlCell();$i=0;    while($i<@variants)    {      chomp($variants[$i]);      @variant_N = split(/\t/,$variants[$i]);      startHtmlSubCell();      print OUT "$variant_N[4]";      endHtmlSubCell();
      $i++;    }    endHtmlCell();    startHtmlCell();$i=0;    while($i<@variants)    {      chomp($variants[$i]);      @variant_N = split(/\t/,$variants[$i]);      startHtmlSubCell();      my @casesColumns = @variant_N[@casesPositions];      my @casesGenotypes = ();      my $z = 0;      while($z < @casesColumns)      {         $casesGenotypes[$z] = sampleCol2Tag($casesColumns[$z],$variant_N[8],"GT");         $z++;      }
      print OUT "@casesGenotypes";      endHtmlSubCell();      $i++;    }    endHtmlCell();
    startHtmlCell();

    $i=0;while($i<@variants)    {      chomp($variants[$i]);      @variant_N = split(/\t/,$variants[$i]);      startHtmlSubCell();      my @casesColumns = @variant_N[@controlsPositions];      my @casesGenotypes = ();      my $z = 0;      while($z < @casesColumns)      {         $casesGenotypes[$z] = sampleCol2Tag($casesColumns[$z],$variant_N[8],"GT");         $z++;      }      print OUT "@casesGenotypes";      endHtmlSubCell();      $i++;     }     endHtmlCell();

  endHtmlRow();
}
closeHtml();

startHtml($headersPath{"GENESBY_CAT"} , $resultPath{"GENESDOUBLEHIT"} );
foreach $key (keys %doubleHitIntersection)
{  startHtmlRow();  startHtmlCell();dumpGeneNumber($key);  endHtmlCell();startHtmlCell();    my $variants = $doubleHitVariants{$key};    @variants = split(/\n/,$variants);    $i = 0;    while($i<@variants)    {      chomp($variants[$i]);      @variant_N = split(/\t/,$variants[$i]);      startHtmlSubCell();      print OUT "$variant_N[0]";      endHtmlSubCell();      $i++;    }$i=0;    endHtmlCell();    startHtmlCell();    while($i<@variants)    {
      chomp($variants[$i]);
      @variant_N = split(/\t/,$variants[$i]);
      startHtmlSubCell();
      print OUT "$variant_N[1]";
      endHtmlSubCell();
      $i++;
    }$i=0;
    endHtmlCell();    
   startHtmlCell();    
$i=0;    while($i<@variants)    {      chomp($variants[$i]);      @variant_N = split(/\t/,$variants[$i]);      startHtmlSubCell();      print OUT "$variant_N[3]";      endHtmlSubCell();      $i++;    }    endHtmlCell();    startHtmlCell();$i=0;    while($i<@variants)    {      chomp($variants[$i]);      @variant_N = split(/\t/,$variants[$i]);      startHtmlSubCell();      print OUT "$variant_N[4]";      endHtmlSubCell();
      $i++;    }    endHtmlCell();    startHtmlCell();$i=0;    while($i<@variants)    {      chomp($variants[$i]);      @variant_N = split(/\t/,$variants[$i]);      startHtmlSubCell();      my @casesColumns = @variant_N[@casesPositions];      my @casesGenotypes = ();      my $z = 0;      while($z < @casesColumns)      {         $casesGenotypes[$z] = sampleCol2Tag($casesColumns[$z],$variant_N[8],"GT");         $z++;      }
      print OUT "@casesGenotypes";      endHtmlSubCell();      $i++;    }    endHtmlCell();
    startHtmlCell();

    $i=0;while($i<@variants)    {      chomp($variants[$i]);      @variant_N = split(/\t/,$variants[$i]);      startHtmlSubCell();      my @casesColumns = @variant_N[@controlsPositions];      my @casesGenotypes = ();      my $z = 0;      while($z < @casesColumns)      {         $casesGenotypes[$z] = sampleCol2Tag($casesColumns[$z],$variant_N[8],"GT");         $z++;      }      print OUT "@casesGenotypes";      endHtmlSubCell();      $i++;     }     endHtmlCell();

  endHtmlRow();
}
closeHtml();

startHtml($headersPath{"GENESBY_CAT"} , $resultPath{"GENESRECDOUBLEHIT"} );
foreach $key (keys %recessiveDoubleHitIntersection)
{  startHtmlRow();  startHtmlCell();dumpGeneNumber($key);  endHtmlCell();startHtmlCell();    my $variants = $doubleHitVariants{$key}.$recessiveVariants{$key};    @variants = split(/\n/,$variants);    $i = 0;    while($i<@variants)    {      chomp($variants[$i]);      @variant_N = split(/\t/,$variants[$i]);      startHtmlSubCell();      print OUT "$variant_N[0]";      endHtmlSubCell();      $i++;    }$i=0;    endHtmlCell();    startHtmlCell();    while($i<@variants)    {
      chomp($variants[$i]);
      @variant_N = split(/\t/,$variants[$i]);
      startHtmlSubCell();
      print OUT "$variant_N[1]";
      endHtmlSubCell();
      $i++;
    }$i=0;
    endHtmlCell();
   startHtmlCell();
$i=0;    while($i<@variants)    {      chomp($variants[$i]);      @variant_N = split(/\t/,$variants[$i]);      startHtmlSubCell();      print OUT "$variant_N[3]";      endHtmlSubCell();      $i++;    }    endHtmlCell();    startHtmlCell();$i=0;    while($i<@variants)    {      chomp($variants[$i]);      @variant_N = split(/\t/,$variants[$i]);      startHtmlSubCell();      print OUT "$variant_N[4]";      endHtmlSubCell();
      $i++;    }    endHtmlCell();    startHtmlCell();$i=0;    while($i<@variants)    {      chomp($variants[$i]);      @variant_N = split(/\t/,$variants[$i]);      startHtmlSubCell();      my @casesColumns = @variant_N[@casesPositions];      my @casesGenotypes = ();      my $z = 0;      while($z < @casesColumns)      {         $casesGenotypes[$z] = sampleCol2Tag($casesColumns[$z],$variant_N[8],"GT");         $z++;      }
      print OUT "@casesGenotypes";      endHtmlSubCell();      $i++;    }    endHtmlCell();
    startHtmlCell();

    $i=0;while($i<@variants)    {      chomp($variants[$i]);      @variant_N = split(/\t/,$variants[$i]);      startHtmlSubCell();      my @casesColumns = @variant_N[@controlsPositions];      my @casesGenotypes = ();      my $z = 0;      while($z < @casesColumns)      {         $casesGenotypes[$z] = sampleCol2Tag($casesColumns[$z],$variant_N[8],"GT");         $z++;      }      print OUT "@casesGenotypes";      endHtmlSubCell();      $i++;     }     endHtmlCell();

  endHtmlRow();
}
closeHtml();




#foreach $key (keys %dominantIntersection)
#{

#  print "$key \t$dominantIntersection{$key}\n";
#  print "$key\t$dominantVariants{0}{$key}\n";

#}

 

 

 # %GOBP = loadOntologyInfo("./ontologies/ONT2INFO/Exon/GOBP.txt");
 # foreach $key (keys %GOBP){print "$key\t$GOBP{$key}\n";}

   

sub loadOntologyInfo
{

  my %general_hash = ();
  my $line;
  my @line; 
  open(HANDLER,"$_[0]");

  while($line = <HANDLER>)
  {

    chomp($line);
    @line=split(/\t/,$line);
    $general_hash{$line[0]} = $line[4];

  }

  return(%general_hash);

}

sub loadGene2Ontology
{
  
  my %general_hash = ();
  my $line;
  my @line;
  open(HANDLER,"$_[0]");
  
  while($line = <HANDLER>)
  {
    
    chomp($line);
    $general_hash{$line[0]} = $line;

  }

  return(%general_hash);

}



sub intersectMultipleHashes
{
  my $i = 1;
  my %intersection = %{$_[0]};
  while($i < @_)
  {
 
    %intersection = hashIntersection(\%intersection,\%{$_[$i]});
    $i++;

  }
  return(%intersection);
}

sub hashIntersection
{
 
 my %hash1 = %{$_[0]};
 my %hash2 = %{$_[1]};
 my %hashToReturn = ();
 my @keys = keys %hash1;
 my $i=0;

 while($i < @keys)
 {

  if($hash2{$keys[$i]})
  {

    $hashToReturn{$keys[$i]}=1;

  }

  $i++;

 }

 return(%hashToReturn);

}

sub hashUnion #given 2 hash references returns union of elements (BOOLEAN)
{

  my %hash1 = %{$_[0]}; 
  my %hash2 = %{$_[1]};
  my %hashToReturn = %hash2;
  my @keys = keys %hash1; 
  my $i=0; 

  while($i<@k1) 
  {

    $hashToReturn{$keys[$i]}=1;  
    $i++; 

  }

  return(%hashToReturn);

}




sub usage
{
 print "
    #
    # Mendelian Analysis
    #
                
       -input        REQ     <path to input file name>
       -coord        REQ     <type of coordinates to use> Exon / Gene
       -output_dir   REQ     <path to output directory> 
       -cases        REQ     <CSV sample names to be used as cases> 
			       non case/control samples will be ignored
       -controls     OPT     <CSV sample names to be used as controls> 
                               non case/control samples will be ignored
 
    #
    # This is intended to find genes that have a likely Mendelian inheritance
    # pattern, selecting double hit genes and then intersecting that list
    # through all cases, to find genes and ontologies with double hit on 
    # all the cases.
    #
    # BYE!!
    # \n";
die "\n";
}




