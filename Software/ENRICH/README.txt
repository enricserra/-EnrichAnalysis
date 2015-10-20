
Enrich.pl Main script to launch analysis. Meant to be launched by the nodejs
server.

test_small.vcf a regular CNAG-formatted vcf (with lots of stuff in the ID
col), just to launch tests.

	Test:

	Case-Control:

		]$ perl Enrich.pl -input test_small.vcf -cases V801,V802 -controls V803,V804 -coords Exon -user_dir ./PRUEBA

	Enrichment:
        	]$ perl Enrich.pl -input test_small.vcf -cases V801,V802,V803,V804 -coords Gene -user_dir ./PRUEBA

	Will create a regular analysis in ./PRUEBA (ejs files which are regular html files but to be rendered by the ejs engine).

Directories:

	PRUEBA : Meant to hold execution of Enrich.pl tests.
	COORDINATES : Holds genomic intervals for genes (Coding-->Exon
Whole-->Gene).
	functions : functions needed for the analysis.
	GENES : NCBI2GeneName, translates gene number to gene-id.
	HEADERS : Headers for the html files.
	ontologies : Clinvar, GO (BP,MF,CC), KEGG, REACTOME.
	GOGRAPH : json version of the go graphs, minimized for human genes.	
	MISC : Other stuff unclassifiable (mostly methods to precompute)

