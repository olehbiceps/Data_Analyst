with cleaned_data as (
  select distinct 
    DATE(ad_date) as ad_date, 
    adset_name
  from (
    select 
      ad_date, 
      adset_name
    from facebook_ads_basic_daily fd 
    left join facebook_adset fa on fd.adset_id = fa.adset_id
    left join facebook_campaign fc on fa.adset_id = fc.campaign_id

    union all 

    select 
      ad_date, 
      adset_name
    from google_ads_basic_daily
  ) all_ads
),

numbered_dates as (
  select
    adset_name,
    ad_date,
    ad_date - (row_number() over (partition by adset_name order by ad_date) * interval '1 day') as grp
  from cleaned_data
)

select
  adset_name,
  min(ad_date) as start_date,
  max(ad_date) as end_date,
  count(*) as streak_length
from numbered_dates
group by adset_name, grp
order by streak_length desc
limit 1;



--* Напиши запит, який поверне назву та тривалість найдовшого безперервного (щоденного) показу adset_name (разом з Google та Facebook)











