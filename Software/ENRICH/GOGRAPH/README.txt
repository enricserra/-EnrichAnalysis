Go Graph files in Parent \t CHILD1;CHILD2;CHILD3....;CHILDN


Need to nest them in some json format. LIKE THIS:
{name : TERM1, "title" : TERM1 MEANING and  PVAL, color : hex transformed pvalue,children : [
 	{name:TERM2...},{},{}]

where TERM2 can have children as well as TERM1, resulting in:

{name : TERM1, "title" : TERM1 MEANING and  PVAL, color : hex transformed
pvalue,children : [     
        {name:TERM2...,children : [TERM3 ,...] },{},{}]  

#Using recursive function found in GOGraph_functions.pl

Because I have a hash of existence, I fill it with perl falsies, in this case
the pvalue  associated.
Then, in order to create colors I use a hex transformation function.

Filling each node with its children, its pvalue, and a color associated with
that pvalue.

