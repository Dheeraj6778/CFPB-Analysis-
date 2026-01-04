
with cte_base as (
    select distinct trim(company) as company
    from {{ source('silver', 'complaints_silver') }}
),
stats as (
    select
        trim(company) as company,
        min(date_received) as first_complaint_date,
        max(date_received) as last_complaint_date
    from {{ source('silver', 'complaints_silver') }}
    group by 1
)
select
    md5(c.company) as company_key,
    c.company,
    s.first_complaint_date,
    s.last_complaint_date
from cte_base as c
left join stats as s
on c.company = s.company
where c.company<>'' and c.company is not null

