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

# Factors associated with the level of practices

#Create knowledge level based on Total knowledge score
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


# Create practice level based on total practice score
data <- data |>
  mutate(practice_level = case_when(
    `total score of practice` < 4 ~ "poor",
    `total score of practice` >= 4 ~ "good"
  ))
## Ensure practice_level is a factor with ordered levels
data$practice_level <- factor(data$practice_level,
                              levels = c("poor", "good"),
                              ordered = TRUE)


# Fit the binary logistic regression model
glm_model <- glm(practice_level ~ `Parent’s age (years)` + `Parent’s sex` +
                   `Parent’s education level` + `Employment status` + `Family type` +
                   `Your average household income per month (BDT)` + `Child’s sex` +
                   `Child’s age (years)` + `Number of children` +
                   knowledge_level + attitude_level,
                 family = binomial(link = "logit"), data = data)

# Summarize the model
summary(glm_model)
report(glm_model)

#
glm_model |>
  tbl_regression(exponentiate = TRUE) |>
  bold_p(t = 0.05) |>
  as_gt() |>
  gtsave("tables/Table6_practice.docx")
