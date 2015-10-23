open(FILE,"$ARGV[0]");
while($file=<FILE>)
{
  chomp($file);
  if($file =~/$ARGV[1]/)
  {
    $count_open = 0;
    $count_close=0;
    $i=0;
    @file=split(//,$file);
    while($i<@file)
    {
      if($file[$i] eq "\["){$count_open++;}
      if($file[$i] eq "\]"){$count_close++;}
      $i++;
    }
    while($count_open > $count_close)
    {
      $file=<FILE>;
      chomp($file);
      @file=split(//,$file);
      $i=0;
      while($i<@file)
      {
        if($file[$i] eq "\["){$count_open++;}
        if($file[$i] eq "\]"){$count_close++;}
        $i++;
      }
    }
  }
  else{print "$file\n";}
}

