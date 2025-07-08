library(shiny)
library(dplyr)
library(stringr)
library(DT)

# --- Helpers ---
is_vowel <- function(letter) {
  tolower(letter) %in% c("a", "e", "i", "o", "u")
}

generate_distractor <- function(word) {
  repeat {
    is_capital <- grepl("^[A-Z]", word)
    letters_only <- unlist(strsplit(tolower(word), split = ""))
    alphabet <- letters

    vowels <- letters_only[sapply(letters_only, is_vowel)]
    consonants <- letters_only[!sapply(letters_only, is_vowel)]

    new_vowels <- if (length(vowels) > 0) sample(c("a", "e", "i", "o", "u"), length(vowels), replace = TRUE) else character(0)
    new_consonants <- if (length(consonants) > 0) sample(setdiff(alphabet, c("a", "e", "i", "o", "u")), length(consonants), replace = TRUE) else character(0)

    all_letters <- sample(c(new_vowels, new_consonants))
    distractor <- paste(all_letters, collapse = "")

    if (is_capital && nchar(distractor) > 0) {
      substr(distractor, 1, 1) <- toupper(substr(distractor, 1, 1))
    }

    if (!(tolower(distractor) %in% phi)) {
      return(distractor)
    }
  }
}

generate_side_triplets <- function(n_targets) {
  df <- as.data.frame(matrix(sample(c(0, 1), n_targets * 3, replace = TRUE), ncol = 3, byrow = TRUE))
  names(df) <- c("side1", "side2", "side3")
  return(df)
}

