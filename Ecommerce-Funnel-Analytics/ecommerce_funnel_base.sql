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

      (SELECT value.int_value FROM UNNEST(event_params)
       WHERE key = 'ga_session_id') AS session_id,

      event_name,
      event_date,

      traffic_source.source AS traffic_source,
      traffic_source.medium AS medium,
      traffic_source.name AS campaign,

      device.category AS device_category,
      device.operating_system AS device_system,
      device.language AS device_language,
      geo.country AS country
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` AS ev
    WHERE event_name = 'session_start'
  ),

  second_cte AS (
    SELECT
      user_pseudo_id
        || CAST((SELECT value.int_value FROM UNNEST(event_params)
                 WHERE key = 'ga_session_id') AS STRING) AS user_session_id,
      TIMESTAMP_MICROS(event_timestamp) AS event_timestamp,
      event_name
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` AS ev
    WHERE event_name IN (
      'session_start',
      'view_item',
      'add_to_cart',
      'begin_checkout',
      'add_shipping_info',
      'add_payment_info',
      'purchase'
    )
  )

SELECT
  f.event_date,
  f.landing_page_location,
  f.traffic_source,
  f.medium,
  f.campaign,
  f.device_category,
  f.device_system,
  f.device_language,
  f.country,
  s.event_name,
  s.event_timestamp,
  f.user_session_id
FROM first_cte AS f
LEFT JOIN second_cte AS s
  ON f.user_session_id = s.user_session_id
WHERE f.user_session_id IS NOT NULL;
