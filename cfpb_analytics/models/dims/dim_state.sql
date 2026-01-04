with cte_state as (
  select distinct upper(coalesce(trim(state), 'UNKNOWN')) as state
  from {{ source('silver', 'complaints_silver') }}
)
select
  row_number() over (order by state) as state_key,
  state
from cte_state
