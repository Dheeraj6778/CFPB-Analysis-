{% set cols = ["date_received","issue","company","product","state"] %}
{% set join_cols = ["date_received","company","product","state"] %}

with cte_base as (
    select
        {% for col in cols %}
            {{ col }}{% if not loop.last %},{% endif %}
        {% endfor %},
        count(*) as issue_cnt
    from {{ source('silver', 'complaints_silver') }}
    group by
        {% for col in cols %}
            {{ col }}{% if not loop.last %},{% endif %}
        {% endfor %}
),
cte_narrative_cnt as (
    select
        {% for col in join_cols %}
            {{ col }}{% if not loop.last %},{% endif %}
        {% endfor %},
        count(case when complaint_what_happened is not null then 1 end) as total_narratives_cnt
    from {{ source('silver', 'complaints_silver') }}
    group by
        {% for col in join_cols %}
            {{ col }}{% if not loop.last %},{% endif %}
        {% endfor %}
)
select
    {% for col in cols %}
        b.{{ col }}{% if not loop.last %},{% endif %}
    {% endfor %},
    b.issue_cnt,
    n.total_narratives_cnt,
    case when n.total_narratives_cnt > 0 then
        round( (cast(b.issue_cnt as double) / cast(n.total_narratives_cnt as double)) * 100, 2)
    else 0 end as topic_share, 
    case
        when lower(b.issue) rlike 'fraud|false|scam|unauthorized|identity theft' then 'FRAUD_UNAUTHORIZED'
        when lower(b.issue) rlike 'credit report|incorrect|wrong information' then 'CREDIT_REPORTING_ERROR'
        when lower(b.issue) rlike 'fee|interest|apr|charge' then 'FEES_INTEREST'
        when lower(b.issue) rlike 'investigation|delay|30 days' then 'INVESTIGATION_DELAY'
        when lower(b.issue) rlike 'payment|processing|autopay' then 'PAYMENT_PROCESSING'
        when lower(b.issue) rlike 'collection|threatened|threaten|harass|debt' then 'COLLECTIONS_HARASSMENT'
        else 'OTHER'
    end as topic_category
from cte_base b
left join cte_narrative_cnt n
    on {% for col in join_cols %}
        b.{{ col }} = n.{{ col }}{% if not loop.last %} and {% endif %}
    {% endfor %}