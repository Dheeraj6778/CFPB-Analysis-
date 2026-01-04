
select date_received, company, product, coalesce(state,'UNKNOWN') as state,
    count(complaint_id) as complaint_cnt, 
    sum(case when timely = 'Yes' then 1 else 0 end) as timely_cnt,
    sum(case when timely = 'Yes' then 1 else 0 end)/count(complaint_id)::float as timely_response_rate,
    sum(case when submitted_via = 'Web' then 1 else 0 end) as web_submissions_cnt,
    sum(case when submitted_via='Phone' then 1 else 0 end) as phone_submissions_cnt,
    sum(case when submitted_via='Postal mail' then 1 else 0 end) as postal_submissions_cnt,
    sum(case when submitted_via='Referral' then 1 else 0 end) as referral_submissions_cnt
from {{ source('silver', 'complaints_silver') }}
group by date_received, company, product, state
