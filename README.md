KAIJUXREPORT


Author:
Dimitar Kenanov – kenietz78@gmail.com



kaijuxReport.pl - program which creates a report file for kaijux. Its input is kaijux output file and hash file with headers of all sequences in the KaijuxDB.

Kaijux which is a part of the Kaiju metagenomics project which classifies reads or contigs: https://github.com/bioinformatics-centre/kaiju


The report file follows the Kaiju scheme but with 5 columns:

%	  - percent of all reads
reads	  - number of reads. Or contigs in the case of classifying contigs
id	  - protein sequence ID
desc	  - protein sequence description
species – species name

At the end of the report can be found those:

DET:S: - Detected seqs
TOT:R: - Total Num Read/Contigs
TOT:C: - Total Num Classifiled Reads/Contigs
TOT:U: - Total Num Unclassified Reads/Contigs	

A. Using kaijuxReport.pl
	
	kaijuxReport.pl -h HEADERS_HASH_FILE -k KAIJUX_OUTPUT > KAJ_REPORT_FILE


Instructions on how to build HEADERS_HASH_FILE and KAIJUX DB are provided below. One can create a full DB with all the hypothetical proteins or one might decide to exlude them. 



Example of creating of KAIJUX DB with Bacteria from refseq: 
ftp://ftp.ncbi.nlm.nih.gov/refseq/release/bacteria/

B. Create a regular KAIJUX DB
   1. Get all proteins from REFSEQ, e.g all 'bacteria.nonredundant_protein*.faa.gz' files.

   2. Cat all of them into a single file e.g 'all.fa'

   3. Get the headers with:
	
	'grep -P '^>' all.fa > headers.txt'
	
   4. Create a KAIJUX DB with the appropriate tools provided by KAIJU
	
	mkbwt -n 5 -a ACDEFGHIKLMNPQRSTVWY -o KJX_DB all.fa
	
	mkfmi KJX_DB

   5. Create a HEADERS_HASH_FILE with 'create_HEADERS_HASH_FILE.pl' 
   
	create_HEADERS_HASH_FILE.pl -h headers.txt -o HEADERS_HASH_FILE
	
C. Create KAIJUX DB without Hypothetical proteins 

   1. Get all proteins from REFSEQ, e.g all 'bacteria.nonredundant_protein*.faa.gz' files

   2. Cat all of them into a single file e.g 'all.fa'

   3. Get the headers with:
	
	grep -P '^>' all.fa > headers.txt
	
   4. Filter out the 'hypotetical protein' headers with:
	
	grep -v 'hypothetical protein' headers.txt > filtered_headers.txt
	
   5. Filter out the 'hypotetical protein' sequences with filter_fasta_by_name.pl 
	
	filter_fasta_by_name.pl -h filtered_headers.txt -fi all.fa -fo filtered.fa
	
   6. Create a KAIJUX DB with the appropriate tools provided by KAIJU
   	
	mkbwt -n 5 -a ACDEFGHIKLMNPQRSTVWY -o KJX_DB filtered.fa
	
	mkfmi KJX_DB
   
   7. Create a HEADERS_HASH_FILE with 'create_HEADERS_HASH_FILE.pl'
	
	create_HEADERS_HASH_FILE.pl -h filtered_headers.txt -o HEADERS_HASH_FILE
	



