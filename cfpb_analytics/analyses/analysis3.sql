
select date_received, company, product, state, count(*)
from {{ ref('gold_complaints_daily') }}
group by 1,2,3,4
