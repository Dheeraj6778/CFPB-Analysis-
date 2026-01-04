select date_received,company,product,state
from {{ ref('gold_spike_alerts') }}
group by date_received,company,product,state
having count(*) > 1