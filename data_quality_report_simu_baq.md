# 📊 Data Quality Report – SimuBAQ

## 1. Context
This report presents the data quality assessment for the **SimuBAQ** project. The dataset corresponds to a **simulated survey of 1,000 respondents**, designed to analyze digital skills, application usage, learning needs, and availability for digital literacy programs among adults and older adults.

Prior to analytical processing and dashboard development in Power BI, a data quality evaluation was conducted to ensure the reliability, consistency, and analytical readiness of the data.

---

## 2. Data Source Overview
- **Source:** Structured survey (Google Forms – simulated data)
- **Records:** 1,000 respondents
- **Storage:** PostgreSQL (loaded via DBeaver)
- **Model:** Star Schema (Fact, Dimensions, Bridge tables)
- **Preprocessing:** Python (Pandas) – Jupyter Notebook

---

## 3. Data Quality Dimensions Evaluated
The following standard BI data quality dimensions were assessed:

| Dimension | Description |
|--------|------------|
| Completeness | Presence of required values in critical fields |
| Validity | Values fall within expected ranges and formats |
| Consistency | Logical coherence and absence of contradictions |
| Uniqueness | No duplicate records |
| Distribution | Balanced and non-biased data distribution |

---

## 4. Data Quality Metrics & Results

### 4.1 Completeness
- **Total records:** 1,000
- **Critical fields evaluated:**
  - `survey_id`
  - `response_date`
  - `phone_skill_level`

**Result:**
- 100% completeness in all critical analytical fields.

> *The dataset shows full completeness for all key variables required for BI analysis.*

---

### 4.2 Validity

**Digital Skill Level Range Validation:**
- Expected range: 1 to 5
- Observed range: 1 to 5

**Result:**
- All records fall within valid numeric ranges.

> *No invalid or out-of-range values were detected.*

---

### 4.3 Consistency

**Distribution of Digital Skill Levels:**

| Skill Level | Respondents |
|------------|-------------|
| 1 | 212 |
| 2 | 185 |
| 3 | 212 |
| 4 | 191 |
| 5 | 200 |

**Average Skill Level:** 2.98

**Result:**
- Balanced distribution across levels
- No abnormal concentrations or inconsistencies detected

> *The data reflects a coherent and realistic distribution aligned with the target population.*

---

### 4.4 Uniqueness

- **Total rows:** 1,000
- **Unique survey IDs:** 1,000

**Result:**
- No duplicate responses identified

> *Each record represents a unique respondent.*

---

### 4.5 Distribution (Bias Assessment)

- **Average digital skill level:** 2.98
- **Low digital skill segment (levels 1–2):** 39.7%

**Result:**
- The dataset reflects a moderate-to-low digital proficiency population
- No evidence of sampling bias detected

> *The distribution supports the analytical objectives of the SimuBAQ project.*

---

## 5. Data Quality Issues Identified

Minor issues were identified in multi-response text fields, including:
- Inconsistent delimiters (commas and semicolons)
- Irregular spacing between values

These issues did **not** affect data integrity and were addressed during preprocessing.

---

## 6. Data Cleaning Actions Applied

A reproducible data cleaning pipeline was implemented using **Python (Pandas)**, including:
- Standardization of column names (snake_case)
- Removal of duplicate records
- Validation of numeric ranges
- Normalization of multi-response fields
- Conversion of date fields to proper date formats

The cleaned dataset was then loaded into PostgreSQL and modeled using a **star schema** to support scalable BI analysis.

---

## 7. Conclusion

Based on the evaluated quality dimensions, the dataset demonstrates a **high level of reliability and analytical readiness**. No critical data quality issues were identified that could compromise the validity of insights, KPIs, or dashboard results.

> *The dataset is considered suitable for Business Intelligence analysis, decision-making, and academic evaluation within the SimuBAQ project.*

---
