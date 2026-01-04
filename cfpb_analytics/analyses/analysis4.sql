select count(*)
from {{ ref('gold_complaints_daily') }}
where state is null