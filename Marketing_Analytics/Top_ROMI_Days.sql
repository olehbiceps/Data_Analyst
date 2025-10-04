WITH combined_spend AS (
    SELECT 
        ad_date,
        'Facebook' AS source,
        COALESCE(spend, 0) AS daily_spend
    FROM facebook_ads_basic_daily

    UNION ALL

    SELECT 
        ad_date,
        'Google' AS source,
        COALESCE(spend, 0) AS daily_spend
    FROM google_ads_basic_daily
)

SELECT 
    source,
    ROUND(AVG(daily_spend), 2) AS avg_spend,
    ROUND(MAX(daily_spend), 2) AS max_spend,
    ROUND(MIN(daily_spend), 2) AS min_spend
FROM combined_spend
GROUP BY source;



with cte as (
    select 
        ad_date, 

        coalesce(spend, 0) as spend,
   
        coalesce(value, 0) as value
        
    from facebook_ads_basic_daily
    union all 
    select 
        ad_date, 

        coalesce(spend, 0) as spend,

        coalesce(value, 0) as value
        
    from google_ads_basic_daily
)

select 
ad_date,

ROUND((SUM(value)::numeric - SUM(spend)) / nullif (SUM(spend), 0) ,4)  as Romi
  
from cte 
group by ad_date
having sum(spend) > 0 
order by Romi desc 
limit 5


--Знайди топ-5 днів за рівнем ROMI загалом (включаючи Google та Facebook), виведи дати та відповідні значення в порядку спадання.




