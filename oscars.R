options(stringsAsFactors = FALSE)
library(dplyr)
library(tidyr)
library(magrittr)
library(stringr)
library(ggplot2)
library(xtable)

Plot <- function(df) {
  # Create, save, and return an oscars pool standings plot
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
  cat.reorder <- factor(df$CATEGORY, labels = rev(cat.order)) # reverse for correct category ordering on plot
  df$CATEGEORY_REORDER <- cat.reorder[match(df$CATEGORY, cat.reorder)]
  df$CATEGORY <- NULL
  names(df)[names(df) == "CATEGEORY_REORDER"]  <- "CATEGORY"
  df <- df[order(df$NAME, df$ORDER),]
  
  df$POS <- ave(df$POINTS, df$NAME, FUN = function(x) cumsum(x) - .5 * x)  # label position on plot
  
  plot <- ggplot(df, aes(x = NAME, y = POINTS, fill = CATEGORY)) +
    geom_bar(stat = "identity") + 
    geom_text(aes(label = ABBR, y = POS), size = 2.5) + 
    scale_y_continuous("POINTS", limits = c(0,40), breaks = seq(0,40,2), expand = c(0, 0.5)) + 
    guides(fill = guide_legend(reverse = TRUE)) +
    coord_flip()
  
  ggsave("standings.png", 
         width = 11.5, 
         height = 7, 
         dpi = 105)
  
  return(plot)
}

HTMLTables <- function(picks) {
  # Create HTML tables of picks from the data frame returned by PicksDF
  picks <- arrange(picks, NAME)
  names(picks) <- gsub("[A-z]+ - ", "", names(picks))
  names.col <- picks[2]
  categories <- picks[3:ncol(picks)]
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
               pattern = "txt|csv",
               full.names = TRUE)

picks <- PicksDF(ballots) # pass "picks" into HTMLTables() for table creation

df <- # pass "df" into Plot() to make the plot
  gather(picks, CATEGORY, PICK, -NAME) %>%
  mutate(ABBR = substr(CATEGORY, 1, regexpr(" ", CATEGORY) - 1)) %>%
  mutate(CATEGORY_PICK = paste(ABBR, PICK, sep = " "))