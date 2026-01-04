select count(*)
from {{ ref('gold_spike_alerts') }}