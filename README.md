# 🚀 SimuBAQ – Digital Inclusion Simulator (BI Project)

## 📌 Project Overview
**SimuBAQ** is a digital inclusion project aimed at improving basic digital skills among adults and older adults through the use of **interactive simulators**, with a primary focus on **banking applications**. The project combines **data-driven analysis**, **Business Intelligence (BI)**, and **user-centered design** to identify learning needs and support decision-making for educational interventions.

This repository documents the **end-to-end analytical process**, including data collection, data quality assessment, data modeling, and dashboard development using **PostgreSQL** and **Power BI**.

---

## 🎯 Project Objectives

### General Objective
To analyze digital skill levels and application learning needs among adults and older adults in order to design a simulator-based solution that supports digital inclusion.

### Specific Objectives
- Assess digital skill levels within the target population
- Identify the most demanded applications for learning
- Detect gaps between desired and used applications
- Evaluate interest in face-to-face and hybrid learning models
- Support decision-making through BI dashboards and KPIs

---

## 📊 Dataset Description
- **Source:** Simulated survey (Google Forms)
- **Records:** 1,000 respondents
- **Target population:** Adults and older adults
- **Data type:** Structured, multi-response survey data
- **Languages:** Spanish (translated and standardized for analysis)

---

## 🧪 Data Quality Assessment
Before analysis, a **Data Quality Report** was conducted evaluating the following dimensions:
- Completeness
- Validity
- Consistency
- Uniqueness
- Distribution

### Key Findings
- 100% completeness in critical fields
- Valid numeric ranges for digital skill levels (1–5)
- No duplicate records detected
- Balanced distribution across skill levels

> The dataset was deemed **reliable and ready for BI analysis**.

---

## 🧹 Data Cleaning & Preprocessing
A reproducible data cleaning pipeline was implemented using **Python (Pandas)** in a Jupyter Notebook. Key steps included:
- Standardization of column names
- Cleaning of multi-response fields
- Validation of numeric ranges
- Date formatting and parsing
- Removal of duplicate records

The cleaned dataset was then loaded into PostgreSQL for further processing.

---

## 🗄️ Data Modeling
The data was modeled using a **Star Schema**, optimized for BI analysis.

### Model Components
- **Fact table:** `fact_survey` (one record per respondent)
- **Dimension tables:**
  - `dim_date`
  - `dim_age_range`
  - `dim_gender`
  - `dim_city`
  - `dim_education_level`
  - `dim_app`
  - `dim_day`
  - `dim_time_slot`
- **Bridge tables (factless facts):**
  - `bridge_desired_apps`
  - `bridge_used_apps`
  - `bridge_available_days`
  - `bridge_available_time_slots`
  - `bridge_difficulties`
  - `bridge_primary_uses`
  - `bridge_limitations`

This structure enables flexible analysis of multi-select survey responses.

---

## 📈 Key KPIs

- **Total surveys:** 1,000
- **Average digital skill level:** 2.98 / 5
- **Low digital skill segment (levels 1–2):** 39.7%
- **Interest in face-to-face classes:** 33.7%

These KPIs confirm the existence of a significant digital skills gap and validate the need for simulator-based learning solutions.

---

## 🧠 Key Insights
- A structural digital divide exists among the target population
- Digital skill gaps are widespread, not limited to a single subgroup
- Banking applications emerge as a critical learning need for low-skill users
- Face-to-face support remains essential, supporting a hybrid learning model

---

## 📊 Dashboard Development (Power BI)
Power BI was connected directly to the PostgreSQL database to build interactive dashboards.

### Dashboard Features
- KPI cards (surveys, skill levels, interest rates)
- Application demand rankings
- Desired vs used application gap analysis
- Availability by day and time slot
- Segmentation by age, city, and skill level

The dashboards support data-driven decisions for simulator design and pilot planning.

---

## 🎯 Recommendations
- Focus simulator design on users with low digital skill levels (1–2)
- Prioritize banking applications due to their enabling role
- Implement a hybrid learning model combining simulators and guided classes
- Define impact KPIs to measure skill improvement and user confidence

---

## 🧩 Technologies Used
- **Python:** Pandas, Jupyter Notebook
- **Database:** PostgreSQL (DBeaver)
- **BI Tool:** Power BI
- **Modeling:** Star Schema, Bridge Tables
- **Data Source:** Google Forms (simulated)

---

## 🔮 Next Steps
- Pilot implementation of the SimuBAQ simulator
- Measurement of post-training impact KPIs
- Expansion to additional application domains (health, government services)
- Continuous data quality monitoring

---

📌 *This project demonstrates an end-to-end BI workflow, from data quality assessment to actionable insights, supporting digital in
