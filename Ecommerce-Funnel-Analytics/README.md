# 🛒 Ecommerce Funnel Dashboard — GA4 BigQuery → Looker Studio  

### 📊 *Data Analytics Project by Oleh Ustimov*  

---

## 💡 Project Overview  
This project analyzes the **E-commerce conversion funnel** using the **Google Analytics 4 public dataset (GA4)** in **BigQuery**.  
The goal was to build an **interactive dashboard** that helps marketing teams track how users move from the first session to a completed purchase.  

---

## 🎯 Objectives  
- Extract and transform GA4 data with SQL in **BigQuery**  
- Identify **key funnel steps** and conversion drop-offs  
- Build an interactive dashboard in **Looker Studio**  
- Analyze performance by traffic source, device, language, and landing page  

---

## ⚙️ Tech Stack  

| Tool | Purpose |
|------|----------|
| **BigQuery (SQL)** | Data extraction, cleaning, and transformation |
| **Looker Studio** | Dashboard and visualization |
| **GA4 Public Dataset** | Raw event data source |
| **Regex + CTE** | Parsing URLs, joining sessions, aggregating metrics |

---

## 🧱 SQL Pipeline  

Main query combines **event-level GA4 data** into a **session-level dataset** with funnel steps.  

```sql
WITH
  first_cte AS (
    SELECT
      REGEXP_EXTRACT(
        (SELECT value.string_value FROM UNNEST(event_params)
         WHERE key = 'page_location'),
        r'(?:\w+:\/\/)?[^\/]+\/([^\?#]*)'
      ) AS landing_page_location,
      user_pseudo_id
        || CAST((SELECT value.int_value FROM UNNEST(event_params)
                 WHERE key = 'ga_session_id') AS STRING) AS user_session_id,
      event_name,
      event_date,
      traffic_source.source AS traffic_source,
      traffic_source.medium AS medium,
      traffic_source.name AS campaign,
      device.category AS device_category,
      device.operating_system AS device_system,
      device.language AS device_language,
      geo.country AS country
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    WHERE event_name = 'session_start'
  ),
  second_cte AS (
    SELECT
      user_pseudo_id
        || CAST((SELECT value.int_value FROM UNNEST(event_params)
                 WHERE key = 'ga_session_id') AS STRING) AS user_session_id,
      event_name,
      TIMESTAMP_MICROS(event_timestamp) AS event_timestamp
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    WHERE event_name IN (
      'session_start', 'view_item', 'add_to_cart', 'begin_checkout',
      'add_shipping_info', 'add_payment_info', 'purchase'
    )
  )
SELECT
  f.event_date,
  f.traffic_source, f.medium, f.campaign,
  f.device_category, f.device_system, f.device_language, f.country,
  f.landing_page_location,
  s.event_name,
  s.event_timestamp,
  f.user_session_id
FROM first_cte f
LEFT JOIN second_cte s
  USING (user_session_id)
WHERE f.user_session_id IS NOT NULL;
```

---

## 📈 Key Metrics  

| Metric | Value |
|--------|--------|
| Rows processed | **867,735** |
| Unique sessions | **354,857** |
| Purchases | **4,745** |
| Conversion Rate | **1.34 %** |

---

## 📊 Dashboard Highlights  

- **Conversion Funnel (7 steps)** — from session start → purchase  
- **Traffic Analysis** — source, medium, campaign performance  
- **Device Breakdown** — desktop / mobile / tablet CR  
- **Landing Page Conversion** — which pages drive the most sales  
- **Date Filter & Interactive Segments** — fully customizable  

🖥️ **View Dashboard:** [Ecommerce Funnel Dashboard — Looker Studio](https://lookerstudio.google.com/reporting/61c9e420-9c4a-400f-a24d-ac8b500f0ad4)
📄 **View SQL Query:** [Public BigQuery Query](https://console.cloud.google.com/bigquery?sq=244262756080:220ed50d2e844d4fa129f36f2a5302fe&project=eminent-kit-189316&ws=!1m4!1m3!8m2!1s244262756080!2s220ed50d2e844d4fa129f36f2a5302fe)  

---

## 🧠 Insights  

- Organic and direct traffic drive most sessions  
- Returning users show a higher CR than new visitors  
- Desktop users generate higher average purchase rates than mobile  

---

## 🧩 Learnings  

- Efficient query design with multiple CTEs and joins  
- Handling event-level GA4 data and aggregating it into session metrics  
- Creating interactive dashboards for business decision-making  

---

## 👨‍💻 Author  

**Oleh Ustimov**  
📍 Prague, Czech Republic  
🔗 [LinkedIn](https://linkedin.com/in/oleh-ustimov-1b5b99159)  
🔗 [GitHub](https://github.com/olehbiceps)

---
