{{ config(alias='fact_orders',
materialized='table') }}


WITH transaction_info AS (

    SELECT *  FROM {{ ref('int_sales__orders') }}
  
)
select distinct
concat(fct.transaction_id,'||', dp.product_id,'||',dc.customer_id) as transaction_skey,
fct.transaction_id,
fct.transaction_date,
dp.product_id,
fct.price,
fct.payment_method,
ds.store_id,
dc.customer_id,
current_timestamp() as load_datetime
from transaction_info as fct
left join {{ ref('dim_store') }} as ds 
    on fct.store_location = ds.store_name
left join {{ ref('dim_customer') }} as dc
    on    fct.first_name = dc.first_name  
    and   fct.last_name = dc.last_name
left join {{ ref('dim_product') }} dp 
    on dp.product_name = fct.product_name