library(tidyverse)
library(jsonlite)
library(ggplot2)
library(lubridate)
library(scales)

data <- dir("old") |>
  enframe(value = "file", name = NULL) |>
  mutate(date = file |>
           str_remove_all('results_|.json') |>
           str_replace('_', ' ') |> str_replace('$', ' +1100') |>
           parse_datetime(format = "%Y-%m-%d %H:%M:%S %z",
                          locale = locale(tz = "Australia/Sydney") ) ) |>
  mutate(result = file |> str_replace('^', 'old/') |> lapply(read_file) |> unlist() ) |>
  filter(result != '') |> select(-file) |>
  mutate(result = result |> lapply(fromJSON, simplifyVector = FALSE ) ) |>
  mutate(result = result |> lapply(function(x){ x |>
      lapply(function(y){
        y$result$ajaxresult$slots$listTimeSlot %>%
          map_depth(., 2, ~ replace(., is.null(.), NA), .ragged = TRUE) |>
          map(as_tibble) |> bind_rows() |>
          mutate(id = as.numeric(y$location)) }) |>
      bind_rows() })) |>
  unnest(cols = c(result)) |>
  left_join(fromJSON("centers.json") |> select(id, location = name))


data |> filter(availability) |>
  mutate(date = date(date)) |> group_by(date, location) |> summarise() |> mutate(availability = TRUE) |> ungroup() |>
  complete(date = seq(min(date), max(date), by="1 day"), location = unique(location), fill = list(availability = FALSE)) |>
  ggplot() + geom_tile(aes(date,location,fill=availability)) +
  scale_fill_manual(values = c("#FFD6C9", "#7FDC96")) +
  xlab("") + ylab("") +
  theme_minimal() + theme(legend.position = "none")

