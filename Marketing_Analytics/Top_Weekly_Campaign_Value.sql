
with new_table as 
(select 
ad_date,
campaign_name,
spend,
coalesce(value, 0) as value
from 
facebook_ads_basic_daily fd 
left join facebook_campaign fc
on fd.campaign_id = fc.campaign_id
union all 
select ad_date,
campaign_name,
spend,
coalesce(value, 0) as value
from
google_ads_basic_daily
)
select campaign_name, sum(value) as total_value,
to_char(ad_date, 'IYYY-IW') as week
  
from new_table
where campaign_name is not null
group by week, campaign_name
order by total_value desc
limit 1

--Відобрази компанію з найвищим рівнем загального тижневого value (не забудь вказати тиждень та значення рекорду).





