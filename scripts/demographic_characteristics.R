#Demographic characteristics of study participants
# load packages
library(tidyverse)
library(gtsummary)
library(gt)
library(easystats)

# read data
data <- readxl::read_excel("rawdata/AMR_KAP_Data.xlsx", sheet = 1)

# Demographic characteristics of study participants
data |>
  select(1:11) |>
  tbl_summary() |>
  as_gt() |>
  gtsave("tables/Table1_Demographics.docx")



