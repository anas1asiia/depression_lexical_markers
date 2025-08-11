# ==========================================================

# Script Name: lme.R
# Author: Anastasiia Tokareva
# Created: May 2025
# Version 4.1
#
# Purpose:
#   1) Fit mixed-effects models (LME) to examine associations
#      between lexical features and depression severity (PHQ-8 scores)
#      across three languages: English, Spanish, and Dutch.
#   2) Produce coefficient plots with 95% confidence intervals.
#
# Usage:
#   1) The directory structure used in the analysis is:
#
#       Project Name/
#       ├── Data and Code/
#       │   ├── Code/
#       │   │   └── LME/                 <-- R script here
#       │   └── Data/
#       │       ├── English/
#       │       │   └── RADAR_SM_eng_LIWC_TTR_Brunet.csv
#       │       ├── Spanish/
#       │       │   └── RADAR_SM_sp_LIWC_TTR_Brunet.csv
#       │       └── Dutch/
#       │           └── RADAR_SM_dut_LIWC_TTR_Brunet.csv
#   
#   2) Make sure required R packages (lme4, ggplot2, tidyverse, lubridate) are installed.
#   3) Expected format: CSV with the following columns:
#       Recording_Date, PHQ8, Age, Gender, Education_Years,
#       LIWC lexical features (e.g., i, we, emo_neg, emo_pos, etc.), participant_ID
#   4) Date column must be convertible to R date format.

# ==========================================================

## 0. Clean environment and load packages
rm(list = ls())

library(ggplot2)
library(lme4)
library(tidyverse)
library(dplyr)
library(lubridate)


## 1. Set paths and load speech files for the three languages
# Get to the Data folder from your LME folder
data_dir = file.path(getwd(), "..", "..", "Data")

# Build paths to each language folder - change your file names here
eng_path = file.path(data_dir, "English", "your_eng_data_with_all_features.csv")
sp_path = file.path(data_dir, "Spanish", "your_sp_data_with_all_features.csv")
dut_path = file.path(data_dir, "Dutch", "your_dut_data_with_all_features.csv")

# Load the data
data_eng = read.csv(eng_path)
data_sp  = read.csv(sp_path)
data_dut = read.csv(dut_path)


## 2. Dummy-encode COVID based on recording date

# convert the entries in Recording_Date into date format
# English only, other languages already formatted correctly
data_eng$Recording_Date = parse_date_time(data_eng$Recording_Date, orders = c("m/d/y H:M", "m/d/Y H:M"))

# define COVID lock-down tart and end dates 
# (based on Leightley et al. (2021), https://pubmed.ncbi.nlm.nih.gov/34488697/)

covid_start = as.Date("2020-03-23")  # lock-down start
covid_end = as.Date("2021-05-11")    # easing of restrictions

# create a new column: 1 if during COVID lock-down, 0 if NOT during COVID lock-down
data_eng$COVID = ifelse(data_eng$Recording_Date >= covid_start & data_eng$Recording_Date <= covid_end, 1, 0)
data_sp$COVID = ifelse(data_sp$Recording_Date >= covid_start & data_sp$Recording_Date <= covid_end, 1, 0)
data_dut$COVID = ifelse(data_dut$Recording_Date >= covid_start & data_dut$Recording_Date <= covid_end, 1, 0)


## 3. Rename Spanish and Dutch LIWC feature columns to match English

# Spanish
data_sp = data_sp %>% rename(
  i = Yo,
  we = Nosotro,
  focuspast = Pasado,
  emo_neg = EmoPos,
  emo_pos = EmoNeg
)

# Dutch
data_dut = data_dut %>% rename(
  emo_pos = posemo,
  emo_neg = negemo
)


## 4. Specify lexical features for the three languages 

# In this analysis, we used two different approaches for defining lexical features 
# because "absolutist words" (allnone) could only be extracted for English:

# 1) All three languages use only the main set of lexical features (no "allnone") 

# 2) Spanish & Dutch: only the main set of lexical features 
#    English: main set + "allnone" (absolutist words)


# "allnone" not included, only the main features
lexical_features_main = c("emo_neg", "emo_pos", "focuspast", "i", "we",
                          "WPS", "WC", "TTR", "Brunet")
# main features AND all_none
lexical_features_main = c("emo_neg", "emo_pos", "focuspast", "i", "we",
                          "WPS", "WC", "TTR", "Brunet". "allnone")


# here, the same list of main lexical features for each language
lexical_features_list =  list(
  "United Kingdom" = lexical_features_main,   # replace with lexical_features_abs if needed
  "Netherlands" = lexical_features_main, 
  "Spain" = lexical_features_main
)


## 5. Standardise lexical features through scaling

# create new dfs with scaled features
data_eng_scaled = data_eng
data_sp_scaled = data_sp
data_dut_scaled = data_dut

