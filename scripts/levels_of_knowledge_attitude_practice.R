# load packages
library(tidyverse)
library(gtsummary)
library(gt)
library(easystats)

# read data

data <- readxl::read_excel("rawdata/AMR_KAP_Data.xlsx", sheet = 3)
# Create knowledge level based on total knowledge score
data <- data |>
  mutate(knowledge_level = case_when(
    `Total knowledge score` <= 3 ~ "Poor",
    `Total knowledge score` > 3 & `Total knowledge score` <= 7 ~ "Moderate",
    `Total knowledge score` > 7 ~ "Good"
  ))

# Create attitude level based on total attitude score


data <- data |>
  mutate(attitude_level = case_when(
    `total score of attitude` <= 3 ~ "negative",
    `total score of attitude` > 3 & `total score of attitude` <= 7 ~ "uncertain",
    `total score of attitude` > 7 ~ "positive"
  ))

# Create practice level based on total practice

data <- data %>%
  mutate(
    practice_level = case_when(
      `total score of practice` < 4 ~ "Poor",
      `total score of practice` >= 4 ~ "Good"
    )
  )
#
data |>
  select(47:49) |>
  tbl_summary() |>
  as_gt() |>
  gtsave("tables/Table3_level.docx")


