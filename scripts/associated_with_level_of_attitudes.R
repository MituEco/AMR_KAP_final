# load packages
library(tidyverse)
library(gtsummary)
library(gt)
library(easystats)
library(report)
library(writexl)
library(MASS)
library(dplyr)
library(broom)
library(broom.mixed)
# read data

data <- readxl::read_excel("rawdata/AMR_KAP_Data.xlsx", sheet = 3)


#associated with the level of attitudes
data <- data |>
  mutate(attitude_level = case_when(
    `total score of practice` < 5 ~ "negative",
    `total score of practice` >= 5 ~ "positive"
  ))
# Ensure _level is a factor with ordered levels
data$attitude_level <- factor(data$attitude_level,
                               levels = c("negative", "positive"),
                               ordered = TRUE)
# Check for missing values in the data
summary(data)

## Fit a logistic regression model using glm

glm_model <- glm(attitude_level ~ `Parent’s age (years)` + `Parent’s sex` +
                   `Parent’s education level` + `Employment status` + `Family type` +
                   `Your average household income per month (BDT)` + `Child’s sex` +
                   `Child’s age (years)` + `Number of children`,
                 family = binomial(link = "logit"), data = data)
summary(glm_model)
report(glm_model)
#
glm_model |>
  tbl_regression(exponentiate = TRUE) |>
  bold_p(t = 0.05) |>
  as_gt() |>
  gtsave("tables/Table5_attitude.docx")
