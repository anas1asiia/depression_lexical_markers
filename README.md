# depression_lexical_markers

This repository contains code for a paper titled “Multilingual Lexical Markers and Text Embedding Prediction of Depression Symptom Severity” (https://kclpure.kcl.ac.uk/portal/en/publications/lexical-markers-and-text-embedding-prediction-of-depression-sympt), which explored **spoken language features across English, Dutch, and Spanish** to predict **Major Depressive Disorder (MDD) symptom severity**. We extracted both interpretable and high-dimensional language representations and evaluated their predictive performance using various machine learning models.

📌 **Note**: Due to privacy restrictions, we are **not able to share any datasets** in this repository. You can run the scripts with your own data using the required format.

---

## 📂 Project Structure

### 1. NLP Feature Extraction (`/nlp`)
- `ttr_brunet.ipynb`: Extracts **Type-Token Ratio (TTR)** and **Brunet's Index** to indicate lexical diversity.
- `mpnet_embed.py`: Extracts **dense sentence embeddings** using a multilingual Sentence-Transformer model (MPNet base v2) available on HuggingFace (https://huggingface.co/sentence-transformers/all-mpnet-base-v2).
- `coref_chain_ratio.ipynb`: Extracts **coreference chain ratio** from text.

***Note***: the remaining lexical features (incl. frequency of positive, negative, past-focus, absolutist words, and first-person singular and plural pronouns, were extracted using LIWC-22 (https://www.liwc.app/).

### 2. Linear Mixed Effects Modelling (`/lme`)
- `lme.R`: Runs **LME models** to analyse associations between lexical features and depression symptom severity (PHQ-8 scores).

### 3. Machine Learning Models (`/ml`)
#### Trained on Lexical Features and TF-IDF
- `elastic_net_lexical.ipynb`: Elastic Net regression
- `svr_lexical.ipynb`: Support Vector Regression
- `random_forest_lexical.ipynb`: Random Forest regression
- `xgboost_lexical.ipynb`: XGBoost regression

#### Trained on MPNet dense embeddings
- `elastic_net_embed.ipynb`: Elastic Net regression
- `svr_embed.ipynb`: Support Vector Regression
- `random_forest_embed.ipynb`: Random Forest regression
- `xgboost_embed.ipynb`: XGBoost regression

---

## 📬 Contact

If you have any questions or contributions, feel free to contact me:

Anastasiia Tokareva
📧 an.tokareva0601@gmail.com

