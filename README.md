## CD-ID Selection v1.1
---
An interactive **R Shiny** application for pathway tool-based extraction of metabolite IDs from Compound Discoverer (CD) 3.5 data.
The app enables users to upload a file from CD 3.5 and select one or multiple pathway analysis tools, define significance thresholds, and automatically generate tool-specific output folders.


## Features
-	Upload metabolomics result table from CD 3.5
-	Select multiple pathway tools:
	-	MetaboAnalyst
 	-	IDSL.GOA
 	-	RaMP-DB
 	-	KEGG
  	-	FELLA
  	-	MetScape
-	Supports multiple metabolite identifier types depending on the tool:
	-	KEGG
 	-	HMDB
 	-	ChemSpider (CSID)
 	-	InChIKey
-	Interactive parameter selection:
	-	log2 fold-change threshold
 	-	p-value / adjusted p-value threshold
-	Dynamic one-line summary per selected tool
- Automatic report generation via R-Markdown
- Download all results as a structured ZIP archive

## Workflow
1.	Upload your metabolomics results table
2.	Choose one or more pathway analysis tools
3.	Define statistical thresholds
4.	Download the ZIP archive with all results
5.	Optional - check out the help section


## Application Structure
- app.R              # Main Shiny application
- helpers/           # functions and R-Markdowns
- www/               # help files and logo
---

## Getting Started
Click on the link: https://vbcfmetabotools.shinyapps.io/id_tool/ 

### Author
Gerlinde Grabmann

VBCF GmbH, Vienna, Austria
