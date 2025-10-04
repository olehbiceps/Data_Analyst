# GA4 Conversion & Funnel Analysis — BigQuery Project

**Author:** Oleh Ustimov  
**Repository:** [olehbiceps/Portfolio](https://github.com/olehbiceps/Portfolio)  
**Query link:** [View in Google BigQuery Console](https://console.cloud.google.com/bigquery?sq=244262756080:635fdfa62245499897bfadf0d45b4529)

---

## 📊 Overview

This project analyzes **Google Analytics 4 (GA4)** e-commerce data stored in **BigQuery**.  
The goal is to explore user behavior, session-level funnels, and conversion efficiency across campaigns, sources, and landing pages.

The analysis focuses on three main SQL scripts (parts **2**, **3**, and **4**) that demonstrate:
- Event extraction and data normalization  
- Session-level funnel aggregation  
- Landing page conversion analysis  

---

## 📁 Structure

| File | Description |
|------|--------------|
| `Ga4.sql` | Main SQL file with all queries (Parts 2–4). |
| `README.md` | Documentation (this file). |
| `Facebook Ads Campaigns — Data Analysis & ...` | Folder for additional marketing datasets and visuals. |

---

## 🧮 Query Breakdown

### 🔹 Part 2 — Event Extraction (Base Dataset)
Extracts events for 2021 from the GA4 public sample dataset:
- Converts microsecond timestamps into readable format  
- Extracts `user_pseudo_id`, `ga_session_id` from `event_params`  
- Includes traffic source fields (`campaign`, `source`, `medium`)  
- Filters relevant event types:  
  `session_start`, `view_item`, `add_to_cart`, `begin_checkout`, `purchase`, etc.

👉 Result: clean table of user events with traffic context and session linkage.

---

### 🔹 Part 3 — Daily Funnel by UTM Parameters
Builds a session-level funnel with daily aggregation:
1. `main_dat`: normalizes events and creates unique `user_session_id`
2. `aggregated_dat`: counts distinct sessions where events occurred
3. Calculates conversion rates:
   - Visit → Add to Cart  
   - Visit → Begin Checkout  
   - Visit → Purchase

**Output example:**
| date | campaign | source | medium | sessions | visit_to_cart | visit_to_checkout | visit_to_purchase |
|------|-----------|---------|---------|-----------|----------------|------------------|------------------|
| 2021-05-01 | spring_sale | google | cpc | 1250 | 15.2 | 7.9 | 3.4 |

---

### 🔹 Part 4 — Landing Page Conversion
Evaluates conversion rate by **landing page**:
- Extracts `page_location` → simplified `page_path`
- Identifies sessions that resulted in a `purchase`
- Calculates conversion = `purchase_sessions / total_sessions`

**Output example:**
| page_path | unique_sessions | purchase_sessions | conversion_rate (%) |
|------------|----------------|-------------------|---------------------|
| shop/home | 800 | 52 | 6.5 |
| campaign/summer-offer | 250 | 30 | 12.0 |

---

## 🚀 How to Run

1. Open the query directly in BigQuery:  
   👉 [Run in Console](https://console.cloud.google.com/bigquery?sq=244262756080:635fdfa62245499897bfadf0d45b4529)
2. Adjust dataset path if using your own data:  
