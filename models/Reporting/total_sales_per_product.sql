{{ config(alias='total_sales_per_product',
materialized='table') }}



select 
p.product_id,
product_name,
sum(fct.price) as total_sales
from {{ ref('fact_order') }} fct 
inner join {{ ref('dim_product') }} p 
    on p.product_id = fct.product_id
group by all
order by total_sales desc 
limit 20