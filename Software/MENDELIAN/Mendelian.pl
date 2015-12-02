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
    %dominantIntersection = multipleHashIntersection(\%dominant);
print "INTERSECTING DOM...DONE\n\n";

print "INTERSECTING DHIT...\n";
    %doubleHitIntersection = multipleHashIntersection(\%doubleHit);
print "INTERSECTING DHIT...DONE\n\n";

print "INTERSECTING REC...\n";
    %recessiveIntersection = multipleHashIntersection(\%recessive);
print "INTERSECTING REC...DONE\n\n";

%recDoubleHitVariants = variantIntersection(\%doubleHitVariants,\%recessiveVariants);

sub variantIntersection
{

  my %hash1 = %{$_[0]};
  my %hash2 = %{$_[1]};
  my %hashToReturn = ();
  foreach $key (keys %hash1)
  {
    if($hash2{$key})
    {
       my @vars = split(/\n/,$hash2{$key});
       my $i = 0;

       while($i < @vars)
       {
         
          $hash3{$vars[$i]} = 1;
          $i++;

       }
       my @vars = split(/\n/,$hash1{$key});
       my $i = 0;
       
       while($i < @vars)
       {

          $hash3{$vars[$i]} = 1;
          $i++;

       }

       my @keys = keys %hash3; 
       my $vars = join("\n",@keys);
       $hashToReturn{$key} = $vars;
    }

  }
  return(%hashToReturn);

}

sub multipleHashIntersection
{

  my %multipleHash = %{$_[0]};
  my @keys = keys %multipleHash;
  my %intersection = %{$multipleHash{0}};

  my $i = 1;
  while($i<@keys)
  {

    %intersection = hashIntersection(\%intersection, \%{$multipleHash{$i}});
    $i++;

  }
  return(%intersection);
}




print "INTERSECTING DHIT + REC...\n";

  my $i = 1;
  my %recessiveCase = %{$recessive{0}};
  my %doubleHitCase = %{$doubleHit{0}};
  my %recessiveDoubleHitIntersection = hashUnion(\%recessiveCase, \%doubleHitCase);
  $recessiveDoubleHit{0} =  \%recessiveDoubleHitIntersection;
 

  while($i< @cases)
  {
  
    my %recessiveCase = %{$recessive{$i}};
    my %doubleHitCase = %{$doubleHit{$i}};
    %recessiveDoubleHitCase = hashUnion(\%recessiveCase, \%doubleHitCase);
    $recessiveDoubleHit{$i} = \%recessiveDoubleHitCase;
    %recessiveDoubleHitIntersection = hashIntersection(\%recessiveDoubleHitIntersection,\%recessiveDoubleHitCase);
    $i++;

  }
print "INTERSECTING DHIT +REC DONE ...\n\n";



createHtmlForGenes(getPath2Headers("GENES","Dominant"), getPath2Results("GENES", "Dominant", $output_dir), \%dominantIntersection, \%dominantVariants);
createHtmlForGenes(getPath2Headers("GENES","Recessive"), getPath2Results("GENES", "Recessive", $output_dir), \%recessiveIntersection, \%recessiveVariants);
createHtmlForGenes(getPath2Headers("GENES","DoubleHit"), getPath2Results("GENES", "DoubleHit", , $output_dir), \%doubleHitIntersection, \%doubleHitVariants);
createHtmlForGenes(getPath2Headers("GENES","RecessiveDoubleHit"), getPath2Results("GENES", "RecessiveDoubleHit", $output_dir), \%recessiveDoubleHitIntersection, \%recDoubleHitVariants);


