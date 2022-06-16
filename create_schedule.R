library(dplyr)
library(reshape2)
library(gargle)
library(googlesheets4)
library(knitr)
library(ggplot2)
library(ggthemes)
library(patchwork)
library(tidyr)
library(lubridate)

raw_dat <- read_sheet("https://docs.google.com/spreadsheets/d/1M_epV5ABZISMvdrVO6rOq0kGdJa3ANrbNtydhLlS7Wo/edit?usp=sharing", sheet = "Sheet1") %>% 
  mutate(Start = format(Start, format = "%H:%M"),
         End = format(End, format = "%H:%M"),
         Time = paste0(Start, "&nbsp;- ", End),
         Speaker = ifelse(is.na(Speaker), "", Speaker))



select(raw_dat, Time, Title, Speaker) %>% 
  setNames(c("Time", "Title", "Instructor/Speaker")) %>% 
  kable(escape = TRUE) %>% 
  print

