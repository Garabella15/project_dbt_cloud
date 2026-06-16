{{ config(alias='dim_customer',
materialized='table') }}


WITH customer_info AS (

    SELECT * FROM {{ ref('int_sales__orders') }}
  

)

select 
    md5(concat(first_name,'||',last_name)) as customer_skey,
    row_number() over ( order by customer_skey) as customer_id,
    first_name,  
    last_name,
    card_number
from customer_info
order by customer_id