
{% set cols = ["date_received","company","product","state","complaint_cnt","timely_response_rate","web_submissions_cnt","phone_submissions_cnt","avg_28d_complaint_cnt","sd_28d_complaint_cnt","pct_change_vs_28d_avg","z_score_vs_28d"] %}

with cte_base as (
    select {% for col in cols %}
                {{ col }}{% if not loop.last %}, {% endif %}
            {% endfor %}
           
    from {{ ref('gold_baselines_daily') }}
),
cte_alert as (
    select *, 
        case when complaint_cnt>=10 and (z_score_vs_28d>=3 or pct_change_vs_28d_avg>=1.5) then 1 else 0 end as spike_alert,
        case when z_score_vs_28d>=4 or pct_change_vs_28d_avg>=2.5 then "HIGH"
            when z_score_vs_28d>=3 or pct_change_vs_28d_avg>=1.5 then "MEDIUM"
            else "LOW" end as spike_alert_severity,
        case when z_score_vs_28d>=4 and pct_change_vs_28d_avg>=2.5 then "Both Z-Score and Pct Change"
            when z_score_vs_28d>=4 then "Z-Score"
            when pct_change_vs_28d_avg>=2.5 then "Pct Change"
            when z_score_vs_28d>=3 and pct_change_vs_28d_avg>=1.5 then "Both Z-Score and Pct Change"
            when z_score_vs_28d>=3 then "Z-Score"
            when pct_change_vs_28d_avg>=1.5 then "Pct Change"
            else "None" end as spike_alert_reason

    from cte_base
)
select {% for col in cols %}
                {{ col }}{% if not loop.last %}, {% endif %}
            {% endfor %},
            spike_alert_severity,
            spike_alert_reason
from cte_alert
where spike_alert=1


