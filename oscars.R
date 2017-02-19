options(stringsAsFactors = FALSE)
library(dplyr)
library(tidyr)
library(magrittr)
library(stringr)
library(ggplot2)
library(xtable)

Plot <- function(df) {
  winners <- read.csv("data/winners.csv", 
                      na.string = "")
  winners$CATEGORY_WINNER <- ifelse(!is.na(winners$WINNER), # winners are matched on category + pick combinations
                                    paste(winners$ABBR, winners$WINNER, sep = " "), 
                                    winners$WINNER)
  df %<>%
    mutate(CATEGORY_WINNER = winners$CATEGORY_WINNER[match(CATEGORY_PICK, winners$CATEGORY_WINNER)]) %>%
    mutate(ORDER = winners$ORDER[match(CATEGORY_PICK, winners$CATEGORY_WINNER)]) %>%
    mutate(POINTS = winners$POINTS[match(CATEGORY_PICK, winners$CATEGORY_WINNER)]) %>%
    subset(!is.na(CATEGORY_WINNER))
  
  df$NAME <- reorder(x = df$NAME, X = df$POINTS, FUN = sum) # reorders name factor level based on points leader
  
  cat.order <- as.character(unique(df$CATEGORY[order(df$ORDER)])) # reorders plot categories based on announced winner
  cat.reorder <- factor(df$CATEGORY, labels = cat.order)
  df$CATEGEORY_REORDER <- cat.reorder[match(df$CATEGORY, cat.reorder)]
  df$CATEGORY <- NULL
  names(df)[names(df) == "CATEGEORY_REORDER"]  <- "CATEGORY"
  df <- df[order(df$NAME, df$CATEGORY, df$ORDER),]
  
  df$POS <- ave(df$POINTS, df$NAME, FUN = function(x) cumsum(x) - .5 * x)  # label position on plot
  
  plot <- ggplot(df, aes(x = NAME, y = POINTS, fill = CATEGORY)) +
    geom_bar(stat = "identity") + 
    geom_text(aes(label = ABBR, y = POS), size = 2.5) + 
    scale_y_discrete("POINTS", limit = c(1:42)) + 
    coord_flip()
  
  ggsave("standings.png", 
         width = 13, 
         height = 7, 
         dpi = 105)
  
  plot
}

HTMLTables <- function(picks) {
  picks <- arrange(picks, NAME)
  names(picks) <- gsub("[A-z]+ - ", "", names(picks))
  names.col <- picks[1]
  categories <- picks[2:ncol(picks)]
  picks.list <- list()
  for(i in 1:ncol(categories)) {
    picks.list[[i]] <- cbind(names.col, categories[i])
    print.xtable(xtable(picks.list[[i]]),
                 type = "html", 
                 append = TRUE, 
                 include.rownames = FALSE,
                 file = "data/picks_tables.html")
  }
}

source("process_ballots.R")

ballots <- dir("data/completed_ballots", 
               pattern = "txt", 
               full.names = TRUE)

picks <- PicksDF(ballots) # pass "picks" into HTMLTables() for table creation

df <- # pass "df" into Plot() to make the plot
  gather(picks, CATEGORY, PICK, -NAME) %>%
  mutate(ABBR = substr(CATEGORY, 1, regexpr(" ", CATEGORY) - 1)) %>%
  mutate(CATEGORY_PICK = paste(ABBR, PICK, sep = " "))