{{ config(alias='sales_per_store',
materialized='table') }}



select 
s.store_id,
s.store_name,
sum(fct.price) as total_sales
from {{ ref('fact_order') }} fct 
inner join {{ ref('dim_store') }} s 
    on s.store_id = fct.store_id
group by all
order by 1