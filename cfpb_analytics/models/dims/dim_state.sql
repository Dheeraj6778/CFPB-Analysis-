with cte_state as (
  select distinct upper(coalesce(trim(state), 'UNKNOWN')) as state
  from {{ ref('gold_complaints_daily') }}
)
select
  row_number() over (order by state) as state_key,
  state
from cte_state
