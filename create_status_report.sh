#! /bin/bash

cat $1 \
  | jq -r '.[] | [.location, .result.ajaxresult.slots.nextAvailableDate] | @csv' \
  | Rscript -e 'suppressMessages(library(tidyverse)); 
                read_csv(file("stdin"),
                         col_names = c("location","next_available_time"), 
                         col_types = cols()) %>% 
                  left_join(read_csv("centres.csv", 
                                     col_names=c("location","name"),
                                     col_types = cols()),
                            by = "location") %>% 
                  select(name, next_available_time) %>% 
                  format_csv() %>% cat();'
