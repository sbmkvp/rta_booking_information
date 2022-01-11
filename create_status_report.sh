#! /bin/bash

cat $1 \
  | jq -r '.[] | [.location, .result.ajaxresult.slots.nextAvailableDate] | @csv' \
  | Rscript -e 'suppressMessages(library(tidyverse)); 
                suppressMessages(library(jsonlite));
                read_csv(file("stdin"),
                         col_names = c("location","next_available_time"), 
                         col_types = cols()) %>% 
                  left_join(fromJSON("./docs/centers.json") %>%
                              select(location = id, name),
                            by = "location") %>% 
                  select(name, next_available_time) %>% 
                  format_csv() %>% cat();'
