# Load necessary libraries
library(shiny)
library(dplyr)
library(reactable)
library(rmarkdown)
library(knitr)
library(zip)
library(readxl)
library(tidyverse)
library(writexl)


tools_list <- list(
  MetaboAnalyst = "https://www.metaboanalyst.ca",
  RAMPDB = "https://rampdb.nih.gov/",
  GOA = "https://goa.idsl.me/",
  KEGG = "https://www.kegg.jp",
  Metscape = "https://metscape.ncibi.org",
  FELLA = "https://bioconductor.org/packages/FELLA"
)


# Helper functions to modify Rmd based on user input
makeOutputAllg <- function(tools) {
  ret <- readLines("helpers/main.Rmd")
  return(ret)
}

makeOutputKEGGID <- function(ret) {
  keggid_lines <- readLines("helpers/KEGGID.Rmd")
  ret <- c(ret, "", "", keggid_lines)  # "" adds spacing like \n\n
  return(ret)
}

makeOutputKEGG <- function(ret) {
  kegg_lines <- readLines("helpers/KEGG.Rmd")
  ret <- c(ret, "", "", kegg_lines)  
  return(ret)
}

makeOutputFELLA <- function(ret) {
  fella_lines <- readLines("helpers/FELLA.Rmd")
  ret <- c(ret, "", "", fella_lines)  
  return(ret)
}

makeOutputMetscape <- function(ret) {
  metscape_lines <- readLines("helpers/Metscape.Rmd")
  ret <- c(ret, "", "", metscape_lines) 
  return(ret)
}

makeOutputMetaboA <- function(ret) {
  metaboa_lines <- readLines("helpers/metaboa.Rmd")
  ret <- c(ret, "", "", metaboa_lines)  
  return(ret)
}

makeOutputGOA <- function(ret) {
  goa_lines <- readLines("helpers/GOA.Rmd")
  ret <- c(ret, "", "", goa_lines)  
  return(ret)
}

makeOutputRAMPDB <- function(ret) {
  rampdb_lines <- readLines("helpers/RAMP.Rmd")
  ret <- c(ret, "", "", rampdb_lines)  
  return(ret)
}


# Function to build the Rmd content based on selected tools
buildRmdContent <- function(tools_selected) {
  res <- makeOutputAllg(tools_selected)
  
  if (any(c("KEGG", "FELLA", "Metscape") %in% tools_selected)) {
    res <- makeOutputKEGGID(res)
  }
  if ("KEGG" %in% tools_selected) {
    res <- makeOutputKEGG(res)
  }
  if ("FELLA" %in% tools_selected) {
    res <- makeOutputFELLA(res)
  }
  if ("Metscape" %in% tools_selected) {
    res <- makeOutputMetscape(res)
  }
  if ("MetaboAnalyst" %in% tools_selected) {
    res <- makeOutputMetaboA(res)
  }
  if ("GOA" %in% tools_selected) {
    res <- makeOutputGOA(res)
  }
  if ("RAMPDB" %in% tools_selected) {
    res <- makeOutputRAMPDB(res)
  }
  
  return(res)
}

# Function for parameter input when rendering the markdown  
buildReportParams <- function(input, output_dir, xlfile_df) {
  stopifnot(!is.null(xlfile_df))
  
  required_inputs <- c("log2FC", "log2FCpV", "pval", "text")
  missing_inputs <- setdiff(required_inputs, names(input))
  if (length(missing_inputs) > 0) {
    stop("Missing required input(s): ", paste(missing_inputs, collapse = ", "))
  }
  
  list(
    path = output_dir,
    xlfile_df = xlfile_df,
    log2FC = input$log2FC,
    log2FCpV = input$log2FCpV,
    pvalue = input$pval,
    user = input$text
  )
}

# Function to check if correct columns are in the file
has_any_col <- function(df, cols) {
  any(cols %in% names(df))
}

# Function to find missing columns
missing_cols <- function(df, required_cols) {
  cn <- trimws(colnames(df))  # remove leading/trailing spaces
  missing <- vapply(
    required_cols,
    function(req) !any(grepl(req, cn, fixed = TRUE)),
    logical(1)
  )
  required_cols[missing]
}

# Function to build the warning message
build_missing_message <- function(tool, missing) {
  paste0(
    tool, " selected, but the following required column(s) were not found: ",
    paste(missing, collapse = ", "),
    ". ",
    "At least one ID column is required for each tool. See help section for further info."
  )
}
