with bounds as (
    select 
        date_sub(min(date_received),30) as start_date,
        date_add(max(date_received),30) as end_date
    from {{ source('silver', 'complaints_silver') }}
),
date_spine as (
    select explode(sequence(start_date,end_date, interval 1 day)) as date
    from bounds
)
select 
    cast(date_format(date,'yyyyMMdd') as int) as date_key,
    cast(date as date) as date,
    year(date) as year,
    quarter(date) as quarter,
    month(date) as month,
    date_format(date,'MMMM') as month_name,
    weekofyear(date) as week_of_year,
    dayofmonth(date) as day_of_month,
    date_format(date,'EEEE') as day_name
from date_spine