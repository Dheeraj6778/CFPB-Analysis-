{{ config(severity='warn') }}

select *
from {{ ref('gold_baselines_daily') }}
where abs(z_score_vs_7d)>=4 or abs(z_score_vs_28d)>=4