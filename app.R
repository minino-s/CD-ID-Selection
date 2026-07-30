
source("helpers/helpers.R")


# --- User Interface ---

ui <- fluidPage(
 
  tags$head(
      tags$html(lang = "en"),
      tags$script(HTML("
    document.documentElement.lang = 'en';
  ")),
    tags$style(HTML("
      .app-title {
        display: flex;
        align-items: center;
        gap: 10px;
      }
    "))
  ),
  
 
  titlePanel(
    tags$div(
      class = "app-title",
      
      tags$img(
        src = "logo.png",
        height = "60px",
        title = "CD-ID Selection – Identifier extraction for pathway/enrichment tools",
        style = "cursor: pointer;margin-bottom: 10px;margin-top: 2px;",
        onclick = "Shiny.setInputValue('about_click', Math.random())"
      ),
      
      tags$div(
        tags$span("CD-ID Selection", style = "font-weight:600; font-size:35px;",
                  style = "margin-top: 0px;"),           
        tags$br(),
        tags$small("Identifier extraction for pathway/enrichment tools",
                style = "margin-top: 4px;  margin-bottom: 10px; display:block;")
      )
    )
  ),
  
  
  sidebarLayout(
    sidebarPanel(
      
      width = 7,

      h3(HTML("<b>Project name</b>"), style = "margin-top: 0px; margin-bottom: 10px;"),
      p(HTML("Type in the name of your project. The files will be labelled with this name.")),
      textAreaInput( 
        "text", 
        label = NULL, 
        value = "Project"
      ), 
      
      h3(HTML("<b>Filtering based on statistics</b>"), style = "margin-top: 0px; margin-bottom: 0px;"),
      h4(HTML("<br><b>Only log2 FC</b><br> "), style = "margin-top: 0; margin-bottom: 10px;"),
      p(HTML("Set the log2 fold change (log2 FC) threshold to a positive value (e.g., 1). 
             This value will be applied symmetrically to extract both upregulated and downregulated features; 
             for example, setting log2 FC to 1 will select features with log2 FC ≥ 1 as well as features with log2 FC ≤ -1.
             <b>P-values will not be considered in this selection criterion</b>.<br><br>
             If you wish to ensure that only strongly regulated and statistically significant features are selected, a higher log2FC threshold (e.g. 5) should be set and
             the combination of a log2 FC with a (adj.) p-value threshold as defined below is required.
        <br><br>
        <b>Note:</b> Number of metabolites of KEGG and Metscape are not sensitive to statistics as all features holding a KEGG ID are required for these tools.")),
      
      numericInput("log2FC", "log2FC", value = 1, min = 0, max = 10), 
      verbatimTextOutput("log2FC"),
      
      h4(HTML("<br><b>Combined log2 FC and p-values</b><br> "), style = "margin-top: 0px; margin-bottom: 10px;"),
      p(HTML("Only metabolites with a <b>log2 FC</b> above the threshold <b>and</b> a <b>(adj.) p-value</b> below the threshold will be <b>selected</b> for the pathway tools. 
             This is useful to ensure that only <b>statistically significant features</b> are included in the analysis. <br><br>
             Log2 FC of 0.75 is less strict but justifyable in metabolomics for certain project. 1 is used as a cut off in other omics areas and >2 is considered more strict.")),
      numericInput("log2FCpV", "log2 FC with (adj.) p-value", value = 0.75, min = 0, max = 10), 
      verbatimTextOutput("log2FCpV"),
      
      numericInput("pval", "(adj.) p-value with log2 FC", value = 0.05, min = 0, max = 1), 
      verbatimTextOutput("pvalueLog2FC"),
      

    ),
    
    
    mainPanel(
      width = 5,
      
      # --- Data Input ---
      fluidRow(
        column(12,
               div(style = "background-color: #EAEAEA; padding: 20px; margin-bottom: 20px; border-radius: 5px;",
                   h3(HTML("<b>Input file</b>"), style = "margin-top: 0; margin-bottom: 10px;"),
                   p(HTML('Please select the metabolomics pathway file that was created 
                          with Compound Discoverer 3.5 at the VBCF Metabolomics facility
                          or any other xlsx file exported from CD 3.5 that meet the criteria
                          (<a href="#help_section">see Help Section</a>).
                          ')),
                   
                   fileInput("file", "Choose pathway File", multiple = FALSE,
                             accept = c("text/csv", ".csv", ".xls", ".xlsx")),
                 

                   checkboxGroupInput(
                       inputId = "tools",
                       label = NULL,
                       choiceNames = lapply(names(tools_list), function(name) {
                         tags$span(
                           name,
                           tags$a(
                             icon("globe"),
                             href = "#",
                             style = "margin-left:6px; color:lilac; cursor:pointer;",
                             onclick = sprintf(
                               "window.open('%s', '_blank'); return false;",
                               tools_list[[name]]
                               )
                            )
                         )
                       }),
                       choiceValues = names(tools_list)
                      ),
                    
                    verbatimTextOutput("pathway_data"),
                    verbatimTextOutput("rmdPreview"),
                    reactableOutput("table")
               )
            )
          ),
      
      # --- Download section ---
      fluidRow(
        column(12,
               div(style = "background-color: #EAEAEA; padding: 20px; border-radius: 5px;",
                   h3(HTML("<b>Output files</b>"), style = "margin-top: 0; margin-bottom: 10px;"),
                   p("Download files for selected tools."),
                   downloadButton("downloadData", "Download ZIP")
                  )
              )
              ),
      
      tags$head(
        tags$style(HTML("
     .tool-list li {
      line-height: 1.5;
      }
      "))),
      
      # --- help section ---
      fluidRow(
        column(
          12,
          div(
            id = "help_section",
            class = "help-section",
            style = "
        background-color: #EAEAEA;
        padding: 20px;
        border-radius: 5px;
        margin-top: 20px;
        
      ",
            
          h3(
              HTML("<b>Help Section<b>"),
              style = "margin-top: 0; margin-bottom: 14px;"
            ),
            
            h5(
              HTML(paste0(
              
                "– Which ",
                "<a href='help_Input_Logic.pdf' target='_blank'><b>columns</b></a>",
                " are required for each tool?<br><br>",
                
                "– Which ",
                "<a href='help_tools.pdf' target='_blank'><b>tools</b></a>",
                " should I select?<br><br>",
                
                "– What statistical ",
                "<a href='help_parameters.pdf' target='_blank'><b>parameters</b></a>",
                " should I use?<br><br>",
                
                "– How can the obtained files be used?<br><br>",
                
                "<ul class='tool-list'>",
                "<li><a href='help_MA.pdf' target='_blank'>MetaboAnalyst</a> </li> ",
                "<li><a href='help_GOA.pdf' target='_blank'>IDSL.GOA</a></li>",
               # "<li><a href='help_rampdb.pdf' target='_blank'>RampDB</a></li>",
                "</ul>"
              ))
            )
          )
        )
      )
      
    )
  )
)


# --- server ---

server <- function(input, output, session) {
  
  # --- Reactive value to hold uploaded data ---
  df_data <- reactiveVal(NULL)
  
  # --- Read uploaded file ---
  readData <- reactive({
    req(input$file)
    tryCatch({
      file_path <- input$file$datapath
      file_name <- input$file$name
      file_ext <- tools::file_ext(file_name)
      
      df <- switch(tolower(file_ext),
                   "xlsx" = read_excel(file_path),
                   stop("Unsupported file type")
      )
      
      df_data(df)  # store in reactiveVal
      df  # return for reactive
    }, error = function(e) {
      showNotification(paste("Error reading file:", e$message), type = "error")
      return(NULL)
    })
  })
  
  # --- Render the data table ---
  output$table <- renderReactable({
    df <- df_data()
    req(df)
    
    page_sizes <- c(5, 10, 25, 50)
    page_sizes <- page_sizes[page_sizes < nrow(df)]
    if (nrow(df) > 5) page_sizes <- c(page_sizes, nrow(df))
    
    reactable(
      df,
      defaultPageSize = 5,
      showPageSizeOptions = TRUE,
      pageSizeOptions = page_sizes
    )
  })
  
  # --- Render logo ---
  observeEvent(input$about_click, {
    showModal(modalDialog(
      title = "About CD-ID Selection",
      "Identifier extraction and prioritisation for pathway/enrichment analysis.",
      tags$br(),
      "Developed for Compound Discoverer workflows.",
      tags$br(),
      "Version 1.1",
      tags$br(),
      tags$a(
        "VBCF Metabolomics",
        href = "https://www.viennabiocenter.org/vbcf/metabolomics/",
        target = "_blank"
      ),
      ", Vienna, Austria",
      tags$br(),
      "Code available at",
      tags$a(
        "Github",
        href = "https://github.com/minino-s/CD-ID-Selection",
        target = "_blank"
      ),
      easyClose = TRUE,
      footer = NULL
    ))
  })
  
  # --- Tool column requirements ---
    tool_requirements <- list(
    GOA = list(cols = c("InChIKey", "P-value", "Log2 Fold Change")),
    KEGG = list(cols = c("KEGG", "P-value", "Log2 Fold Change")),
    FELLA = list(cols = c("KEGG", "P-value", "Log2 Fold Change")),
    Metscape = list(cols = c("KEGG", "P-value", "Ratio")),
    RAMPDB = list(cols = c("KEGG", "HMDB", "CSID", "P-value", "Log2 Fold Change")),
    MetaboAnalyst = list(cols = c("KEGG", "HMDB", "P-value", "Log2 Fold Change"))
  )
  
  # --- Notifications: only for newly selected tools ---
  prev_tools <- reactiveVal(character(0))
  
  observe({
    df <- df_data()
    req(df)
    
    current_tools <- input$tools %||% character(0)
    old_tools <- prev_tools()
    
    # Newly selected tools
    new_tools <- setdiff(current_tools, old_tools)
    
    for (tool in new_tools) {
      missing <- missing_cols(df, tool_requirements[[tool]]$cols)
      if (length(missing) > 0) {
        showNotification(build_missing_message(tool, missing),
                         type = "warning",
                         duration = 5)
      }
    }
    
    # Update previous selection
    prev_tools(current_tools)
  })
  
  
  # --- Log2FC / p-value validation and display ---
  output$log2FC <- renderText({
    validate(need(input$log2FC >= 0, "Error: Log2 FC value cannot be negative. Use a dot (.) as the decimal separator instead of a comma (,)"))
    paste(input$log2FC)
  })
  
  output$log2FCpV <- renderText({
    validate(need(input$log2FCpV >= 0, "Error: Log2 FC value cannot be negative. Use a dot (.) as the decimal separator instead of a comma (,)"))
    paste(input$log2FCpV)
  })
  
  output$pvalueLog2FC <- renderText({
    validate(need(input$pval >= 0, "Error: p-value cannot be negative. Use a dot (.) as the decimal separator instead of a comma (,)"))
    paste(input$pval)
  })
  
  # --- Render RMarkdown preview ---
  renderedPreviewText <- reactive({
    req(readData(), input$log2FC, input$log2FCpV, input$pval)
    
    tmp_dir <- tempfile("preview_")
    dir.create(tmp_dir)
    rmd_file <- file.path(tmp_dir, "preview.Rmd")
    
    res <- buildRmdContent(input$tools)
    writeLines(res, rmd_file)
    
    output_file <- file.path(tmp_dir, "preview_output.txt")
    
    rmarkdown::render(
      input = rmd_file,
      output_format = "md_document",
      output_file = output_file,
      quiet = TRUE,
      params = buildReportParams(input, tmp_dir, readData())
    )
    
    paste(readLines(output_file), collapse = "\n")
  })
  
  output$rmdPreview <- renderText({
    full_text <- renderedPreviewText()
    matches <- gregexpr("(?s)###START###.*?###END###", full_text, perl = TRUE)
    metabo_blocks <- regmatches(full_text, matches)[[1]]
    
    blocks_clean <- gsub("###START###", "", metabo_blocks)
    blocks_clean <- gsub("## ###END###", "", blocks_clean)
    blocks_clean <- gsub("^##\\s?", "", blocks_clean)
    blocks_clean <- trimws(blocks_clean)
    
    paste(blocks_clean, collapse = "\n")
  })
  
  # --- Download handler ---
  output$downloadData <- downloadHandler(
    filename = function() {
      paste0("Pathway_tools_", Sys.Date(), ".zip")
    },
    content = function(file) {
      if (is.null(input$file)) {
        showNotification("Please upload a file before downloading.", type = "error")
        return()
      }
      
      output_dir <- tempfile("report_")
      dir.create(output_dir)
      rmd_file <- file.path(output_dir, "report.Rmd")
      res <- buildRmdContent(input$tools)
      writeLines(res, rmd_file)
      
      rmarkdown::render(
        input = rmd_file,
        output_file = "report.html",
        output_dir = output_dir,
        params = buildReportParams(input, output_dir, readData())
      )
      
      zip_folder <- tempfile("zip_")
      dir.create(zip_folder)
      file.copy(file.path(output_dir, "report.html"),
                file.path(zip_folder, "report.html"))
      
      for (folder in input$tools) {
        src <- file.path(output_dir, folder)
        dest <- file.path(zip_folder, folder)
        if (dir.exists(src)) {
          dir.create(dest)
          files <- list.files(src, full.names = TRUE, recursive = TRUE)
          file.copy(files, dest, recursive = TRUE)
        }
      }
      
      oldwd <- setwd(zip_folder)
      on.exit(setwd(oldwd), add = TRUE)
      utils::zip(zipfile = file, files = list.files(zip_folder), flags = "-r9Xq")
    }
  ) 
}
# --- run app ---
shinyApp(ui = ui, server = server)
