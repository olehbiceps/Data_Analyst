
WITH all_ads AS (
    SELECT 
        fd.ad_date, 
        fa.adset_name,
        'Facebook' AS source,
        COALESCE(fd.spend, 0) AS daily_spend
    FROM facebook_ads_basic_daily fd 
    LEFT JOIN facebook_adset fa ON fd.adset_id = fa.adset_id
    LEFT JOIN facebook_campaign fc ON fd.campaign_id = fc.campaign_id

    UNION ALL 

    SELECT 
        gd.ad_date, 
        gd.campaign_name AS adset_name, 
        'Google' AS source,
        COALESCE(gd.spend, 0) AS daily_spend
    FROM google_ads_basic_daily gd
)

SELECT 
    source, 
    ad_date,
    ROUND(AVG(daily_spend), 2) AS avg_spend,
    ROUND(MAX(daily_spend), 2) AS max_spend,
    ROUND(MIN(daily_spend), 2) AS min_spend
FROM all_ads
GROUP BY source, ad_date


--Відобрази агрегуючі показники (середнє, максимум та мінімум) для щоденних витрат по Google та Facebook окремо.

