select date_received,company,product,state
from {{ ref('gold_baselines_daily') }}
group by date_received,company,product,state
having count(*) > 1