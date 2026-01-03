

select *
from {{ source('silver', 'complaints_silver') }}