# --- UI ---
ui <- fluidPage(
  titlePanel("Repetition Maze Distractor Generator"),
  tags$head(
    tags$style(HTML("
      #add {background-color: #28a745; color: white;}         /* Verde */
      #addSand {background-color: #007bff; color: white;}     /* Blu */
      #uploadFile {background-color: #17a2b8; color: white;}  /* Azzurro */
      #delete {background-color: #dc3545; color: white;}      /* Rosso */
      #reset {background-color: #6c757d; color: white;}       /* Grigio */
      #prevTrial {background-color: #ffc107; color: black;}   /* Giallo */
      #nextTrial {background-color: #fd7e14; color: white;}   /* Arancione */
      #downloadData {background-color: #6f42c1; color: white; border: none;} /* Viola */
    "))
  ),
  sidebarLayout(
    sidebarPanel(
      textInput("sentence", "Enter a sentence:", "L’astronomo osserva le piante"),
      actionButton("add", "Add Sentence"),
      actionButton("addSand", "Importa frasi SAND"),
      fileInput("fileInput", "Carica file .txt con frasi separate da virgole", accept = ".txt"),
      actionButton("uploadFile", "Importa frasi da file"),
      numericInput("deleteItem", "Delete item number:", NA),
      actionButton("delete", "Delete"),
      actionButton("reset", "Clear Dataset"),
      br(), br(),
      selectInput("distractorChoice", "Choose distractor version:", 
                  choices = c("dist1", "dist2", "dist3")),
      br(),
      downloadButton("downloadData", "Download Dataset")
    ),
    mainPanel(
      h4("Trial Presentation"),
      plotOutput("trialPlot", height = "200px"),
      fluidRow(
        column(6, align = "center", actionButton("prevTrial", "← Left")),
        column(6, align = "center", actionButton("nextTrial", "Right →"))
      ),
      hr(),
      h4("Dataset Preview (Editable)"),
      DTOutput("outputTable")
    )
  )
)

# --- Server ---
server <- function(input, output, session) {
  dataset <- reactiveVal(data.frame())
  trialIndex <- reactiveVal(1)

  process_sentence <- function(sentence, item_id_start) {
    # Pulizia e normalizzazione
    sentence <- tolower(sentence)
    sentence <- gsub("l['’]", "un ", sentence)
    sentence <- gsub("un['’]", "una ", sentence)
    sentence <- gsub("d['’]", "di ", sentence)
    sentence <- gsub("all['’]", "a ", sentence)
    sentence <- gsub("nell['’]", "in ", sentence)
    sentence <- gsub("sull['’]", "su ", sentence)
    sentence <- gsub("col['’]", "con il ", sentence)
    sentence <- gsub("['’]", "", sentence)
    words <- unlist(strsplit(sentence, "\\s+"))
    words <- gsub("[[:punct:]]", "", words)
    words <- words[words != ""]

    n_targets <- length(words)
    side_df <- generate_side_triplets(n_targets)

    rows <- bind_rows(lapply(seq_along(words), function(i) {
      data.frame(
        item = item_id_start,
        wp = i,
        target = words[i],
        dist1 = generate_distractor(words[i]),
        side1 = side_df$side1[i],
        dist2 = generate_distractor(words[i]),
        side2 = side_df$side2[i],
        dist3 = generate_distractor(words[i]),
        side3 = side_df$side3[i],
        stringsAsFactors = FALSE
      )
    }))
    return(rows)
  }

  observeEvent(input$add, {
    current_data <- dataset()
    new_item <- ifelse(nrow(current_data) == 0, 1, max(current_data$item) + 1)
    new_rows <- process_sentence(input$sentence, new_item)
    dataset(bind_rows(current_data, new_rows))
    trialIndex(1)
  })

  observeEvent(input$addSand, {
    sand_sentences <- c(
      "Il treno corre sui binari",
      "L’astronomo osserva le piante",
      "La bambina, che era sul prato, vide una farfalla posarsi su un albero",
      "Appena entrati nella stanza buia, abbiamo cercato l’interruttore per accendere la luce",
      "Il calciatore, che ha fatto un brutto fallo, è stato ammonito dall’arbitro",
      "Prima di mettere in moto la sua macchina, Luca si allacciò la scarpa"
    )
    current_data <- dataset()
    current_item <- ifelse(nrow(current_data) == 0, 1, max(current_data$item) + 1)
    new_data <- bind_rows(lapply(seq_along(sand_sentences), function(i) {
      process_sentence(sand_sentences[i], current_item + i - 1)
    }))
    dataset(bind_rows(current_data, new_data))
    trialIndex(1)
  })

  observeEvent(input$uploadFile, {
    req(input$fileInput)
    file_path <- input$fileInput$datapath
    raw_text <- readLines(file_path, warn = FALSE)
    full_text <- paste(raw_text, collapse = " ")
    split_sentences <- unlist(strsplit(full_text, ","))
    split_sentences <- trimws(split_sentences)
    split_sentences <- split_sentences[split_sentences != ""]
    current_data <- dataset()
    current_item <- ifelse(nrow(current_data) == 0, 1, max(current_data$item) + 1)
    new_data <- bind_rows(lapply(seq_along(split_sentences), function(i) {
      process_sentence(split_sentences[i], current_item + i - 1)
    }))
    dataset(bind_rows(current_data, new_data))
    trialIndex(1)
  })

  observeEvent(input$delete, {
    req(!is.na(input$deleteItem))
    dataset(dataset() %>% filter(item != input$deleteItem))
    trialIndex(1)
  })

  observeEvent(input$reset, {
    dataset(data.frame())
    trialIndex(1)
  })

  observeEvent(input$nextTrial, {
    idx <- trialIndex()
    if (idx < nrow(dataset())) trialIndex(idx + 1)
  })

  observeEvent(input$prevTrial, {
    idx <- trialIndex()
    if (idx > 1) trialIndex(idx - 1)
  })

  output$outputTable <- renderDT({
    datatable(dataset(), editable = TRUE, options = list(scrollX = TRUE))
  })

  proxy <- dataTableProxy("outputTable")
  observeEvent(input$outputTable_cell_edit, {
    info <- input$outputTable_cell_edit
    new_data <- dataset()
    row <- info$row
    col <- info$col + 1
    new_data[row, col] <- info$value
    dataset(new_data)
    replaceData(proxy, new_data, resetPaging = FALSE)
  })

  output$trialPlot <- renderPlot({
    data <- dataset()
    req(nrow(data) > 0)
    idx <- trialIndex()
    req(idx <= nrow(data))
    row <- data[idx, ]
    sideCol <- switch(input$distractorChoice,
                      "dist1" = row$side1,
                      "dist2" = row$side2,
                      "dist3" = row$side3)
    distCol <- row[[input$distractorChoice]]
    target <- row$target

    if (sideCol == 0) {
      left <- distCol
      right <- target
    } else {
      left <- target
      right <- distCol
    }

    par(mar = c(0, 0, 0, 0))
    plot(1, type = "n", xlim = c(0, 10), ylim = c(0, 1),
         xaxt = "n", yaxt = "n", bty = "n", xlab = "", ylab = "")
    text(3, 0.5, left, cex = 2)
    text(5, 0.5, "●", cex = 2)
    text(7, 0.5, right, cex = 2)
  })

  output$downloadData <- downloadHandler(
    filename = function() {
      paste0("stimuli_dataset_", Sys.Date(), ".csv")
    },
    content = function(file) {
      write.csv(dataset(), file, row.names = FALSE)
    }
  )
}

# --- Run app ---
shinyApp(ui = ui, server = server)
