GetPicks <- function(filename) {
  picks.raw <-
    readChar(filename, file.info(filename)$size) %>%
    strsplit("~")
  parse <- function(x) substring(x, regexpr(":", x) + 1, nchar(x))
  clean <- function(x) gsub("\n", "", x) %>% str_trim
  picks.char <-
    lapply(picks.raw, parse) %>%
    lapply(clean) %>%
    unlist
  picks.char[2:length(picks.char)]
}

PicksDF <- function(ballots) {
  picks.list <-
    as.list(ballots) %>%
    lapply(GetPicks)
  picks <- do.call(rbind.data.frame, picks.list)
  cols <- c("NAME",
            "P - PICTURE",
            "R - ACTOR",
            "S - ACTRESS",
            "PR - SUPP_ACTOR",
            "PS - SUPP_ACTRESS",
            "D - DIRECTOR",
            "OS - ORIGINAL_SCREENPLAY",
            "AS - ADAPTED_SCREENPLAY",
            "F - FOREIGN",
            "DF - DOC_FEATURE",
            "AF - ANIM_FEATURE",
            "CT - CINEMATOGRAPHY",
            "E - EDITING",
            "PD - PRODUCTION_DESIGN",
            "CO - COSTUME",
            "M - MAKEUP",
            "VE - VISUAL_EFFECTS",
            "SO - SONG",
            "SC - SCORE",
            "SE - SOUND_EDITING",
            "SM - SOUND_MIXING",
            "SL - SHORT_LIVE",
            "DS - DOC_SHORT",
            "SA - SHORT_ANIM")
  names(picks) <- cols
  picks
}