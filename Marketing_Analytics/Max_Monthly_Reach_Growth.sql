
WITH combined_data AS (
  SELECT 
    fd.ad_date::date AS ad_date,
    fc.campaign_name,
    COALESCE(fd.reach, 0) AS reach
  FROM facebook_ads_basic_daily fd
  LEFT JOIN facebook_campaign fc ON fd.campaign_id = fc.campaign_id

  UNION ALL

  SELECT 
    gd.ad_date::date AS ad_date,
    gd.campaign_name,
    COALESCE(gd.reach, 0) AS reach
  FROM google_ads_basic_daily gd
),

monthly_agg AS (
  SELECT 
    DATE_TRUNC('month', ad_date)::date AS month,
    campaign_name,
    SUM(reach) AS total_reach
  FROM combined_data
  WHERE campaign_name IS NOT NULL
  GROUP BY DATE_TRUNC('month', ad_date), campaign_name
),

reach_growth AS (
  SELECT 
    campaign_name,
    month,
    total_reach,
    total_reach - LAG(total_reach) OVER (
      PARTITION BY campaign_name ORDER BY month
    ) AS growth
  FROM monthly_agg
)

SELECT 
  campaign_name,
  month,
  growth
FROM reach_growth
WHERE growth IS NOT NULL
ORDER BY growth DESC
LIMIT 1;



--Знайди кампанію, що мала найбільший приріст у охопленні місяць-до місяця.

