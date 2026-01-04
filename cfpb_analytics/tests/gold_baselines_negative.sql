
select *
from {{ ref('gold_baselines_daily') }}
where avg_7d_complaint_cnt<0 or avg_28d_complaint_cnt<0 or sd_7d_complaint_cnt<0 or sd_28d_complaint_cnt<0