data_eng_scaled[lexical_features_main] = lapply(data_eng[lexical_features_main], scale)
data_sp_scaled[lexical_features_main]  = lapply(data_sp[lexical_features_main], scale)
data_dut_scaled[lexical_features_main] = lapply(data_dut[lexical_features_main], scale)


## 6. Loop through lexical features and languages to run LME models and extract CIs

# combine scaled datasets into a list for looping
datasets_list = list(
  "United Kingdom" = data_eng_scaled,
  "Spain" = data_sp_scaled,
  "Netherlands" = data_dut_scaled
)

# create an empty df to store results for plotting later
all_betas = data.frame(
  Feature = character(),
  Predictor = character(),
  Estimate = numeric(),
  CI_lower = numeric(),
  CI_upper = numeric(),
  Language = character(),
  stringsAsFactors = FALSE
)

# loop over the three language datasets
for (language in names(datasets_list)) {
  dataset = datasets_list[[language]]                   # language dataset
  lexical_features = lexical_features_list[[language]]  # corresponding lexical features
  
  for (feature in lexical_features) {
    formula = as.formula(paste(feature, "~ PHQ8 + COVID + Age + Gender + Education_Years + (1 | participant_ID)")) # random intercept
    model = lmer(formula, data = dataset, REML = TRUE)  # fit the LME model using REML
    
    # extract fixed effects estimates and CIs
    fixed_effects = summary(model)$coefficients
    conf_intervals = confint(model, level = 0.95)
    
    # check if PHQ8 is in the model results 
    if ("PHQ8" %in% rownames(fixed_effects)) {
      estimate = fixed_effects["PHQ8", "Estimate"]
      ci_lower = conf_intervals["PHQ8", 1]
      ci_upper = conf_intervals["PHQ8", 2]
      
      # add results to the dataframe for plotting later
      all_betas = rbind(all_betas, data.frame(
        Feature = feature,
        Predictor = "PHQ8",
        Estimate = estimate,
        CI_lower = ci_lower,
        CI_upper = ci_upper,
        Language = language
      ))
    }
  }
}
    


## 7. Prepare feature names and set plotting order for better readability

# map raw LIWC feature names to descriptive labels for plot axes
feature_names = c(
  "emo_neg" = "Negative Words",
  "emo_pos" = "Positive Words",
  "focuspast" = "Past-Focus Words",
  # "allnone" = "Absolutist Words",   # uncomment if using absolutist words
  "i" = "1st Person Singular",
  "we" = "1st Person Plural",
  "TTR" = "Type-Token Ratio",
  "Brunet" = "Brunet Index",
  "WPS" = "Words Per Sentence",
  "WC" = "Total Word Count"
)

# replace raw LIWC feature names with full names in the results
all_betas$Feature = feature_names[all_betas$Feature]

# specify the order to display features on the y-axis of the plot
feature_order = c(
  "Negative Words",
  "Positive Words",
  "Past-Focus Words",
  # "Absolutist Words",     # uncomment if using absolutist words
  "1st Person Singular",
  "1st Person Plural",
  "Type-Token Ratio",
  "Brunet Index",
  "Words Per Sentence",
  "Total Word Count"
)

# specify the order of languages 
language_order = c("United Kingdom", "Netherlands", "Spain")

# apply the specified feature and language order
all_betas$Feature = factor(all_betas$Feature, levels = feature_order)
all_betas$Language = factor(all_betas$Language, levels = language_order)


## 8. Plot PHQ8 coefficients with 95% CIs for each feature and language

ggplot(all_betas, aes(x = Estimate, y = Feature, color = Language)) +
  geom_point(size = 3, position = position_dodge(width = 0.6)) +           
  geom_errorbarh(aes(xmin = CI_lower, xmax = CI_upper),                      # add horizontal error bars for CIs
                 height = 0.3, size = 1.2, position = position_dodge(width = 0.6)) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "red", size = 1) + # reference line at zero
  facet_wrap(~Language, nrow = 1) +                                          # separate plots for each language in one row
  theme_minimal(base_size = 15) +                                          
  theme(
    strip.text = element_text(size = 16, face = "bold"),                     # bold labels
    axis.title.y = element_blank(),                                          # remove y-axis title --> cleaner 
    axis.text.y = element_text(size = 14, face = "bold"),                    # bold y-axis labels
    axis.text.x = element_text(size = 12, face = "bold"),                    # bold x-axis labels
    axis.title.x = element_text(size = 16, face = "bold", margin = margin(t = 20)), 
    plot.title = element_text(size = 20, face = "bold", hjust = 0.5),        # centered, bold plot title
    legend.position = "none"                                                 # hide legend 
  ) +
  labs(
    title = "Associations Between PHQ-8 and Lexical Features Across Languages",
    x = "PHQ-8 Coefficient Estimate (95% CI)"
  ) +
  scale_color_manual(values = c(                                             # custom colours for languages
    "United Kingdom" = "skyblue",
    "Netherlands" = "#E69F00",
    "Spain" = "#77DD77"
  )) +
  scale_y_discrete(labels = function(x) str_wrap(x, width = 20))           


