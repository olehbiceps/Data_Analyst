
---2----
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT 
TIMESTAMP_MICROS(event_timestamp) as event_timestamp,
user_pseudo_id,
(select value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id' ) as session_id,
traffic_source.name as event_name,
geo.country as country,
device.category as device_category,
traffic_source.name as campaign,
traffic_source.source as source,
traffic_source.medium as medium,
--(SELECT value.string_value
 --  FROM UNNEST(event_params)
  -- WHERE key = 'campaign') AS campaign,

FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20210101'and '20211231'
  AND event_name IN (
    'session_start', 'view_item', 'add_to_cart', 'purchase', 'add_shipping_info', 'add_payment_info', 'begin_checkout'
  )


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---3----

WITH main_dat AS (
  SELECT 
    DATE(TIMESTAMP_MICROS(event_timestamp)) AS event_date,
    traffic_source.source AS source,
    traffic_source.medium AS medium,
    traffic_source.name AS campaign,
    CONCAT(
      user_pseudo_id,
      CAST((SELECT ep.value.int_value 
            FROM UNNEST(event_params) AS ep 
            WHERE ep.key = 'ga_session_id') AS STRING)
    ) AS user_session_id,
    event_name
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
),

aggregated_dat AS (
  SELECT 
    event_date,
    campaign,
    source, 
    medium,
    COUNT(DISTINCT CASE WHEN event_name = 'session_start' THEN user_session_id END) AS user_sessions_count,
    COUNT(DISTINCT CASE WHEN event_name = 'add_to_cart' THEN user_session_id END) AS add_to_cart_count,
    COUNT(DISTINCT CASE WHEN event_name = 'begin_checkout' THEN user_session_id END) AS begin_checkout_count,
    COUNT(DISTINCT CASE WHEN event_name = 'purchase' THEN user_session_id END) AS purchase_count
  FROM main_dat
  GROUP BY 
    event_date,
    campaign,
    source, 
    medium
)

SELECT   
  event_date,
  campaign,
  source, 
  medium,
  user_sessions_count,
ROUND(SAFE_DIVIDE(add_to_cart_count, user_sessions_count) * 100, 2) AS visit_to_cart,
ROUND(SAFE_DIVIDE(begin_checkout_count, user_sessions_count) * 100, 2) AS visit_to_checkout,
ROUND(SAFE_DIVIDE(purchase_count, user_sessions_count) * 100, 2) AS visit_to_purchase

FROM aggregated_dat
ORDER BY event_date


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---4----



WITH sessions AS (
  SELECT
    CONCAT(user_pseudo_id, CAST((
      SELECT ep.value.int_value
      FROM UNNEST(event_params) ep
      WHERE ep.key = 'ga_session_id'
    ) AS STRING)) AS user_session_id,

    REGEXP_EXTRACT((
      SELECT ep.value.string_value
      FROM UNNEST(event_params) ep
      WHERE ep.key = 'page_location'
    ), r"https?://[^/]+/([^?]*)") AS page_path
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX LIKE '2020%'
    AND event_name = 'session_start'
    AND (SELECT ep.value.string_value
         FROM UNNEST(event_params) ep
         WHERE ep.key = 'page_location') IS NOT NULL
),


purchases AS (
  SELECT DISTINCT
    CONCAT(user_pseudo_id, CAST((
      SELECT ep.value.int_value
      FROM UNNEST(event_params) ep
      WHERE ep.key = 'ga_session_id'
    ) AS STRING)) AS user_session_id
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX LIKE '2020%'
    AND event_name = 'purchase'
)


SELECT
  s.page_path,
  COUNT(DISTINCT s.user_session_id) AS unique_sessions,
  COUNT(DISTINCT p.user_session_id) AS purchase_sessions,
  ROUND(SAFE_DIVIDE(COUNT(DISTINCT p.user_session_id), COUNT(DISTINCT s.user_session_id)) * 100, 2) AS conversion_rate
FROM sessions s
LEFT JOIN purchases p
  ON s.user_session_id = p.user_session_id
GROUP BY s.page_path
ORDER BY conversion_rate DESC



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------