$sca=scalar(@cases);
print "@cases\t$sca\n";
#TODO Destroy this monster
sub createHtmlForGenes
{

  my $headerPath = $_[0];
  my $resultPath = $_[1];
  my %intersection = %{$_[2]};
  my %variants = %{$_[3]};
  startHtml($headerPath , $resultPath);
  foreach $key (keys %intersection)
  { 
    
    if($variants{$key}){
    startHtmlRow(); 
    startHtmlCell();
    dumpGeneNumber($key);  
    endHtmlCell();
    startHtmlCell();    
    my $variants = $variants{$key};    
    @variants = split(/\n/,$variants);    
    $i = 0;    
    
    while($i<@variants)    
    {      
      chomp($variants[$i]);      
      @variant_N = split(/\t/,$variants[$i]);
      startHtmlSubCell();
      print OUT "$variant_N[0]";
      endHtmlSubCell();
      $i++;

    }
    startHtmlCell();
    my $variants = $variants{$key};
    @variants = split(/\n/,$variants);
    $i = 0;

    while($i<@variants)
    {
      chomp($variants[$i]);
      @variant_N = split(/\t/,$variants[$i]);
      startHtmlSubCell();
      print OUT "$variant_N[1]";
      endHtmlSubCell();
      $i++;

    }
    endHtmlCell();

    endHtmlCell();
    startHtmlCell();
    $i=0;
    while($i<@variants)
    {
      chomp($variants[$i]);
      @variant_N = split(/\t/,$variants[$i]);      
      startHtmlSubCell();      
      print OUT "$variant_N[3]";      
      endHtmlSubCell();      
      $i++;    
    }
    endHtmlCell();    
    startHtmlCell();
    $i = 0;
    while($i<@variants)   
    {
       chomp($variants[$i]);  
       @variant_N = split(/\t/,$variants[$i]);      
       startHtmlSubCell();     
       print OUT "$variant_N[4]";     
       endHtmlSubCell();
       $i++;   
    }
    endHtmlCell();
    startHtmlCell();
    $i = 0;
    while($i<@variants)
    {
       chomp($variants[$i]);
       @variant_N = split(/\t/,$variants[$i]);
       startHtmlSubCell();
       my @casesColumns = @variant_N[@casesPositions];
       my @casesGenotypes = ();
       my $z = 0;
       while($z < @casesColumns)
       {
          $casesGenotypes[$z] = sampleCol2Tag($casesColumns[$z],$variant_N[8],"GT");
          $z++;
       }
       print OUT "@casesGenotypes";
       endHtmlSubCell();
       $i++;
    }
    endHtmlCell();
    startHtmlCell();
    $i=0;
    while($i<@variants)
    {
      chomp($variants[$i]);
      @variant_N = split(/\t/,$variants[$i]);
      startHtmlSubCell();
      my @casesColumns = @variant_N[@controlsPositions];
      my @casesGenotypes = ();
      my $z = 0;
      while($z < @casesColumns)
      {
         $casesGenotypes[$z] = sampleCol2Tag($casesColumns[$z],$variant_N[8],"GT");
         $z++;
      }
      print OUT "@casesGenotypes";
      endHtmlSubCell();
      $i++;
    }
    endHtmlCell();
    endHtmlRow();}
  }
  closeHtml();
}


#####################################################GOMF###########

@ontologies = ("GOBP", "GOMF", "GOCC", "KEGG", "REACTOME");
@inheritance = ("Dominant","Recessive", "DoubleHit", "RecessiveDoubleHit");
@hashesOfIntersections = (\%dominantIntersection, \%recessiveIntersection, \%doubleHitIntersection, \%recessiveDoubleHitIntersection);
@hashesOfSamples = (\%dominant, \%recessive, \%doubleHit, \%recessiveDoubleHit);


my $ontologyNumber = 0;

while($ontologyNumber < @ontologies)
{
 
  my $patternNumber = 0;
  
  while($patternNumber < @inheritance)
  {

    createHtmlForOntology($ontologies[$ontologyNumber], $inheritance[$patternNumber],$hashesOfIntersections[$patternNumber],$hashesOfSamples[$patternNumber]);
    $patternNumber++;

  }
  
  $ontologyNumber++; 

}




