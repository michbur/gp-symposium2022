library(dplyr)
library(reshape2)
library(gargle)
library(googlesheets4)
library(xtable)
library(ggplot2)
library(ggthemes)
library(patchwork)
library(tidyr)
library(lubridate)

raw_dat <- read_sheet("https://docs.google.com/spreadsheets/d/1M_epV5ABZISMvdrVO6rOq0kGdJa3ANrbNtydhLlS7Wo/edit?usp=sharing",
                  sheet = "Sheet1")

dat <- group_by(raw_dat, Session, What, Presenter, Chair) %>% 
  mutate(min_time = format(min(Time), format="%H:%M"), 
         max_time = format(max(Time) + minutes(5), format="%H:%M")) %>% 
  summarise(Hour = paste0(min_time, " - ", max_time)) %>% 
  ungroup %>% 
  arrange(Hour) %>% 
  unique %>% 
  mutate(Chair = ifelse(Chair == "MIchał Burdukiewicz", "Michał Burdukiewicz", Chair),
         Presenter = ifelse(is.na(Presenter), "", Presenter),
         Chair = ifelse(is.na(Chair), "", Chair),
         Session = ifelse(is.na(Session), "", Session),
         What = ifelse(is.na(What), "", What)) %>% 
  mutate(Presenter = ifelse(Presenter == "Adam Napieralski", "Adam Napieralski (Warsaw University of Technology)", Presenter),
         Presenter = ifelse(Presenter == "Robert Nowak", "Robert Nowak (Warsaw University of Technology)", Presenter),
         Presenter = ifelse(Presenter == "Dariusz Plewczyński", "Dariusz Plewczyński (Warsaw University of Technology)", Presenter)) %>% 
  rename(Title = What) 

cat("\n", file = "schedule.txt", append = FALSE)

lapply(split(dat, dat[["Session"]]), function(i) {
  single_table <- select(i, -Session, -Chair)
  
  cat("## ", paste0(unique(i[["Session"]]), " (", strsplit(first(single_table[["Hour"]]), " - ")[[1]][1],
      " - ", strsplit(last(single_table[["Hour"]]), " - ")[[1]][2], ")"), "\n", file = "schedule.txt", append = TRUE)
  cat(knitr::kable(single_table), sep = "\n", file = "schedule.txt", append = TRUE)
})
