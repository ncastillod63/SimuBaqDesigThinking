-- ===========================
-- SimuBAQ - STAR SCHEMA RUN ALL
-- PostgreSQL (DBeaver)
-- ===========================

BEGIN;

-- 0) Schema
CREATE SCHEMA IF NOT EXISTS simu;
SET search_path TO simu;

-- -------------------------------------------------
-- 1) DROP tables (en orden para no romper FKs)
-- -------------------------------------------------
DROP TABLE IF EXISTS bridge_limitations;
DROP TABLE IF EXISTS bridge_primary_uses;
DROP TABLE IF EXISTS bridge_difficulties;
DROP TABLE IF EXISTS bridge_available_time_slots;
DROP TABLE IF EXISTS bridge_available_days;
DROP TABLE IF EXISTS bridge_used_apps;
DROP TABLE IF EXISTS bridge_desired_apps;

DROP TABLE IF EXISTS dim_app;
DROP TABLE IF EXISTS dim_time_slot;
DROP TABLE IF EXISTS dim_day;
DROP TABLE IF EXISTS dim_education_level;
DROP TABLE IF EXISTS dim_city;
DROP TABLE IF EXISTS dim_gender;
DROP TABLE IF EXISTS dim_age_range;
DROP TABLE IF EXISTS dim_date;

DROP TABLE IF EXISTS fact_survey;
DROP TABLE IF EXISTS staging_survey;

-- -------------------------------------------------
-- 2) STAGING (igual al CSV limpio, en inglés)
--    (Aquí se importa el CSV)
-- -------------------------------------------------
CREATE TABLE staging_survey (
  survey_id INT,
  response_date DATE,
  age_range TEXT,
  gender TEXT,
  city TEXT,
  education_level TEXT,
  phone_type TEXT,
  primary_device TEXT,
  internet_access TEXT,
  phone_skill_level INT,
  app_comfort_level TEXT,
  app_usage_frequency TEXT,

  used_apps TEXT,               -- multi: "WhatsApp,Banking Apps,..."
  primary_phone_uses TEXT,      -- multi
  difficulties TEXT,            -- multi
  digital_fears TEXT,

  interest_in_classes TEXT,
  interest_in_simulators TEXT,

  desired_apps TEXT,            -- multi
  priority_app TEXT,

  available_days TEXT,          -- multi
  available_time_slots TEXT,    -- multi

  weekly_availability TEXT,
  preferred_class_duration TEXT,
  travel_time TEXT,
  preferred_class_location TEXT,
  preferred_class_type TEXT,

  limitations TEXT,             -- multi
  willingness_to_pay TEXT,
  ideal_provider TEXT,
  contact_interest TEXT
);

-- --------------------------------------------
-- 2) CARGA CSV 
-- IMPORTAR MANUALMENTE


-- -------------------------------------------------
-- 3) FACT TABLE (1 fila por encuestado)
-- -------------------------------------------------
CREATE TABLE fact_survey (
  survey_id INT PRIMARY KEY,

  response_date DATE,
  age_range VARCHAR(20),
  gender VARCHAR(30),
  city VARCHAR(120),
  education_level VARCHAR(60),

  phone_type VARCHAR(50),
  primary_device VARCHAR(50),
  internet_access VARCHAR(50),

  phone_skill_level INT,
  app_comfort_level VARCHAR(40),
  app_usage_frequency VARCHAR(40),

  digital_fears VARCHAR(80),
  interest_in_classes VARCHAR(20),
  interest_in_simulators VARCHAR(40),

  priority_app VARCHAR(80),

  weekly_availability VARCHAR(40),
  preferred_class_duration VARCHAR(40),
  travel_time VARCHAR(40),
  preferred_class_location VARCHAR(60),
  preferred_class_type VARCHAR(40),

  willingness_to_pay VARCHAR(40),
  ideal_provider VARCHAR(60),
  contact_interest VARCHAR(10)
);

-- Poblar fact desde staging
INSERT INTO fact_survey (
  survey_id, response_date, age_range, gender, city, education_level,
  phone_type, primary_device, internet_access,
  phone_skill_level, app_comfort_level, app_usage_frequency,
  digital_fears, interest_in_classes, interest_in_simulators,
  priority_app,
  weekly_availability, preferred_class_duration, travel_time,
  preferred_class_location, preferred_class_type,
  willingness_to_pay, ideal_provider, contact_interest
)
SELECT
  survey_id, response_date, age_range, gender, city, education_level,
  phone_type, primary_device, internet_access,
  phone_skill_level, app_comfort_level, app_usage_frequency,
  digital_fears, interest_in_classes, interest_in_simulators,
  priority_app,
  weekly_availability, preferred_class_duration, travel_time,
  preferred_class_location, preferred_class_type,
  willingness_to_pay, ideal_provider, contact_interest
FROM staging_survey
WHERE survey_id IS NOT NULL;

-- -------------------------------------------------
-- 4) BRIDGE TABLES (factless facts / multi-respuesta)
-- -------------------------------------------------
CREATE TABLE bridge_desired_apps (
  id SERIAL PRIMARY KEY,
  survey_id INT REFERENCES fact_survey(survey_id),
  app_name VARCHAR(80)
);

