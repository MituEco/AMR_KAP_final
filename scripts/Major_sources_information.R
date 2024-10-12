# load packages
library(tidyverse)
library(gtsummary)
library(gt)
library(easystats)

# read data
data <- readxl::read_excel("rawdata/AMR_KAP_Data.xlsx", sheet = 1)

#major sources of information
data |>
  select(41:49) |>
  tbl_summary() |>
  as_gt() |>
  gtsave("tables/Table2_information.docx")




