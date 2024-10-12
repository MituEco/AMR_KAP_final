
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


#Factors associated with level of knowledge
data <- data |>
  mutate(knowledge_level = case_when(
    `Total knowledge score` <5 ~ "Poor",
    `Total knowledge score` >= 5 ~ "Good"
  )
  )

# Ensure knowledge_level is a factor with ordered levels
data$knowledge_level <- factor(data$knowledge_level,
                               levels = c("Poor", "Good"),
                               ordered = TRUE)

## Fit a logistic regression model using glm

  glm_model <- glm(knowledge_level ~ `Parent’s age (years)` + `Parent’s sex` +
                     `Parent’s education level` + `Employment status` + `Family type` +
                     `Your average household income per month (BDT)` + `Child’s sex` +
                     `Child’s age (years)` + `Number of children`,
                   family = binomial(link = "logit"), data = data)


summary(glm_model)
report(glm_model)

# tbl_regression
glm_model |>
  tbl_regression(exponentiate = T) |>
  bold_p(t = 0.05) |>
  gtsave("tables/Table4_information.docx")


