{{ config(alias='total_sales_per_product_per_location',
materialized='table') }}



select 
p.product_id,
product_name,
ds.store_name,
sum(fct.price) as total_sales
from {{ ref('fact_order') }} fct 
inner join {{ ref('dim_product') }} p 
    on p.product_id = fct.product_id
inner join {{ ref('dim_store') }} ds
    on ds.store_id = fct.store_id
group by all
order by total_sales desc 