sub createHtmlForOntology
{
  
  my $ontologyName = $_[0];
  my $inheritance = $_[1];
  my %genesAffected = %{$_[2]};
  my %genesBySample = %{$_[3]};
  my %ontologyUnion = ();
  my %ontology = loadOntologyInfo("./ontologies/ONT2INFO/$coords/$ontologyName\.txt");
  my %Genes2Ontology =  loadGene2Ontology("./ontologies/GENE2ONT/Gene2$ontologyName");

  print "Calculating Union for $ontologyName $inheritance...\n";
  my $i = 0;

  while($i<@cases)
  {

    %case = %{$genesAffected{$i}};
    @genesAffected = keys(%genesAffected);
    $t = 0;

    while($t < @genesAffected)
    {

      chomp($genesAffected[$t]);
      @ontologiesInThisGene = split(/\t/, $Genes2Ontology{$genesAffected[$t]});
      $z = 1;

      while($z < @ontologiesInThisGene)
      {
 
        $ontologyUnion{$i}{$ontologiesInThisGene[$z]}{$genesAffected[$t]} = 1;
        $z++;

      }
 
      $t++;

    }

    $i++;

  }

  print "Calculating Union for $ontologyName $inheritance DONE...\n";

  my $i = 1;
  %intersection = %{$ontologyUnion{0}};
  
  while($i<@cases)
  {

    %intersection = hashIntersection(\%intersection,$ontologyUnion{$i});
    $i++;

  }
  startHtml(getPath2Headers($ontologyName, $inheritance), getPath2Results($ontologyName, $inheritance));

  foreach  my $key (keys %intersection)
  {
 
    chomp($key);
    @info  =split(/\t/,$ontology{$key});
    startHtmlRow();
    dumpId($ontologyName,$key);
    dumpString($info[4]);
    @genesInThisCategory = split(/,/,$info[1]);
    $geneCountInThisCategory = scalar(@genesInThisCategory);
    $i=0;
    startHtmlCell();
 
    while($i<@cases)
    {

      startHtmlSubCell();
      
      my %hash = %{$ontologyUnion{$i}{$key}};
      my @keys = @genesInThisCategory;
      @final = ();
      $z=0;while($z<@keys){chomp($keys[$z]);if($genesBySample{$i}{$keys[$z]}){push(@final,$keys[$z]);}$z++;}
      dumpGeneList(@final);
      endHtmlSubCell();
      $i++;

    }
    dumpString($geneCountInThisCategory);


    endHtmlCell();
    endHtmlRow();

  }

  closeHtml();
  print "Document for $ontologyName $inheritance DONE...\n";

}



##############################################################################################


sub dumpString
{

  startHtmlCell();
  print OUT "$_[0]";
  endHtmlCell();

}

sub dumpGeneList
{

  if(scalar(@_) <10)
  {

    my $i=0;
    while($i<@_)
    {

      dumpGeneNumber($_[$i]);
      $i++;
    }
  }

  else
  {

    my $i = 0;
    while($i<@_)
    {
      
      $_[$i] = $geneNumber2GeneName{$_[$i]};
      chomp($_[$i]);
      $i++;

    }

    my $genelist = join(" ",@_);
    my $scalar= scalar(@_);print OUT "<p title=\"$genelist\"> $scalar </p>\n";

  }

}

sub dumpId
{

  if($_[0]=~/^GO/){return(dumpGoId(@_));}
  if($_[0] eq "KEGG"){return(dumpKEGGId(@_));}  
  if($_[0] eq "REACTOME"){return(dumpREACTOMEId(@_));}

}

sub dumpGoId
{

  startHtmlCell();
  print OUT "<a href=\"".go2href($_[1])."\"> $_[1] </a>\n";
  endHtmlCell();

}   

sub dumpKEGGId
{

  startHtmlCell();
  print OUT "<a href=\"".kegg2href($_[1])."\"> $_[1] </a>\n";
  endHtmlCell();

}

sub dumpREACTOMEId
{

  startHtmlCell();
  print OUT "$_[1] ";
  endHtmlCell();

}


sub kegg2href
{

  return("http://www.genome.jp/kegg-bin/show_pathway?hsa" . $_[0]);

}





sub go2href
{

  return("http://www.ebi.ac.uk/QuickGO/GTerm?id=$_[0]\#term=children");

}



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
    $general_hash{$line[0]} = $line;

  }
  close(HANDLER);
  return(%general_hash);

}

sub loadGene2Ontology
{
  
  my $line;
  my @line;
  my %general_hash = ();
  open(HANDLER,"$_[0]");
  
  while(my $line = <HANDLER>)
  {
    
    chomp($line);
    @line = split(/\t/,$line);
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

  while($i < @keys) 
  {

    $hashToReturn{$keys[$i]} =1;  
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




