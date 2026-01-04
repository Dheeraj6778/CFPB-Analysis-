
with cte_base as (
    select product,sub_product
    from {{ source('silver', 'complaints_silver') }}
    group by product,sub_product
)
select md5(concat(product,sub_product)) as product_key,
       product,
       sub_product
from cte_base
