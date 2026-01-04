select *
from {{ ref('gold_complaints_daily') }}
where (coalesce(web_submissions_cnt,0)+
       coalesce(phone_submissions_cnt,0)+
       coalesce(postal_submissions_cnt,0)+
       coalesce(referral_submissions_cnt,0)) > complaint_cnt