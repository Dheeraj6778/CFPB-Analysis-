select *
from {{ ref('gold_baselines_daily') }}
where pct_change_vs_7d_avg < -1 or pct_change_vs_28d_avg < -1