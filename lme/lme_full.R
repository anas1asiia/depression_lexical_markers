# Script Name: lme_clean.R
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
#   - Place this script inside the `Code` folder.
#   - Store datasets as CSV files inside:
#       ../Data/English/
#       ../Data/Spanish/
#       ../Data/Dutch/
#   - Expected format: CSV with the following columns:
#       Recording_Date, PHQ8, Age, Gender, Education_Years,
#       lexical features (e.g., i, we, emo_neg, emo_pos, etc.),
#       participant_ID
#   - Date column must be convertible to R date format.
# ==========================================================

# 0. Clean environment
rm(list = ls())

# 1. Set working directory manually
# Adjust this to point to your "Data and Code" folder
setwd("C:/Users/k22005254/OneDrive - King's College London/NURF/Data and Code")

# 2. Define paths for each language dataset
eng_path <- file.path("Data", "English", "RADAR_SM_eng_LIWC_TTR_Brunet.csv")
sp_path  <- file.path("Data", "Spanish", "RADAR_SM_sp_LIWC_TTR_Brunet.csv")
dut_path <- file.path("Data", "Dutch", "RADAR_SM_dut_LIWC_TTR_Brunet.csv")

# 3. Load datasets
data_eng <- read.csv(eng_path)
data_sp  <- read.csv(sp_path)
data_dut <- read.csv(dut_path)