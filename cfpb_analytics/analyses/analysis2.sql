
select distinct submitted_via
from {{ source('silver', 'complaints_silver') }}