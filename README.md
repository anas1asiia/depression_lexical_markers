# depression_lexical_markers

This repository contains code for a paper titled “Multilingual Lexical Markers and Text Embedding Prediction of Depression Symptom Severity” (doi or link here), which explored **spoken language features across English, Dutch, and Spanish** to predict **Major Depressive Disorder (MDD) symptom severity**. We extracted both interpretable and high-dimensional language representations and evaluated their predictive performance using various machine learning models.

📌 **Note**: Due to privacy restrictions, we are **not able to share any datasets** in this repository. You can run the scripts with your own data using the required format.

---

## 📂 Project Structure

### 1. NLP Feature Extraction (`/nlp`)
- `ttr_brunet.ipynb`: Calculates **Type-Token Ratio (TTR)** and **Brunet Index** for lexical diversity.
- `mpnet_embeddings.ipynb`: Extracts **dense sentence embeddings** using a multilingual Sentence-Transformer (MPNet).
- `coref_chain_ratio.ipynb`: Computes **coreference chain ratio** from text.

### 2. Linear Mixed Effects Modelling (`/lme`)
- `lme.ipynb`: Runs **LME models** to analyse associations between lexical features and depression severity.

### 3. Machine Learning Models (`/ml`)
- `elastic_net.ipynb`: Elastic Net regression
- `svr.ipynb`: Support Vector Regression
- `random_forest.ipynb`: Random Forest regression
- `xgboost.ipynb`: XGBoost model

---

## 🚀 Getting Started

### ✅ Requirements

Install dependencies using:

```bash
pip install -r requirements.txt

