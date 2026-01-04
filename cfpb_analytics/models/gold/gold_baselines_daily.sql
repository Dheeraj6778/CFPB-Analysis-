
with cte_base as (
    select date_received,
           company,
           product,
           state,
           complaint_cnt,
              timely_cnt,
                timely_response_rate,
                web_submissions_cnt,
                phone_submissions_cnt
    from {{ ref('gold_complaints_daily') }}
),
cte_agg as (
    select *,
           avg(complaint_cnt) over(
                order by date_received
                rows between 6 preceding and current row
           ) as avg_7d_complaint_cnt,
            avg(complaint_cnt) over(
                order by date_received
                rows between 27 preceding and current row
            ) as avg_28d_complaint_cnt,
            stddev(complaint_cnt) over(
                order by date_received
                rows between 6 preceding and current row
            ) as sd_7d_complaint_cnt,
            stddev(complaint_cnt) over(
                order by date_received
                rows between 27 preceding and current row
            ) as sd_28d_complaint_cnt,
            avg(timely_response_rate) over(
                order by date_received
                rows between 6 preceding and current row
            ) as avg_7d_timely_response_rate,
            avg(timely_response_rate) over(
                order by date_received
                rows between 27 preceding and current row
            ) as avg_28d_timely_response_rate

    from cte_base
),
cte_final_metrics as (
    select date_received,
           company,
           product,
           state,
           complaint_cnt,
              timely_cnt,
                timely_response_rate,
                web_submissions_cnt,
                phone_submissions_cnt,
           round(avg_7d_complaint_cnt, 2)  as avg_7d_complaint_cnt,
           round(avg_28d_complaint_cnt, 2) as avg_28d_complaint_cnt,
           round(sd_7d_complaint_cnt, 2)   as sd_7d_complaint_cnt,
           round(sd_28d_complaint_cnt, 2)  as sd_28d_complaint_cnt,
           round(avg_7d_timely_response_rate, 2)  as avg_7d_timely_response_rate,
           round(avg_28d_timely_response_rate, 2) as avg_28d_timely_response_rate,
           round(
             case when avg_7d_complaint_cnt = 0 then null
                  else (complaint_cnt - avg_7d_complaint_cnt)/avg_7d_complaint_cnt
             end, 2
           ) as pct_change_vs_7d_avg,
           round(
             case when avg_28d_complaint_cnt = 0 then null
                  else (complaint_cnt - avg_28d_complaint_cnt)/avg_28d_complaint_cnt
             end, 2
           ) as pct_change_vs_28d_avg,
           round(
                case when sd_7d_complaint_cnt = 0 then null
                     else (complaint_cnt - avg_7d_complaint_cnt)/sd_7d_complaint_cnt
                end, 2
           ) as z_score_vs_7d,
            round(
                case when sd_28d_complaint_cnt = 0 then null
                    else (complaint_cnt - avg_28d_complaint_cnt)/sd_28d_complaint_cnt
                end, 2
            ) as z_score_vs_28d
    from cte_agg
)
select *
from cte_final_metrics