CREATE TABLE bridge_used_apps (
  id SERIAL PRIMARY KEY,
  survey_id INT REFERENCES fact_survey(survey_id),
  app_name VARCHAR(80)
);

CREATE TABLE bridge_available_days (
  id SERIAL PRIMARY KEY,
  survey_id INT REFERENCES fact_survey(survey_id),
  day_name VARCHAR(20)
);

CREATE TABLE bridge_available_time_slots (
  id SERIAL PRIMARY KEY,
  survey_id INT REFERENCES fact_survey(survey_id),
  time_slot VARCHAR(20)
);

CREATE TABLE bridge_difficulties (
  id SERIAL PRIMARY KEY,
  survey_id INT REFERENCES fact_survey(survey_id),
  difficulty VARCHAR(120)
);

CREATE TABLE bridge_primary_uses (
  id SERIAL PRIMARY KEY,
  survey_id INT REFERENCES fact_survey(survey_id),
  primary_use VARCHAR(60)
);

CREATE TABLE bridge_limitations (
  id SERIAL PRIMARY KEY,
  survey_id INT REFERENCES fact_survey(survey_id),
  limitation VARCHAR(120)
);

-- Poblar bridges desde staging 

INSERT INTO bridge_desired_apps (survey_id, app_name)
SELECT s.survey_id, NULLIF(TRIM(x), '')
FROM staging_survey s,
     unnest(string_to_array(coalesce(s.desired_apps,''), ',')) AS x
WHERE NULLIF(TRIM(x), '') IS NOT NULL;

INSERT INTO bridge_used_apps (survey_id, app_name)
SELECT s.survey_id, NULLIF(TRIM(x), '')
FROM staging_survey s,
     unnest(string_to_array(coalesce(s.used_apps,''), ',')) AS x
WHERE NULLIF(TRIM(x), '') IS NOT NULL;

INSERT INTO bridge_available_days (survey_id, day_name)
SELECT s.survey_id, NULLIF(TRIM(x), '')
FROM staging_survey s,
     unnest(string_to_array(coalesce(s.available_days,''), ',')) AS x
WHERE NULLIF(TRIM(x), '') IS NOT NULL;

INSERT INTO bridge_available_time_slots (survey_id, time_slot)
SELECT s.survey_id, NULLIF(TRIM(x), '')
FROM staging_survey s,
     unnest(string_to_array(coalesce(s.available_time_slots,''), ',')) AS x
WHERE NULLIF(TRIM(x), '') IS NOT NULL;

INSERT INTO bridge_difficulties (survey_id, difficulty)
SELECT s.survey_id, NULLIF(TRIM(x), '')
FROM staging_survey s,
     unnest(string_to_array(coalesce(s.difficulties,''), ',')) AS x
WHERE NULLIF(TRIM(x), '') IS NOT NULL;

INSERT INTO bridge_primary_uses (survey_id, primary_use)
SELECT s.survey_id, NULLIF(TRIM(x), '')
FROM staging_survey s,
     unnest(string_to_array(coalesce(s.primary_phone_uses,''), ',')) AS x
WHERE NULLIF(TRIM(x), '') IS NOT NULL;

INSERT INTO bridge_limitations (survey_id, limitation)
SELECT s.survey_id, NULLIF(TRIM(x), '')
FROM staging_survey s,
     unnest(string_to_array(coalesce(s.limitations,''), ',')) AS x
WHERE NULLIF(TRIM(x), '') IS NOT NULL;

-- -------------------------------------------------
-- 5) DIMENSIONS 
-- -------------------------------------------------
CREATE TABLE dim_date AS
SELECT DISTINCT
  to_char(response_date, 'YYYYMMDD')::INT AS date_key,
  response_date AS full_date,
  extract(year from response_date)::INT AS year,
  extract(month from response_date)::INT AS month,
  trim(to_char(response_date, 'Month')) AS month_name,
  extract(quarter from response_date)::INT AS quarter,
  extract(day from response_date)::INT AS day,
  trim(to_char(response_date, 'Day')) AS day_name
FROM fact_survey
WHERE response_date IS NOT NULL;

ALTER TABLE dim_date ADD PRIMARY KEY (date_key);

CREATE TABLE dim_age_range AS
SELECT DISTINCT age_range
FROM fact_survey
WHERE age_range IS NOT NULL;

CREATE TABLE dim_gender AS
SELECT DISTINCT gender
FROM fact_survey
WHERE gender IS NOT NULL;

CREATE TABLE dim_city AS
SELECT DISTINCT city
FROM fact_survey
WHERE city IS NOT NULL;

CREATE TABLE dim_education_level AS
SELECT DISTINCT education_level
FROM fact_survey
WHERE education_level IS NOT NULL;

CREATE TABLE dim_day AS
SELECT DISTINCT day_name
FROM bridge_available_days
WHERE day_name IS NOT NULL;

CREATE TABLE dim_time_slot AS
SELECT DISTINCT time_slot
FROM bridge_available_time_slots
WHERE time_slot IS NOT NULL;

CREATE TABLE dim_app AS
SELECT DISTINCT app_name
FROM (
  SELECT app_name FROM bridge_desired_apps
  UNION
  SELECT app_name FROM bridge_used_apps
) t
WHERE app_name IS NOT NULL;

