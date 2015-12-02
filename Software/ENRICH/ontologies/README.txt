Ontology related files:
	Contained in 2 directories, depending if we evaluate only coding
regions (Exon), or the whole gene interval (Gene).

Clinvar files are also in this directory (Clinvar5.tsv is the list of genes
that have been found to be related to disease-causing in clinvar), Clinvar.tsv
is just Clinvar database in plain text.

DB:
	KEGG -- From KEGG.db bioconductor
	Reactome -- From their official site (ReactomePathways.gmt)
	GO -- bioconductor for 
		, Then treated from termA->termB to
termA->termB,termC...termN
		Also treated for mapping:
			GOID	Gen1,Gen2,...Genn	car(Genes)
GO_size	GOterm_description


