

select count(date_received,company,product,state)
from {{ source('silver', 'complaints_silver') }}


